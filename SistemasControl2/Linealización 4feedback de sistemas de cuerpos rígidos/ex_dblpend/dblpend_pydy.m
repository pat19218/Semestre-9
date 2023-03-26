% =========================================================================
% IE3041 - EJEMPLO MODELADO PÉNDULO DOBLE (CON PYDY)
% -------------------------------------------------------------------------
% Se presenta la simulación del modelo para el péndulo doble derivado
% empleando la herramienta PyDy.
% =========================================================================
clear all;
%% Parámetros del sistema
m = 1; % kg, se asume la misma masa para ambos péndulos
l = 1; % m, se asume la misma longitud para ambos péndulos
g = 9.81; % m/s^2


%% Parámetros de la simulación
t0 = 0; % tiempo inicial
tf = 10; % tiempo (final) de simulación
dt = 0.01; % período de muestreo
K = (tf - t0) / dt;


%% Inicialización y condiciones iniciales
x0 = [pi+0.1, pi+0.1, 0, 0]'; % condiciones iniciales
x = x0; % vector de estado
% Array para almacenar las trayectorias de las variables de estado
X = zeros(numel(x0), K+1); X(:,1) = x;


%% Solución recursiva del sistema dinámico
for k = 1:K
    % Método RK4 para la aproximación numérica de la solución
    k1 = dynamics_pydy(x);
    k2 = dynamics_pydy(x+(dt/2)*k1);
    k3 = dynamics_pydy(x+(dt/2)*k2);
    k4 = dynamics_pydy(x+dt*k3);
    x = x + (dt/6)*(k1+2*k2+2*k3+k4);
    
    % Se guardan las trayectorias del vector de estado
    X(:, k+1) = x;
end




%% Animación y generación de figuras (NO modificar)
figure;
t = t0:dt:tf;
plot(t, X', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
lg = legend('$q_1(t)$', '$q_2(t)$', '$u_1(t)$', '$u_2(t)$', ...
    'Location', 'northwest', 'Orientation', 'horizontal');
set(lg, 'Interpreter', 'latex', 'FontSize', 12);

figure;
s = 3;
xlim(s*[-1, 1]);
ylim(s*[-1, 1]);
grid off;
hold on;

x = X(:, 1);
q1 = x(1);
q2 = x(2);
p1 = [l*sin(q1); -l*cos(q1)];
p2 = p1 + [l*sin(q2); -l*cos(q2)];
h1 = plot([0,p1(1),p2(1)], [0,p1(2),p2(2)], 'Color', [0.5, 0.5, 0.5], 'LineWidth', 3);
h2 = plot(p2(1), p2(2), 'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 1);
c1 = circle(p1(1),p1(2),0.1);
c2 = circle(p2(1),p2(2),0.1);

for k = 2:K+1
    x = X(:, k);
    q1 = x(1);
    q2 = x(2);
    p1 = [l*sin(q1); -l*cos(q1)];
    p2 = p1 + [l*sin(q2); -l*cos(q2)];
    
    h1.XData = [0,p1(1),p2(1)];
    h1.YData = [0,p1(2),p2(2)];
    c1.Position(1:2) = [p1(1)-0.1, p1(2)-0.1];
    c2.Position(1:2) = [p2(1)-0.1, p2(2)-0.1];
    
    h2.XData = [h2.XData, p2(1)];
    h2.YData = [h2.YData, p2(2)];
    
    pause(dt);
end