% =========================================================================
% IE3041 - EJEMPLO CICLO L�MITE
% -------------------------------------------------------------------------
% En este ejemplo se muestra el comportamiento de un ciclo l�mite para el
% caso del oscilador de Van der Pol.
% =========================================================================
%% Par�metros y din�mica del sistema
m = 2; % kg
ell = 1; % m
g = 9.81; % m/s^2

% Campo vectorial del sistema
f = @(x,u) [ x(2); 
             1*(1-x(1)^2)*x(2) - x(1) ];
         
%% Par�metros de la simulaci�n
t0 = 0;
tf = 20; % tiempo de simulaci�n
dt = 0.01; % per�odo de muestreo
K = (tf - t0) / dt; % n�mero de iteraciones

%% Inicializaci�n y condiciones iniciales
% Sistema no lineal
x0 = [1; 0]; % condici�n inicial
x = x0; % vector de estado
% Array para almacenar las trayectorias de las variables de estado
X = zeros(numel(x0), K+1); X(:,1) = x; 

%% Soluci�n recursiva del sistema din�mico
for k = 1:K
    % M�todo RK4 para la aproximaci�n num�rica de la soluci�n del sistema
    % no lineal
    k1 = f(x, 0);
    k2 = f(x+(dt/2)*k1, 0);
    k3 = f(x+(dt/2)*k2, 0);
    k4 = f(x+dt*k3, 0);
    x = x + (dt/6)*(k1+2*k2+2*k3+k4);
    
    % Se guardan la trayectoria del vector de estado
    X(:, k+1) = x;
end


%% Animaci�n y generaci�n de figuras (NO modificar)    
% Animaci�n de las trayectorias del sistema en el espacio de estados
figure;
meshres = 0.1;
lims = 3;
xlim([-lims, lims]);
ylim([-lims, lims]);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 18);

% Diagrama de fase del sistema no lineal
[mX1, mX2] = meshgrid(-lims:meshres:lims, -lims:meshres:lims);
[mDX1, mDX2] = phaseportrait2d(f, mX1, mX2, 0);
phasep_nonlin = streamslice(mX1, mX2, mDX1, mDX2);
set(phasep_nonlin, 'Color', [0.5, 0.5, 0.5]);
hold on;

% Trayectoria del sistema no lineal
flowp_nonlin = plot(X(1,1), X(2,1), 'k', 'LineWidth', 1);
    
% Se actualizan las gr�ficas y se pausa el programa para dar la 
% ilusi�n de animaci�n
for k = 2:K+1
    flowp_nonlin.XData = [flowp_nonlin.XData, X(1,k)];
    flowp_nonlin.YData = [flowp_nonlin.YData, X(2,k)];
    pause(dt);
end


