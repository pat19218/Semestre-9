clear all;
% =========================================================================
% IE3041 - Micro-parcial 5
% =========================================================================
% Se presenta el siguiente script como base, en donde se realiza la
% simulación de un péndulo simple sin fricción.
% =========================================================================
%% Parámetros y dinámica del sistema
m = 1; % kg
ell = 1; % m
g = 9.81; % m/s^2

% Campo vectorial del sistema (anclado)
dynamics = @(x,u) [                               x(2); 
                    -(g/ell)*sin(x(1)) + (1/m*ell^2)*u ];


%% Parámetros de la simulación
t0 = 0;
tf = 10; % tiempo de simulación
dt = 0.01; % tiempo de muestreo
K = (tf - t0) / dt;

% Condiciones iniciales
x0 = [pi+0.1; 0];

%% Inicialización y condiciones iniciales
u0 = 0;
x = x0; % vector de estado
u = u0; % vector de entradas
% Arrays para almacenar las trayectorias de las variables de estado,
% entradas y salidas del sistema
X = zeros(numel(x),K+1);
U = zeros(numel(u),K+1);
% Inicialización de arrays
X(:,1) = x0;
U(:,1) = u0;

%% Solución recursiva del sistema dinámico
for k = 0:K
    % Se define la entrada para el sistema
    u = 0;

    % Se actualiza el estado del sistema mediante una discretización por 
    % el método de Runge-Kutta (RK4)
    k1 = dynamics(x, u);
    k2 = dynamics(x+(dt/2)*k1, u);
    k3 = dynamics(x+(dt/2)*k2, u);
    k4 = dynamics(x+dt*k3, u);
    x = x + (dt/6)*(k1+2*k2+2*k3+k4);
    
    % Se guardan las trayectorias del estado y las entradas
    X(:,k+1) = x;
    U(:,k+1) = u;
end










%% Generación de figuras (NO modificar)
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

%% Animación (NO modificar)
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