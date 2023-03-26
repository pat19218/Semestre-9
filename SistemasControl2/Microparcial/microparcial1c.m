% =========================================================================
% IE3041 - Micro-parcial 1c
% -------------------------------------------------------------------------
% Siga las instrucciones planteadas para el problema en Canvas,
% asegurándose de colocar las cantidades en las variables respectivas.
% =========================================================================

% Matrices del circuito obtenidas luego del modelado (PUEDE MODIFICAR)
% -------------------------------------------------------------------------
A = [-6,3;3,-4];
B = [3;1];
C = [3,-4];
D = [1];


% Parámetros de la simulación (PUEDE MODIFICAR)
% -------------------------------------------------------------------------
x0 = [0.5; 0]; % condiciones iniciales
t_0 = 0; % tiempo inicial
t_f = 10; % tiempo final
dt = 0.01; % período de muestreo
K = (t_f - t_0) / dt; % número de iteraciones


% Inicialización de cantidades (NO MODIFICAR)
% -------------------------------------------------------------------------
t = t_0:dt:t_f; % vector de tiempo (puede emplearse para graficar)
x = x0; % inicialización del vector de estado
u = zeros(size(B,2), 1); % inicialización del vector de entradas
y = C*x0; % inicialización del vector de salidas
X = zeros(numel(x), K+1); X(:, 1) = x; % para graficar variables de estado
U = zeros(numel(u), K+1); U(:, 1) = u; % para graficar entradas
Y = zeros(numel(y), K+1); Y(:, 1) = y; % para graficar salidas


% Otras cantidades requeridas para la simulación (PUEDE MODIFICAR)
% -------------------------------------------------------------------------
% Se emplean las expresiones del método ZOH para encontrar las matrices
% discretas del sistema digital equivalente
Ad = expm(A*dt);
fun = @(s) expm(A*s);
syms s
Bd = double(int(expm(A*s), s, 0, dt)*B);
Cd = C;


% Solución recursiva del sistema (PUEDE MODIFICAR)
% -------------------------------------------------------------------------
for k = 1:K
% Definición de la señal de entrada
    %u = 1; % escalón unitario
    %u = sin(2*pi*0.1*k*dt);
    u=5;
    
    % Se propaga el sistema LTI discreto para aproximar la solución del
    % sistema continuo
    x = Ad*x + Bd*u;
    
    % Generación de la señal de salida
    y = Cd*x+D*u;
    
    % Se guardan las trayectorias del estado, entrada y salida
    X(:, k+1) = x;
    U(:, k+1) = u;
    Y(:, k+1) = y;
end



% Generación de gráficos de resultados (PUEDE MODIFICAR)
% -------------------------------------------------------------------------
t = t_0:dt:t_f; % vector de tiempo para generar las gráficas

% Evolución de las variables de estado en el tiempo
figure;
plot(t, Y', 'LineWidth', 1);
grid minor;
xlabel('$t$', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$y(t)$', 'Interpreter', 'latex', 'FontSize', 16);