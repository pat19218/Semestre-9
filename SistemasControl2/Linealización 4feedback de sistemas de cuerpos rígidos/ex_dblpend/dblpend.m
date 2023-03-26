% =========================================================================
% IE3041 - EJEMPLO MODELADO PÉNDULO DOBLE (CON EULER-LAGRANGE)
% -------------------------------------------------------------------------
% Se presenta la simulación del modelo para el péndulo doble derivado
% directamente con las ecuaciones de Euler-Lagrange.
% =========================================================================
clear all;
%% Parámetros del sistema
m1 = 0.5; % kg
m2 = 0.5; % kg
l1 = 1; % m
l2 = 1; % m
g = 9.81; %m/s^2


%% Parámetros de la simulación
t0 = 0; % tiempo inicial
tf = 20; % tiempo (final) de simulación
dt = 0.005; % período de muestreo
K = (tf - t0) / dt; % número de iteraciones


%% Inicialización y condiciones iniciales
x0 = [pi+0.1; 0; 0; 0]; % condiciones iniciales
x = x0; % vector de estado
u0 = [0; 0]; % entradas iniciales
u = u0; % vector de entradas

% Array para almacenar las trayectorias de las variables de estado
X = zeros(numel(x0), K+1); X(:,1) = x;
% Array para almacenar la evolución de las entradas 
U = zeros(numel(u0), K+1); U(:,1) = u;


%% Solución recursiva del sistema dinámico
for k = 1:K
    % Torques de entrada
    u = [0; 0];

    % Método RK4 para la aproximación numérica de la solución
    k1 = dynamics(x, u);
    k2 = dynamics(x+(dt/2)*k1, u);
    k3 = dynamics(x+(dt/2)*k2, u);
    k4 = dynamics(x+dt*k3, u);
    x = x + (dt/6)*(k1+2*k2+2*k3+k4);
    
    % Se guardan las trayectorias de los vectores de estado y entrada
    X(:, k+1) = x;
    U(:, k+1) = u;
end




%% Animación y generación de figuras (NO modificar)
figure;
t = t0:dt:tf;
plot(t, X', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$q_1(t)$', '$q_2(t)$', '$\dot{q}_1(t)$', '$\dot{q}_2(t)$', ...
    'Location', 'southwest', 'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 12);

figure;
s = 3;
r = 0.1;
xlim(s*[-1, 1]);
ylim(s*[-1, 1]);
grid off;
hold on;

% Posiciones de las masas
p1 = @(q) l1*[sin(q(1)); -cos(q(1))]; 
p2 = @(q) p1(q) + l2*[sin(q(1)+q(2)); -cos(q(1)+q(2))];

q = X(1:2,1);
r1 = p1(q); x1 = r1(1); y1 = r1(2);
r2 = p2(q); x2 = r2(1); y2 = r2(2);
h1 = plot(x2, y2, 'Color', [0.3010, 0.7450, 0.9330], 'LineWidth', 1);
h = plot([0,x1,x2], [0,y1,y2], 'Color', [0.5, 0.5, 0.5], 'LineWidth', 3);
c1 = circle(x1,y1,r);
c2 = circle(x2,y2,r);

for k = 2:K+1
    q = X(1:2,k);
    r1 = p1(q); x1 = r1(1); y1 = r1(2);
    r2 = p2(q); x2 = r2(1); y2 = r2(2);
    h1.XData = [h1.XData, x2];
    h1.YData = [h1.YData, y2];
    h.XData = [0,x1,x2];
    h.YData = [0,y1,y2];
    c1.Position(1:2) = [x1-r, y1-r];
    c2.Position(1:2) = [x2-r, y2-r];
    pause(dt);
end