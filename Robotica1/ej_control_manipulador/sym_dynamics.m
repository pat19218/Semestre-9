% =========================================================================
% EJEMPLO: Manipulador RRR
% -------------------------------------------------------------------------
% Derivación simbólica de la dinámica de un manipulador RRR espacial 
% (también llamado brazo antropomórfico) empleando Euler-Lagrange
% =========================================================================
clear all;
% Especificaciones geométricas
syms r0 r1 r2 ell0 ell1 ell2 g
% Especificaciones dinámicas
syms m1 m2 m3 Ix1 Iy1 Iz1 Ix2 Iy2 Iz2 Ix3 Iy3 Iz3
% Coordenadas y velocidades generalizadas
syms q1 q2 q3 dq1 dq2 dq3
% Variables de control
syms u1 u2 u3

% Vectores de coordenadas, velocidades y control
q = [q1; q2; q3];
dq = [dq1; dq2; dq3];
u = [u1; u2; u3];

% Poses de los COMs de los eslabones
BT_ell1 = trotz(q1)*transl(0,0,r0);
BT_ell2 = trotz(q1)*transl(0,0,ell0)*trotx(-q2)*transl(0,r1,0);
BT_ell3 = trotz(q1)*transl(0,0,ell0)*trotx(-q2)*transl(0,ell1,0)*...
    trotx(-q3)*transl(0,r2,0);

% Posiciones de los COMs de los eslabones
p_ell1 = BT_ell1(1:3,4);
p_ell2 = BT_ell2(1:3,4);
p_ell3 = BT_ell3(1:3,4);

% Orientaciones de los COMs de los eslabones
BR_ell1 = BT_ell1(1:3,1:3);
BR_ell2 = BT_ell2(1:3,1:3);
BR_ell3 = BT_ell3(1:3,1:3);

% Poses de las juntas 
% OJO: la pose de las juntas se considera en el cuerpo "parent", es decir, 
% antes de ejecutar la rotación de la revoluta o la traslación de la 
% prismática. Por esta razón, por ejemplo, no se toma el efecto de la 
% revoluta 1 en la pose de la revoluta 1. Tome nota de esto ya que las 
% siguientes poses no coincidirán exactamente con las obtenidas línea por 
% línea bajo la convención de Denavit Hartenberg, ya que en ese método se 
% describen las poses de junta a junta y no de las juntas con respecto del 
% inercial. Otra forma de pensarlo es que lo que se está buscando es la 
% pose del eje del motor de la revoluta, por ejemplo.
% {0} = Base/revoluta 1, {1} = revoluta 2, {2} = revoluta 3
BT_0 = sym(eye(4));
BT_1 = trotz(q1)*transl(0,0,ell0)*troty(-sym(pi)/2); 
BT_2 = trotz(q1)*transl(0,0,ell0)*troty(-sym(pi)/2)*trotz(q2)*transl(0,ell1,0);

% Posiciones de las juntas
p0 = BT_0(1:3,4);
p1 = BT_1(1:3,4);
p2 = BT_2(1:3,4);

% Ejes de movimiento de las juntas
z0 = BT_0(1:3,3);
z1 = BT_1(1:3,3);
z2 = BT_2(1:3,3);

% Jacobianos de los COMs de los eslabones
% (empleando el método propuesto en el libro de Siciliano)
J1 = sym(zeros(6,3));
J2 = sym(zeros(6,3));
J3 = sym(zeros(6,3));

% Jacobiano COM1
J1(:,1) = [skew(z0)*(p_ell1-p0); z0];
J1 = simplify(J1);
bJ1 = simplify([BR_ell1.', sym(zeros(3,3)); sym(zeros(3,3)), BR_ell1.']*J1);

% Jacobiano COM2
J2(:,1) = [skew(z0)*(p_ell2-p0); z0];
J2(:,2) = [skew(z1)*(p_ell2-p1); z1];
J2 = simplify(J2);
bJ2 = simplify([BR_ell2.', sym(zeros(3,3)); sym(zeros(3,3)), BR_ell2.']*J2);

% Jacobiano COM3
J3(:,1) = [skew(z0)*(p_ell3-p0); z0];
J3(:,2) = [skew(z1)*(p_ell3-p1); z1];
J3(:,3) = [skew(z2)*(p_ell3-p2); z2];
J3 = simplify(J3);
bJ3 = simplify([BR_ell3.', sym(zeros(3,3)); sym(zeros(3,3)), BR_ell3.']*J3);

% Matrices de inercia generalizada (expresadas en las coordenadas del COM 
% de los eslabones y alineadas con los ejes principales de inercia, es 
% decir, con el centro geométrico de los cuerpos rígidos)
bM1 = [m1*eye(3), zeros(3,3); zeros(3,3), diag([Ix1,Iy1,Iz1])];
bM2 = [m2*eye(3), zeros(3,3); zeros(3,3), diag([Ix2,Iy2,Iz2])];
bM3 = [m3*eye(3), zeros(3,3); zeros(3,3), diag([Ix3,Iy3,Iz3])];

% Matriz de inercia del manipulador
D(q1,q2,q3) = simplify(bJ1.'*bM1*bJ1 + bJ2.'*bM2*bJ2 + bJ3.'*bM3*bJ3);

% Alturas de los COMs de los eslabones
h1 = p_ell1(3);
h2 = p_ell2(3);
h3 = p_ell3(3);

% Energía potencial del manipulador
P(q1,q2,q3) = m1*g*h1 + m2*g*h2 + m3*g*h3;

% Vector de fuerza gravitacional
G(q1,q2,q3) = simplify(gradient(P(q1,q2,q3), [q1,q2,q3]));

% Símbolos de Christoffel
Gamma = sym(zeros(3,3,3));
C = sym(zeros(3,3));

Dd = D(q1,q2,q3);

for i = 1:3
    for j = 1:3
        for k = 1:3
            Gamma(i,j,k) = diff(Dd(i,j), q(k)) + diff(Dd(i,k), q(j)) - ...
                diff(Dd(k,j), q(i));
            Gamma(i,j,k) = simplify(Gamma(i,j,k) / 2); 
            
            C(i,j) = C(i,j) + Gamma(i,j,k)*dq(k); 
        end
    end 
end

% Matriz de Coriolis
C(q1,q2,q3,dq1,dq2,dq3) = simplify(C);

% Matriz de actuadores 
B(q1,q2,q3) = sym(eye(3));

%% Jacobiano (geométrico) del manipulador
% Pose del efector final
BT_E = trotz(q1)*transl(0,0,ell0)*trotx(-q2)*transl(0,ell1,0)*...
    trotx(-q3)*transl(0,r2,0);
fK(q1,q2,q3) = BT_E; 

% Posición del efector final
p_E = BT_E(1:3,4);

% Jacobiano del efector final
Je = sym(zeros(6,3));
Je(:,1) = [skew(z0)*(p_E-p0); z0];
Je(:,2) = [skew(z1)*(p_E-p1); z1];
Je(:,3) = [skew(z2)*(p_E-p2); z2];
Je(q1,q2,q3) = Je;

% Derivada de tiempo del jacobiano del efector final
syms t q_1(t) q_2(t) q_3(t)
Jet = Je(q_1(t),q_2(t),q_3(t));
dJet = simplify(diff(Jet, t));
dJet = subs(dJet, [q_1(t), q_2(t), q_3(t), diff(q_1(t),t), diff(q_2(t),t),...
    diff(q_3(t),t)], [q1, q2, q3, dq1, dq2, dq3]);
dJe(q1,q2,q3,dq1,dq2,dq3) = dJet;

%% Generación de archivos (NO MODIFICAR)
% Estandarización de funciones simbólicas antes de generar los archivos
% auxiliares

% Dinámica
D(q1,q2,q3,dq1,dq2,dq3,r0,r1,r2,ell0,ell1,ell2,g,m1,m2,m3,Ix1,Iy1,Iz1,...
    Ix2,Iy2,Iz2,Ix3,Iy3,Iz3) = simplify(D(q1,q2,q3));
G(q1,q2,q3,dq1,dq2,dq3,r0,r1,r2,ell0,ell1,ell2,g,m1,m2,m3,Ix1,Iy1,Iz1,...
    Ix2,Iy2,Iz2,Ix3,Iy3,Iz3) = simplify(G(q1,q2,q3));
C(q1,q2,q3,dq1,dq2,dq3,r0,r1,r2,ell0,ell1,ell2,g,m1,m2,m3,Ix1,Iy1,Iz1,...
    Ix2,Iy2,Iz2,Ix3,Iy3,Iz3) = simplify(C(q1,q2,q3,dq1,dq2,dq3));
B(q1,q2,q3,dq1,dq2,dq3,r0,r1,r2,ell0,ell1,ell2,g,m1,m2,m3,Ix1,Iy1,Iz1,...
    Ix2,Iy2,Iz2,Ix3,Iy3,Iz3) = simplify(B(q1,q2,q3));

% % Restricciones y control
fK(q1,q2,q3,dq1,dq2,dq3,r0,r1,r2,ell0,ell1,ell2,g,m1,m2,m3,Ix1,Iy1,...
    Iz1,Ix2,Iy2,Iz2,Ix3,Iy3,Iz3) = simplify(fK(q1,q2,q3));
Je(q1,q2,q3,dq1,dq2,dq3,r0,r1,r2,ell0,ell1,ell2,g,m1,m2,m3,Ix1,Iy1,...
    Iz1,Ix2,Iy2,Iz2,Ix3,Iy3,Iz3) = simplify(Je(q1,q2,q3));
dJe(q1,q2,q3,dq1,dq2,dq3,r0,r1,r2,ell0,ell1,ell2,g,m1,m2,m3,Ix1,Iy1,...
    Iz1,Ix2,Iy2,Iz2,Ix3,Iy3,Iz3) = simplify(dJe(q1,q2,q3,dq1,dq2,dq3));

% Generación de funciones auxiliares para efectuar la simulación de la
% dinámica del manipulador en robotsim.m
matlabFunction(D, 'file', 'inertia_matrix.m');
matlabFunction(C, 'file', 'coriolis_matrix.m');
matlabFunction(G, 'file', 'gravity_terms.m');
matlabFunction(B, 'file', 'coupling_matrix.m');
matlabFunction(fK, 'file', 'fwd_kinematics.m');
matlabFunction(Je, 'file', 'ef_jacobian.m');
matlabFunction(dJe, 'file', 'ef_jacobian_dt.m');
