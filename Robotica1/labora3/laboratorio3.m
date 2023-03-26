% =========================================================================
% MT3005 - LABORATORIO 3: Ángulos de Euler y transformaciones elementales
% -------------------------------------------------------------------------
% Ver las instrucciones en la guía adjunta
% =========================================================================
%% Inciso 2.
% Sub-inciso (a)
phi1 = 0; 
theta1 = -90;
psi1 = 0;
R = rotz(phi1)*roty(theta1)*rotz(psi1); %Matriz de rotacion
t = [-1;1;0]; %Vector ubicacion del elemento respecto del inercial
AT_D = trans_hom(R, t);

% Sub-inciso (b)
phi2 = 0;
theta2 = 90;
psi2 = 90;
R2 = rotz(phi2)*roty(theta2)*rotx(psi2); %Matriz de rotacion
t2 = [0;0;2]; %Vector ubicacion del elemento respecto del inercial
CT_D = trans_hom(R2, t2);

% Sub-inciso (c)
phi3 = 180;
theta3 = 0;
psi3 = -90;
R3 = rotx(phi3)*roty(theta3)*rotz(psi3); %Matriz de rotacion
t3 = [-1;1;2]; %Vector ubicacion del elemento respecto del inercial
AT_C = trans_hom(R3, t3);

% Sub-inciso (d)
BT_C = [1 0 0 4; 0 1 0 0; 0 0 1 0; 0 0 0 1];
AT_B = AT_C/BT_C;

% Sub-inciso (e)
% Mostrar figura marcos de referencia
IT_A = eye(4);

trplot(IT_A,'color','blue','axes','3');
hold on
trplot(AT_B,'color','yellow');
trplot(AT_C,'color','green');
trplot(AT_D,'color','black');

%% Inciso 3. 
% Sub-inciso (a)
AT_Da = transl(3,3,6); %transl(X, Y, Z)

% Sub-inciso (b)
AT_Db = transl(0,0,2)*transl(3,0,0)*transl(0,0,2)*transl(-3,0,0)*transl(0,3,0)*transl(0,0,2)*transl(3,0,0);

% Sub-inciso (c)
AT_Dc = transl(0,0,2)*troty(90)*transl(0,0,3)*troty(-90)*transl(0,0,2)*troty(-90)*transl(0,0,3)*troty(90)*trotx(-90)*transl(0,0,3)*trotx(90)*transl(0,0,2)*troty(90)*transl(0,0,3)*troty(-90);

% Sub-inciso (d)
R1 = troty(180)*trotz(180)*transl(-3,0,0)*transl(3,3,2)*transl(0,0,4);
R2 = trotx(180)*transl(3,0,0);
AT_Dd = R2*R1;

% Sub-inciso (e)
R3 = troty(-90)*transl(0,0,3)*trotz(90)*troty(90)*transl(0,0,2)*transl(2,0,3)*trotz(90)*troty(-90)*transl(0,0,3)*troty(90)*transl(0,0,2)*troty(90)*transl(0,0,3)*troty(-90)*trotz(-90);R3 = transl(0,6,0)*trotx(-90); 
R4 = transl(3,3,0)*trotx(90);
AT_De = R4*R3;


