clear all; clc;

%% Parámetros de la colocación
T = 5; % tiempo final de la trayectoria
N = 50; % número de segmentos
M = N + 1; % número de puntos de colocación
n = 2; % número de variables de estado
m = 1; % número de entradas

umax = 5; % límites de la fuerza/motor que actúa el carro
x0 = [0; 0]; % condición inicial
xN = [pi; 0]; % condición final

% Secuencia de vectores de estado y entradas para el número de segmentos
% dados
X = zeros(n, M);
U = zeros(m, M);

%% Variables de decisión
% se convierte la secuencia de vectores de estado a un único vector columna
z = reshape(X, [], 1);  
% se le concatena la secuencia de vectores de entrada convertidas a vector
% columna
z = [z; reshape(U, [], 1)];

%% Se replantea la función objetivo para que emplee el vector de variables
% de decisión
objfun = ...
    @(z) objective_function(reshape(z(1:n*M), [n,M]), reshape(z(n*M + 1:end), [m,M]), N, T/N);

%% Límites superiores e inferiores (restricciones de trayectoria)
lb = -Inf*ones(size(z));
ub = Inf*ones(size(z));

% Límites para las variables de estado
for k = 0:N
    lb(k*n+1) = -2*pi;
    ub(k*n+1) = 2*pi;
end

% Límites para las variables de entrada
for k = 0:N
    lb(n*M + k + 1) = -umax; 
    ub(n*M + k + 1) = umax;
end

%% Restricciones no lineales de igualdad (restricciones de colocación y de frontera)
nlcons = ...
    @(z) collocation_and_boundary_constraints(reshape(z(1:n*M), [n,M]), reshape(z(n*M + 1:end), [m,M]), ...
    N, T/N, x0, xN);

% Se crea la aproximación inicial
U0 = zeros(m, M);
t = 0:T/N:T;
X0 = t/T .* [pi; 0];
z0 = [reshape(X0, [], 1); reshape(U0, [], 1)];
% z0 = rand(size(z));

%% Se resuelve el programa no lineal
options = optimoptions('fmincon', 'Display', 'iter', 'MaxFunEvals', 1e5);
z = fmincon(objfun, z0, [], [], [], [], lb, ub, nlcons, options);

%% Se extraen las trayectorias óptimas
Xopt = reshape(z(1:n*M), [n,M]);
Uopt = reshape(z(n*M + 1:end), [m,M]);

%% Se almacenan los resultados y se grafica la solución obtenida
topt = t;
Topt = T;
Nopt = N;
save('nlpoptres.mat', 'Uopt', 'Xopt', 'topt', 'Topt', 'Nopt');

figure;
plot(t, Xopt', '.', 'MarkerSize', 20);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$x(t)$', '$\theta(t)$', '$\dot{x}(t)$', '$\dot{\theta}(t)$', ...
    'Location', 'northeast', 'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 14);
grid minor;

figure;
plot(t, Uopt', '.', 'MarkerSize', 20);  
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$u(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
set(l, 'Interpreter', 'latex', 'FontSize', 14);
grid minor;