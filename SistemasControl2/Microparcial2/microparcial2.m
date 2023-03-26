% =========================================================================
% IE3041 - Micro-parcial 2
% -------------------------------------------------------------------------
% Siga las instrucciones planteadas para el problema en Canvas. ASEGÚRESE
% DE GUARDAR LAS CANTIDADES SOLICITADAS EN LAS VARIABLES REQUERIDAS (esto
% es por motivos del auto-calificador).
%
% NOTA: debe subir en Canvas sólo la versión modificada de este archivo.
% =========================================================================
%% Información y respuestas (DEBE MODIFICAR)
% -------------------------------------------------------------------------
carnet = '19218';

% Puntos de equilibrio (como vectores columna, definir todos los que 
% requieran de esta misma manera)
%xeq1 = [r0;r1;r2;r3];
%xeq2 = [0;0;0;0];

% Estabilidad de cada punto de equilibrio (definir todos los que requieran 
% de esta misma manera). 


% Sólo se permite alguno de los siguientes valores:
% 0 = inestable
% 1 = (localmente) asintóticamente estable
% 2 = estable
eq0stab = 2;
eq1stab = 2;
eq2stab = 0;
eq3stab = 0;


%% Definición de constantes del problema (NO MODIFICAR)
% -------------------------------------------------------------------------
params = logrand(double('0.' + reverse(string(carnet))), 5);
m = round(params(1), 2);
r0 = round(5*params(2) - 2.5, 2);
r1 = round(5*params(3) - 2.5, 2);
r2 = round(5*params(4) - 2.5, 2);
r3 = round(5*params(5) - 2.5, 2);

%% Área de trabajo (las siguientes secciones se presentan como sugerencia)
% -------------------------------------------------------------------------
% Definición de los campos vectoriales
% funcion de la fuerza dada de la particula de dimension 1 
f = @(x, u) [x(2);((x(1)-r0)*(x(1)-r1)*(x(1)-r2)*(x(1)-r3))/(m)];
h = @(x, u) x; % dummy para poder emplear linealización numérica

xeq0 = [r0;0];
ueq0=0;

xeq1 = [r1;0];
ueq1=0;

xeq2 = [r2;0];
ueq2=0;

xeq3 = [r3;0];
ueq3=0;
% Obtención de puntos de equilibrio, linealización y evaluación de
% estabilidad
%encuentro los puntos de equilibrio
puntosequi0= fsolve(f,xeq0);
puntosequi1= fsolve(f,xeq1);
puntosequi2= fsolve(f,xeq2);
puntosequi3= fsolve(f,xeq3);

%funcion de archivo adicional 

%linealiza el vector entorno al punto de equilibrio
[A0,B0,~,~]=loclin_best(f,h,puntosequi0,ueq0);
eigs(A0);%verificar con la simulacion

[A1,B1,~,~]=loclin_best(f,h,puntosequi1,ueq1);
eigs(A1);

[A2,B2,~,~]=loclin_best(f,h,puntosequi2,ueq2);
eigs(A2);

[A3,B3,~,~]=loclin_best(f,h,puntosequi3,ueq3);
eigs(A3);
% Simulación


% Generación de figuras
%% Parámetros de la simulación
t0 = 0;
tf = 5; % tiempo de simulación
dt = 0.01; % período de muestreo
K = (tf - t0) / dt; % número de iteraciones

%% Inicialización y condiciones iniciales
% Sistema no lineal
x0 = [-1; 0]; % condición inicial
x = x0; % vector de estado
% Array para almacenar las trayectorias de las variables de estado
X = zeros(numel(x0), K+1); X(:,1) = x; 

%% Solución recursiva del sistema dinámico
for k = 1:K
    % Método RK4 para la aproximación numérica de la solución del sistema
    % no lineal
    k1 = f(x, 0);
    k2 = f(x+(dt/2)*k1, 0);
    k3 = f(x+(dt/2)*k2, 0);
    k4 = f(x+dt*k3, 0);
    x = x + (dt/6)*(k1+2*k2+2*k3+k4);
    
    % Se guardan la trayectoria del vector de estado
    X(:, k+1) = x;
end

%% Animación y generación de figuras (NO modificar)    
% Animación de las trayectorias del sistema en el espacio de estados
figure(1);
meshres = 0.1;
lims = 5;
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
    
% Se actualizan las gráficas y se pausa el programa para dar la 
% ilusión de animación
for k = 2:K+1
    flowp_nonlin.XData = [flowp_nonlin.XData, X(1,k)];
    flowp_nonlin.YData = [flowp_nonlin.YData, X(2,k)];
    pause(dt);
end