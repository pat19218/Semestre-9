% constantes del sistema
g = 9.81;
l = 1;
m = 1;

% matrices del sistema linealizado
A = [0 1; g/l 0];
B = [0; -1/(l*m)];

% estado deseado y entrada deseada
x_des = [pi; 0];
u_des = 0;

% matrices de costo del LQR
Q = diag([1 1]);
R = 0.1;

% cálculo de la ganancia de retroalimentación de estado utilizando LQR
[K, ~, ~] = lqr(A, B, Q, R);

% límites de la optimización
lb = -5;
ub = 5;

% estado inicial del sistema
theta0 = 0;
theta_dot0 = 0;
x0 = [theta0; theta_dot0];

% paso de tiempo de la simulación
dt = 0.01;

% tiempo de simulación
tspan = 0:dt:10;

% solución del sistema utilizando ode45 y fmincon
options = optimoptions('fmincon', 'Display', 'iter');
[t, x] = ode45(@(t, x) pendulum_dynamics(x, -K*(x - x_des)), tspan, x0);
u_opt = zeros(size(t));
for i = 1:length(t)
    u_opt(i) = fmincon(@(u) objective([x(i, :)'; u], x_des, u_des, Q, R, dt), 0, [], [], [], [], lb, ub, [], options);
end

% gráfica de la posición del péndulo
figure();
plot(t, x(:, 1));
xlabel('Tiempo (s)');
ylabel('Posición del péndulo (rad)');
title('Posición del péndulo vs Tiempo');

% gráfica del control óptimo
figure();
plot(t, u_opt);
xlabel('Tiempo (s)');
ylabel('Control óptimo (Nm)');
title('Control óptimo vs Tiempo');

function x_dot = pendulum_dynamics(x, u)
% constantes del sistema
g = 9.81;
l = 1;
m = 1;

% dinámica del sistema
x_dot = zeros(size(x));
x_dot(1) = x(2);
x_dot(2) = -g/l*sin(x(1)) - u/(l*m);
end

function J = objective(x, x_des, u_des, Q, R, dt)
% separación del estado y la entrada
x = x(:);
theta = x(1);
theta_dot = x(2);
u = x(3);

% términos del costo
x_err = x - [x_des; u_des];
J = (0.5).*(x_err'*Q*x_err + R*u^2)*dt;

% restricciones de la optimización
c = [theta - pi; -theta; u + 5; -u + 5];
J = J + 1e3*sum(max(c, 0).^2);
end
