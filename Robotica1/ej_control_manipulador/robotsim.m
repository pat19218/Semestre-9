clear all;
% =========================================================================
% CONTROL DE UN MANIPULADOR RRR
% -------------------------------------------------------------------------
% El siguiente script realiza la simulación de un manipulador RRR luego de
% aplicarle alguno de los casos de control especificados en la función
% control.m
% =========================================================================
%% Parámetros geométricos del sistema
% Se asume que todos los eslabones son cilindros de largo ell_i y diámetro
% d_i
ell0 = 0.5; % m
ell1 = 1; % m
ell2 = 1; % m
r0 = ell0/2; % m
r1 = ell1/2; % m
r2 = ell2/2; % m
d1 = 0.5; % m
d2 = 0.5; % m
d3 = 0.5; % m

%% Parámetros dinámicos del sistema
g = 9.81; % m/s^2
m1 = 0.5; % kg
m2 = 1; % kg
m3 = 1; % kg

Ix1 = (1/12)*m1*(3*(d1/2)^2 + ell0^2); % kg m^2
Iy1 = Ix1; % kg m^2
Iz1 = (1/2)*m1*(d1/2)^2; % kg m^2

Ix2 = (1/12)*m2*(3*(d2/2)^2 + ell1^2); % kg m^2
Iy2 = (1/2)*m2*(d2/2)^2; % kg m^2
Iz2 = Ix2; % kg m^2

Ix3 = (1/12)*m3*(3*(d3/2)^2 + ell2^2); % kg m^2
Iy3 = (1/2)*m3*(d3/2)^2; % kg m^2
Iz3 = Ix3; % kg m^2

%% Definición de la dinámica del manipulador
% Funciones referentes a la dinámica del manipulador. La idea es poder 
% llamar las cantidades de una manera más compacta, por ejemplo, llamar
% a la matriz de inercia D(q), según su definición analítica.

% -------------------------------------------------------------------------
% DINÁMICA SIN RESTRICCIONES
% -------------------------------------------------------------------------
% Matriz de inercia
D = @(q) inertia_matrix(q(1),q(2),q(3),0,0,0,r0,r1,r2,ell0,ell1,ell2,g,...
    m1,m2,m3,Ix1,Iy1,Iz1,Ix2,Iy2,Iz2,Ix3,Iy3,Iz3);

% Matriz de Coriolis
C = @(q,dq) coriolis_matrix(q(1),q(2),q(3),dq(1),dq(2),dq(3),r0,r1,r2,...
    ell0,ell1,ell2,g,m1,m2,m3,Ix1,Iy1,Iz1,Ix2,Iy2,Iz2,Ix3,Iy3,Iz3);

% Vector de fuerzas gravitatorias
G = @(q) gravity_terms(q(1),q(2),q(3),0,0,0,r0,r1,r2,ell0,ell1,ell2,g,...
    m1,m2,m3,Ix1,Iy1,Iz1,Ix2,Iy2,Iz2,Ix3,Iy3,Iz3); 

% Matriz de acople
B = @(q) coupling_matrix(q(1),q(2),q(3),0,0,0,r0,r1,r2,ell0,ell1,ell2,g,...
    m1,m2,m3,Ix1,Iy1,Iz1,Ix2,Iy2,Iz2,Ix3,Iy3,Iz3);

% Versión de la dinámica que permite una solución de la ODE empleando
% una matriz de masa en el solver stiff ode15s
ff = @(x) [ D(x(1:3))*x(4:6); 
             -C(x(1:3), x(4:6))*x(4:6) - G(x(1:3)) ];
fg = @(x) [ zeros(3,3); B(x(1:3)) ];
M = @(x) [D(x(1:3)), zeros(3,3); zeros(3,3), D(x(1:3))];

% -------------------------------------------------------------------------
% CONTROL
% -------------------------------------------------------------------------
% Cinemática directa del manipulador
fK = @(q) fwd_kinematics(q(1),q(2),q(3),0,0,0,r0,r1,r2,ell0,ell1,ell2,g,...
    m1,m2,m3,Ix1,Iy1,Iz1,Ix2,Iy2,Iz2,Ix3,Iy3,Iz3); 

% Jacobiano geométrico del manipulador
J = @(q) ef_jacobian(q(1),q(2),q(3),0,0,0,r0,r1,r2,ell0,ell1,ell2,g,...
    m1,m2,m3,Ix1,Iy1,Iz1,Ix2,Iy2,Iz2,Ix3,Iy3,Iz3); 

% Derivada del jacobiano del manipulador
dJdt = @(q,dq) ef_jacobian_dt(q(1),q(2),q(3),dq(1),dq(2),dq(3),r0,r1,r2,...
    ell0,ell1,ell2,g,m1,m2,m3,Ix1,Iy1,Iz1,Ix2,Iy2,Iz2,Ix3,Iy3,Iz3); 

% Control no lineal con state feedback
u = @(t,x) control(t,x(1:3),x(4:6),D(x(1:3)),C(x(1:3),x(4:6)),G(x(1:3)),...
    B(x(1:3)),fK(x(1:3)),J(x(1:3)),dJdt(x(1:3),x(4:6)),0,0,0);

% Dinámica del robot en forma de un sistema de control no lineal
dynamics = @(t,x) ff(x) + fg(x)*u(t,x);

%% Parámetros de la simulación
t0 = 0; % tiempo inicial
tf = 10; % tiempo final

%% Inicialización y condiciones iniciales
x0 = [0; pi/2+0.1; 0; 0; 0; 0];
x = x0; % vector de estado

%% Solución numérica de las ODEs
% Se establece el uso de una matriz de masa
Mass = @(t,x) M(x);
opts = odeset('Mass', Mass, 'MStateDependence', 'strong');

% Se emplea el solver rígido ode15s para resolver la EDO del robot
odefun = @(t,x) dynamics(t,x);
tspan = [t0, tf];
[t, X] = ode15s(odefun, tspan, x0, opts);
X = X'; % Array que contiene la secuencia de variables de estado

% Se selecciona si se quieren visualizar las entradas de control
plot_inputs = 1;

%% Generación de figuras (NO modificar)
% Trayectorias de las variables de estado
figure;
plot(t, X', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$q_1(t)$', '$q_2(t)$', '$q_3(t)$', '$\dot{q}_1(t)$', ...
    '$\dot{q}_2(t)$', '$\dot{q}_3(t)$', 'Location', 'southeast', ...
    'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 16);
grid minor;
axis square;

% Entradas al sistema
if(plot_inputs)
    U = zeros(size(B(rand(3,1)),2), size(X,2));
    for i = 1:size(X,2)
        U(:,i) = u(t(i), X(:,i));
    end
    figure;
    plot(t, U', 'LineWidth', 1);
    xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
    ylabel('$\mathbf{u}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
    l = legend('$u_1(t)$', '$u_2(t)$', '$u_3(t)$', 'Location', ...
        'southeast', 'Orientation', 'horizontal');
    set(l, 'Interpreter', 'latex', 'FontSize', 16);
    grid minor;
    axis square;
end

% Matriz de Denavit-Hartenberg del manipulador (se coloca el offset en las 
% casillas de las coordenadas generalizadas)
DH = [pi/2, ell0,    0, -pi/2;
         0,    0, ell1,     0; 
         0,    0, ell2,  pi/2];

% Transformación de base     
IT_B = eye(4); % transformación de base

% Se extraen las trayectorias de la configuración del robot y se anima el
% comportamiento del manipulador completo
Q = X(1:3,:);
rplot = robotPlot3(DH, IT_B, Q, t, 'RRR', 3, 10);