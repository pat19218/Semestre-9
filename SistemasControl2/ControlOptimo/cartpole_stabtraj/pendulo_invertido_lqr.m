clear all;clc;

%% Parámetros del sistema
m = 0.3;
M = 1;
ell = 0.5;
g = 9.81;

%% Funciones auxiliares para la simulación/animación
% q = [x theta] dq = [dx dtheta]
% Posición de la masa
p = @(q) [q(1)+ell*sin(q(2)); -ell*cos(q(2))];

%% Parámetros de la simulación
t0 = 0;
tf = 5; % tiempo de simulación
dt = 0.01; % tiempo de muestreo
N = (tf - t0) / dt;

%% Inicialización y condiciones iniciales
% x0 = [0; 0.1; 0; 0];
x0 = [0; 0; 0; 0] + 0.5; 
u0 = 0;
x = x0; % vector de estado 
u = u0; % vector de entradas
% Arrays para almacenar las trayectorias de las variables de estado,
% entradas y salidas del sistema
X = zeros(numel(x),N+1);
U = zeros(numel(u),N+1);
% Inicialización de arrays
X(:,1) = x0;
U(:,1) = u0;

%% Se carga la trayectoria óptima a rastrear
load optctrlres

%% Se calcula el control LQR variante en el tiempo
Q = eye(4);
R = eye(1);
S = 10*eye(4);
Klqr1 = traj_stabilize_lqr(@dynamics, Xd, Ud, Q, R, S, td(1), td(end), td(2)-td(1));

%% Control LQR para el final de la trayectoria
use_lqr = 1;
xss = [1; pi; 0; 0];
uss = 0;
[A,B,~,~] = loclin_best(@dynamics, @dynamics, xss, uss);
Q = eye(4);
R = eye(1);
Klqrf = lqr(A,B,Q,R);

%% Solución recursiva del sistema dinámico
for n = 0:N
    % Entrada
    if(n < length(Ud))
%         u = Ud(:,n+1);
        u = -Klqr1(:,:,n+1)*(x - Xd(:,n+1)) + Ud(:,n+1);
        if(n == 30)
            u = u - 50;
        end
    else
%         u = 0;
        u = -Klqrf*(x - xss) + uss;
    end
   
    % Método RK4 para la aproximación numérica de la solución
    k1 = dynamics(x, u);
    k2 = dynamics(x+(dt/2)*k1, u);
    k3 = dynamics(x+(dt/2)*k2, u);
    k4 = dynamics(x+dt*k3, u);
    x = x + (dt/6)*(k1+2*k2+2*k3+k4);
    
    % Se guardan las trayectorias del estado y las entradas
    X(:,n+1) = x;
    U(:,n+1) = u;
end

%% Animación y generación de figuras (NO MODIFICAR)
t = t0:dt:tf;
figure('units','normalized','outerposition',[0 0 1 1]);
plot(t, X', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$x(t)$', '$\theta(t)$', '$\dot{x}(t)$', '$\dot{\theta}(t)$', ...
    'Location', 'northeast', 'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 14);
grid minor;

figure;
plot(t, U', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$u(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
set(l, 'Interpreter', 'latex', 'FontSize', 14);
grid minor;

figure('units','normalized','outerposition',[0 0 1 1]);
s = 3;
r = 0.1;
csize = 1;
xlim(s*[-3, 3]);
ylim(s*[-1, 1]);
grid off;
hold on;
plot([-3*s,3*s], [0,0], '--k', 'LineWidth', 2);

q = X(1:2, 1);
x = q(1);
lp = p(q); xp = lp(1); yp = lp(2);
h1 = plot([x-csize/2, x+csize/2], [0,0], 'Color', ...
    [0.4660, 0.6740, 0.1880], 'LineWidth', 10);
h = plot([x, xp], [0, yp], 'Color', [0.5, 0.5, 0.5], 'LineWidth', 3);
c = circle(xp,yp,r);

for n = 2:N+1
    q = X(1:2,n);
    x = q(1);
    lp = p(q); xp = lp(1); yp = lp(2);
    h1.XData = [x-csize/2, x+csize/2];
    h.XData = [x, xp];
    h.YData = [0, yp];
    c.Position(1:2) = [xp-r, yp-r];
    pause(dt);
end