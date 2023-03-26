% =========================================================================
% IE3041 - EJEMPLO ATRACTOR EXTRA�O
% -------------------------------------------------------------------------
% En este ejemplo se muestra el comportamiento de un atractor extra�o para 
% el caso del sistema de Lorenz.
% =========================================================================
clear all;
%% Par�metros y din�mica del sistema
rho = 28; 
sigma = 10; 
beta = 8/3; 

% Se define el campo vectorial como una funci�n an�nima de MATLAB (en este
% caso). Para sistemas con din�mica m�s complicada se recomienda definir el
% campo vectorial en un archivo de funci�n aparte.
f = @(x) [sigma*(x(2)-x(1)); x(1)*(rho-x(3))-x(2); x(1)*x(2)-beta*x(3)];

%% Par�metros de la simulaci�n
t0 = 0; % tiempo inicial
tf = 30; % tiempo (final) de simulaci�n
dt = 0.01; % per�odo de muestreo
K = (tf - t0) / dt; % n�mero de iteraciones

%% Inicializaci�n y condiciones iniciales
x0 = [0.1; 0; 0]; % condiciones iniciales
x = x0; % vector de estado
% Array para almacenar las trayectorias de las variables de estado del
% sistema (se emplear� m�s adelante para generar las gr�ficas y
% animaciones)
X = zeros(numel(x0), K+1); X(:,1) = x;

%% Soluci�n recursiva del sistema din�mico
for k = 1:K
    % Se actualiza la aproximaci�n num�rica de la soluci�n mediante el 
    % m�todo de forward Euler
    x = x + f(x)*dt;
    
    % Se guardan las trayectorias de las variables de estado
    X(:, k+1) = x;
end

%% Generaci�n de figuras y animaciones (NO modificar)
% Evoluci�n de las variables de estado en el tiempo
% Animaci�n de la trayectoria del sistema en el espacio de estados
figure;
h = plot3(X(1,1), X(2,1), X(3,1), 'k', 'LineWidth', 1);
view([180, 0]);
grid minor;
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 18);
zlabel('$x_3$', 'Interpreter', 'latex', 'FontSize', 18);
xlim([-25, 25]);
zlim([0, 60]);

for k = 2:K
   h.XData = [h.XData, X(1,k)];
   h.YData = [h.YData, X(2,k)];
   h.ZData = [h.ZData, X(3,k)];
   pause(2*dt);
end