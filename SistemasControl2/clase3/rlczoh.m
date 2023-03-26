% =========================================================================
% IE3041 - EJEMPLO CIRCUITO RLC CON DISCRETIZACI�N MEDIANTE ZOH
% -------------------------------------------------------------------------
% Se presenta la simulaci�n del circuito RLC resuelto a mano empleando el
% m�todo ZOH de discretizaci�n aplicable a sistemas LTI.
% =========================================================================
clear all;
%% Par�metros y din�mica del sistema
R = 100; 
L = 1;
Cap = 10000e-6;

%% Matrices continuas del sistema LTI
A = [0, 1/Cap; -1/L,-R/L];
B = [0; 1/L];
C = [0, R];

%% Par�metros de la simulaci�n
t0 = 0; % tiempo inicial
tf = 10; % tiempo de simulaci�n
dt = 0.01; % per�odo de muestreo
K = (tf - t0) / dt; % n�mero de iteraciones

%% Inicializaci�n y condiciones iniciales
x0 = [0.5; 0]; % condiciones iniciales 
u0 = 5;
y0 = C*x0;
x = x0; % vector de estado
u = u0; % entrada
y = y0; % salida
% Array para almacenar las trayectorias de las variables de estado
X = zeros(numel(x0), K+1); X(:,1) = x;
% Array para almacenar la evoluci�n de las entradas 
U = zeros(numel(u0), K+1); U(:,1) = u; 
% Array para almacenar la evoluci�n de las salidas
Y = zeros(numel(y0), K+1); Y(:,1) = y; 

%% Discretizaci�n del sistema continuo
% Se emplean las expresiones del m�todo ZOH para encontrar las matrices
% discretas del sistema digital equivalente
Ad = expm(A*dt);
fun = @(s) expm(A*s);
syms s
Bd = double(int(expm(A*s), s, 0, dt)*B);
Cd = C;

%% Soluci�n recursiva del sistema din�mico
for k = 1:K
    % Definici�n de la se�al de entrada
%     u = 1; % escal�n unitario
    u = sin(2*pi*0.1*k*dt);
    
    % Se propaga el sistema LTI discreto para aproximar la soluci�n del
    % sistema continuo
    x = Ad*x + Bd*u;
    
    % Generaci�n de la se�al de salida
    y = Cd*x;
    
    % Se guardan las trayectorias del estado, entrada y salida
    X(:, k+1) = x;
    U(:, k+1) = u;
    Y(:, k+1) = y;
end

%% Animaci�n y generaci�n de figuras (NO modificar)
t = t0:dt:tf; % vector de tiempo para generar las gr�ficas

% Evoluci�n de las variables de estado en el tiempo
figure;
subplot(2,2,1);
plot(t, X', 'LineWidth', 1);
grid minor;
xlabel('$t$', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'FontSize', 16);

% Evoluci�n de las entradas en el tiempo
subplot(2,2,2);
plot(t, U', 'LineWidth', 1);
grid minor;
xlabel('$t$', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$u(t)$', 'Interpreter', 'latex', 'FontSize', 16);

% Evoluci�n de las salidas en el tiempo
subplot(2,2,3);
plot(t, Y', 'LineWidth', 1);
grid minor;
xlabel('$t$', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$y(t)$', 'Interpreter', 'latex', 'FontSize', 16);

%% Comparaci�n entre la soluci�n anal�tica y la num�rica
% Soluci�n anal�tica del sistema continuo
clear t u x y
syms t tau
u(t) = sym(1);
eA(t) = simplify(expm(A*t));
x(t) = simplify(eA(t)*x0 + int(eA(t-tau)*B*u(tau), tau, 0, t));
y(t) = C*x(t);

% Gr�ficas de comparaci�n
t = t_0:dt:t_f;

figure;
subplot(2,1,1);
fplot(x, [0, 10]);
hold on;
plot(t, X', 'LineWidth', 1);
hold off;
grid minor;
xlabel('$t$', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'FontSize', 16);
l1 = legend('$x_1$ exacta', '$x_2$ exacta', '$x_1$ ZOH', '$x_2$ ZOH', ...
    'Location', 'northeast');
set(l1, 'Interpreter', 'latex', 'FontSize', 12);

subplot(2,1,2);
fplot(y, [0, 10]);
hold on;
plot(t, Y', 'LineWidth', 1);
hold off;
grid minor;
xlabel('$t$', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$y(t)$', 'Interpreter', 'latex', 'FontSize', 16);
l2 = legend('exacta', 'ZOH', 'Location', 'northeast');
set(l2, 'Interpreter', 'latex', 'FontSize', 12);