% =========================================================================
% IE3041 - EJEMPLO CONVERTIDOR BUCK
% -------------------------------------------------------------------------
% En este script veremos cómo implementar pole placement para controlar el 
% el modelo de un convertidor Buck.
% Estados:
% x1 - corriente del inductor
% x2 - voltaje del capacitor
% =========================================================================
clear all;
%% Parámetros del sistema
Vs = 12;
Cap = 1; %100*(1e-6);
L = 1; %100*(1e-6);
R = 10;

%% Matrices continuas del sistema LTI
A = [0, -1/L; 1/Cap, -1/(R*Cap)];

B = [Vs/L; 0];

C = [0, 1];

%% Parámetros de la simulación
dt = 0.001; % período de muestreo (step size)
t0 = 0;
tf = 50;
K = (tf-t0) / dt;

%% Inicialización y condiciones iniciales
x0 = [0.1; 1]; % condiciones iniciales 
u0 = 0;
y0 = C*x0;
x = x0; % vector de estado
u = u0; % entrada
y = y0; % salida
% Array para almacenar las trayectorias de las variables de estado
X = zeros(numel(x0), K+1); X(:,1) = x;
% Array para almacenar la evolución de las entradas 
U = zeros(numel(u0), K+1); U(:,1) = u;
% Array para almacenar la evolución de las salidas 
Y = zeros(numel(u0), K+1); Y(:,1) = y;

%% Discretización del sistema continuo
% Discretización por ZOH
sysd = c2d(ss(A,B,C,0), dt, 'zoh');
Ad = sysd.A;
Bd = sysd.B;
Cd = sysd.C;

%% Punto de operación
Vo = 5;
xss = [Vo/R; Vo];
F = @(u) A*xss+B*u;
uss = fsolve(F, 0);

%% Diseño de control por pole placement
% Seleccionamos nuestros polos favoritos (no se pueden repetir en Matlab):
p = [-2+2i, -2-2i]; 
% Usamos la función de pole placement con las matrices del sistema continuo
Kpp = place(A,B,p);  

%% Diseño de control por LQR
Q = eye(2);
R = 25;
Klqr = lqr(A,B,Q,R);

%% Solución recursiva del sistema dinámico
for k = 1:K
    % Estabilización
%     u = -Klqr*x; % retroalimentación de estado
%     u = 0.5;

    % Regulación
    u = -Klqr*(x - xss) + uss;
    
    % Se propaga el sistema LTI discreto para aproximar la solución del
    % sistema continuo
    x = Ad*x + Bd*u;
    y = Cd*x;
    
    % Se guardan las trayectorias del estado, entrada y salida
    X(:, k+1) = x;
    U(:, k+1) = u;
    Y(:, k+1) = y;
end

% Graficamos los resultados
t = t0:dt:tf;
figure;
plot(t, X', 'LineWidth', 1);
title('Trayectorias de variables de estado');
xlabel('$t$','Interpreter','latex','FontSize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'FontSize', 16);
% l = legend('$x_1(t)$', '$x_2(t)$', '$x_3(t)$', '$x_4(t)$', '$x_5(t)$', ...
%     '$x_6(t)$', '$x_7(t)$', '$x_8(t)$', 'Location', 'southeast');
% set(l, 'Interpreter', 'latex', 'FontSize', 12);

figure;
plot(t, U', 'LineWidth', 1);
title('Entradas al sistema con respecto al tiempo');
xlabel('$t$','Interpreter','latex','FontSize', 16);
ylabel('$\mathbf{u}(t)$', 'Interpreter', 'latex', 'FontSize', 16);
% l = legend('$u_1(t)$', '$u_2(t)$', '$u_3(t)$', '$u_4(t)$', ...
%     'Location', 'southeast');
% set(l, 'Interpreter', 'latex', 'FontSize', 12);

figure;
plot(t, Y', 'LineWidth', 1);
title('Salidas del sistema con respecto al tiempo');
xlabel('$t$','Interpreter','latex','FontSize', 16);
ylabel('$\mathbf{y}(t)$', 'Interpreter', 'latex', 'FontSize', 16);
