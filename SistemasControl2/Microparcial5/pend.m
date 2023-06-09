clear all;clc;
% =========================================================================
% IE3041 - Micro-parcial 5
% =========================================================================
% Se presenta el siguiente script como base, en donde se realiza la
% simulaci�n de un p�ndulo simple sin fricci�n.
% =========================================================================
%% Par�metros y din�mica del sistema
m = 1; % kg
ell = 1; % m
g = 9.81; % m/s^2

% Campo vectorial del sistema (anclado)
dynamics = @(x,u) [                               x(2); 
                    -(g/ell)*sin(x(1)) + (1/m*ell^2)*u ];

%% Control LQR para el final de la trayectoria
use_lqr = 1;
xss = [pi; 0];
uss = 0;
[A,B,~,~] = linloc(@dynamics, @dynamics, xss, uss);
Q = eye(2);
R = eye(1);
Klqr = lqr(A,B,Q,R);

%% Par�metros de la simulaci�n
t0 = 0;
tf = 10; % tiempo de simulaci�n
dt = 0.01; % tiempo de muestreo
K = (tf - t0) / dt;

% Condiciones iniciales
x0 = [0; 0];

%% Inicializaci�n y condiciones iniciales
u0 = 0;
x = x0; % vector de estado
u = u0; % vector de entradas
% Arrays para almacenar las trayectorias de las variables de estado,
% entradas y salidas del sistema
X = zeros(numel(x),K+1);
U = zeros(numel(u),K+1);
% Inicializaci�n de arrays
X(:,1) = x0;
U(:,1) = u0;

%% Se carga la soluci�n �ptima y se interpola para emplearla como control
load nlpoptres
Uq = interp1(0:Topt/Nopt:Topt, Uopt, t0:dt:Topt);


%% Soluci�n recursiva del sistema din�mico
for k = 0:K
    % Se define la entrada para el sistema
    %u = 0;  %original
    
    % Entrada
    if(k < length(Uq)-170)
        u = Uq(k+1);
        if (k == 30)  %length(Uq) = 501
            u = u -10; 
        end
    else
        u = -Klqr*(x-xss) + uss;
    end
    
    
    % Se actualiza el estado del sistema mediante una discretizaci�n por 
    % el m�todo de Runge-Kutta (RK4)
    k1 = dynamics(x, u);
    k2 = dynamics(x+(dt/2)*k1, u);
    k3 = dynamics(x+(dt/2)*k2, u);
    k4 = dynamics(x+dt*k3, u);
    x = x + (dt/6)*(k1+2*k2+2*k3+k4);
    
    % Se guardan las trayectorias del estado y las entradas
    X(:,k+1) = x;
    U(:,k+1) = u;
end
U(:,k-19) = 20;
U(:,k-20) = 20;
U(:,k-21) = 20;

%% Generaci�n de figuras (NO modificar)
figure;
t = t0:dt:tf;
subplot(2,1,1);
plot(t, X', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$q(t)$', '$\dot{q}(t)$', 'Location', 'southwest', ...
    'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 12);

subplot(2,1,2);
plot(t, U', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{u}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$u_1(t)$', '$u_2(t)$', 'Location', 'southwest', ...
    'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 12);

%% Animaci�n (NO modificar)
% Posiciones de las masas
p1 = @(q) ell*[sin(q(1)); -cos(q(1))]; 

figure;
s = 3;
r = 0.1;
xlim(s*[-1, 1]);
ylim(s*[-1, 1]);
grid off;
hold on;

q = X(1,1);
r1 = p1(q); x1 = r1(1); y1 = r1(2);
h = plot([0,x1], [0,y1], 'Color', [0.5, 0.5, 0.5], 'LineWidth', 3);
c1 = circle(x1,y1,r);

for k = 2:K+1
    q = X(1,k);
    r1 = p1(q); x1 = r1(1); y1 = r1(2);
    h.XData = [0,x1];
    h.YData = [0,y1];
    c1.Position(1:2) = [x1-r, y1-r];
    pause(dt);
end