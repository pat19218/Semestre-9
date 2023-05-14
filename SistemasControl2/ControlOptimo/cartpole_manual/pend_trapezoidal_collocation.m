clear all;

%% Par�metros de la colocaci�n
T = 2; % tiempo final de la trayectoria
N = 39; % n�mero de segmentos
M = N + 1; % n�mero de puntos de colocaci�n
n = 4; % n�mero de variables de estado
m = 1; % n�mero de entradas
d = 1; % posici�n final del carro del p�ndulo
dmax = 2; % l�mites del riel del carro (se asume un riel sim�trico)
umax = 20; % l�mites de la fuerza/motor que act�a el carro
x0 = [0; 0; 0; 0]; % condici�n inicial
xN = [d; pi; 0; 0]; % condici�n final

% Secuencia de vectores de estado y entradas para el n�mero de segmentos
% dados
X = zeros(n, M);
U = zeros(m, M);

%% Variables de decisi�n
% se convierte la secuencia de vectores de estado a un �nico vector columna
z = reshape(X, [], 1);  
% se le concatena la secuencia de vectores de entrada convertidas a vector
% columna
z = [z; reshape(U, [], 1)];

%% Se replantea la funci�n objetivo para que emplee el vector de variables
% de decisi�n
objfun = ...
    @(z) objective_function(reshape(z(1:n*M), [n,M]), reshape(z(n*M + 1:end), [m,M]), N, T/N);

%% L�mites superiores e inferiores (restricciones de trayectoria)
lb = -Inf*ones(size(z));
ub = Inf*ones(size(z));

% L�mites para las variables de estado
for k = 0:N
    lb(k*n+1) = -dmax;
    lb(k*n+2) = -2*pi;
    ub(k*n+1) = dmax;
    ub(k*n+2) = 2*pi;
end

% L�mites para las variables de entrada
for k = 0:N
    lb(n*M + k + 1) = -umax; 
    ub(n*M + k + 1) = umax;
end

%% Restricciones no lineales de igualdad (restricciones de colocaci�n y de frontera)
nlcons = ...
    @(z) collocation_and_boundary_constraints(reshape(z(1:n*M), [n,M]), reshape(z(n*M + 1:end), [m,M]), ...
    N, T/N, x0, xN);

% Se crea la aproximaci�n inicial
U0 = zeros(m, M);
t = 0:T/N:T;
X0 = t/T .* [d; pi; 0; 0];
z0 = [reshape(X0, [], 1); reshape(U0, [], 1)];
% z0 = rand(size(z));

%% Se resuelve el programa no lineal
options = optimoptions('fmincon', 'Display', 'iter', 'MaxFunEvals', 1e5);
z = fmincon(objfun, z0, [], [], [], [], lb, ub, nlcons, options);

%% Se extraen las trayectorias �ptimas
Xopt = reshape(z(1:n*M), [n,M]);
Uopt = reshape(z(n*M + 1:end), [m,M]);

%% Se almacenan los resultados y se grafica la soluci�n obtenida
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