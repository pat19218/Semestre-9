clear all;
% =========================================================================
% IE3041 - Estabilización del péndulo doble con control LTI
% -------------------------------------------------------------------------
% El siguiente script implementa la simulación de un péndulo doble con 
% torques de entrada en cada una de las articulaciones. Estos se emplean
% para implementar un controlador LTI obtenido a partir de la linealización
% del sistema alrededor de un punto de operación especificado.
% =========================================================================
%% Opciones de cálculos y visualización
% -------------------------------------------------------------------------
% Parámetros del sistema
m1 = 0.5; 
m2 = 0.5; 
l1 = 1; 
l2 = 1; 
g = 9.81;

% Punto de operación/equilibrio deseado
xss = [pi/4; -pi/4; 0; 0];
% Condición inicial
x0 = xss + 1;
% Ganancia (adicional) para el controlador
ctrlgain = 5;


%% Cálculos, simulación y visualización
% -------------------------------------------------------------------------
% Posiciones de las masas
p1 = @(q) l1*[sin(q(1)); -cos(q(1))]; 
p2 = @(q) p1(q) + l2*[sin(q(1)+q(2)); -cos(q(1)+q(2))];

% Se encuentra el uss para el xss seleccionado
fun = @(u) dynamics(xss, u);
uss = fsolve(fun, [0;0]);
% Se linealiza el sistema alrededor del punto de operación
[A,B,C,D] = loclin_best(@dynamics, @outputs, xss, uss);
% Se encuentra el LQR con la linealización
Klqr = lqr(A,B,eye(4),eye(2));

% Parámetros de la simulación
t0 = 0;
tf = 20; % tiempo de simulación
dt = 0.005; % tiempo de muestreo
K = (tf - t0) / dt;

% Inicialización
x = x0; % vector de estado
u = [0; 0]; % vector de entradas
X = x; % array para almacenar las trayectorias de las variables de estado
U = u; % array para almacenar la evolución de las entradas

% Solución recursiva del sistema dinámico
for k = 0:K-1
    % Torques de entrada (implementación del control)
    u = -ctrlgain*Klqr*(x - xss) + uss;
    
    % Método RK4 para la aproximación numérica de la solución
    k1 = dynamics(x, u);
    k2 = dynamics(x+(dt/2)*k1, u);
    k3 = dynamics(x+(dt/2)*k2, u);
    k4 = dynamics(x+dt*k3, u);
    x = x + (dt/6)*(k1+2*k2+2*k3+k4);
    
    % Se guardan las trayectorias del estado y las entradas
    X = [X, x];
    U = [U, u];
end

% -------------------------------------------------------------------------
% ANIMACIÓN Y GENERACIÓN DE FIGURAS (NO MODIFICAR)
% -------------------------------------------------------------------------
figure;
t = t0:dt:tf;
subplot(2,1,1);
plot(t, X', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$q_1(t)$', '$q_2(t)$', '$\dot{q}_1(t)$', '$\dot{q}_2(t)$', ...
    'Location', 'southwest', 'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 12);

subplot(2,1,2);
plot(t, U', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{u}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$u_1(t)$', '$u_2(t)$', 'Location', 'southwest', ...
    'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 12);

figure;
s = 3;
r = 0.1;
xlim(s*[-1, 1]);
ylim(s*[-1, 1]);
grid off;
hold on;

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