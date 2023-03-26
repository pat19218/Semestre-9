% =========================================================================
% IE3011 - MICRO-PARCIAL 3: simulación de un quadrotor planar
% -------------------------------------------------------------------------
% Siga las instrucciones del problema descrito en el documento del
% micro-parcial para completar el código que se le presenta a continuación, 
% con el cual efectuará la simulación y el control de un quadrotor planar.
% =========================================================================

%% Parámetros del sistema
m = (420/2)/1000; % en kg
ell = 45/100; % en m
g = 9.81; % en m/s^2
Ixx = (1/12)*m*ell^2; % en kg m^2

% Complete los siguientes parámetros 
yss = 0; % en m <-- MODIFICAR
zss = 2; % en m <-- MODIFICAR
xss = [yss;zss;0;0;0;0]; % punto de operación <-- MODIFICAR
uss = [m*g/2,m*g/2]'; % fuerzas requeridas en el punto de operación <-- MODIFICAR

% Condiciones inicialess
delta = -3.62;%2;%-3.62;
x0 = [yss+delta,zss+delta,delta,delta,delta,delta]'; % <-- MODIFICAR


%% Definición del sistema dinámico
% Complete la función correspondiente al campo vectorial del sistema no
% lineal. Considere que x = [x(1); x(2); x(3); x(4); x(5); x(6)] = ...
% [y; z; phi; doty; dotz; dotphi] y u = [u(1); u(2)] = [fR; fL]

f = @(x,u) [x(4);x(5);x(6);(-(u(2)*sin(x(3))+u(1)*sin(x(3))))/m;...
    (u(2)*cos(x(3))+u(1)*cos(x(3))-g*m)/m;(u(1)*(ell/2)-u(2)*(ell/2))/Ixx];

h = @(x, u) x; % dummy para poder emplear linealización numérica

[A,B,C,D]=loclin_best(f,h,xss,uss,1E-06);
stab = eig(A);
controlabilidad=rank(ctrb(A,B));
%% Matrices del sistema linealizado alrededor del punto de operación 
% Complete las matrices obtenidas para el sistema linealizado, puede
% emplear los parámetros del sistema previamente definidos
%A = ; % <-- MODIFICAR
%B = ; % <-- MODIFICAR


%% Diseño de control lineal mediante LQR
% Defina las matrices Q, R y úselas junto con las matrices A y B para
% obtener la matriz de ganancias K del regulador lineal cuadrático que
% estabiliza el origen del sistema linealizado
% Seleccionamos las matrices de penalización
Q = eye(length(x0));  %tamaño del vector del estado
R = eye(2);   %tamaño del vector de entrada
% Usamos la función de lqr con las matrices del sistema y las de penalización
ganancia_control = 1;
K = ganancia_control*lqr(A,B,Q,R); % <-- MODIFICAR

%% Parámetros de la simulación
dt = 0.001; % período de muestreo
t0 = 0; % tiempo inicial
tf = 5; % tiempo final
N = (tf-t0)/dt; % número de iteraciones

%% Inicialización y condiciones iniciales
u0 = [0; 0];
x = x0; % vector de estado 
u = u0; % vector de entradas
% Arrays para almacenar las trayectorias de las variables de estado,
% entradas y salidas del sistema
X = zeros(numel(x),N+1);
U = zeros(numel(u),N+1);
% Inicialización de arrays
X(:,1) = x0;
U(:,1) = u0;

%% Solución recursiva del sistema dinámico
for n = 0:N
    % Se define la entrada para el sistema. Aquí debe colocarse el
    % controlador al momento de querer estabilizar el sistema
    %u = [0; 0];    % <-- MODIFICAR
    %u = -K*x;   % retroalimentación de estado
    u = -K*(x-xss)+uss; %Controlado
    if(u(1)<0)
        u(1) = 0;
    end
    
    if(u(2)<0)
        u(2) = 0;
    end
    
    % Se actualiza el estado del sistema mediante una discretización por 
    % el método de Runge-Kutta (RK4)
    k1 = f(x, u);
    k2 = f(x+(dt/2)*k1, u);
    k3 = f(x+(dt/2)*k2, u);
    k4 = f(x+dt*k3, u);
    x = x + (dt/6)*(k1+2*k2+2*k3+k4);
    
    % Se guardan las trayectorias del estado y las entradas
    X(:,n+1) = x;
    U(:,n+1) = u;
end

%% Animación y generación de figuras (NO modificar)
figure;
t = t0:dt:tf;
plot(t, X', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$y(t)$', '$z(t)$', '$\phi(t)$', '$\dot{y}(t)$', ...
    '$\dot{z}(t)$', '$\dot{\phi}(t)$', 'Location', 'best', ...
    'Orientation', 'vertical');
set(l, 'Interpreter', 'latex', 'FontSize', 12);
grid minor;

figure;
s = 3;
xlim(s*[-1, 1]);
ylim(s*[-1, 1]);
grid minor;
hold on;

q = X(1:3,1);
y = q(1); z = q(2); phi = q(3);

trajplot = plot(y, z, '--k', 'LineWidth', 1);

yl = y-(ell/2)*cos(phi);
yr = y+(ell/2)*cos(phi);
zl = z - (ell/2)*sin(phi);
zr = z + (ell/2)*sin(phi);
bodyplot = plot([yl, yr], [zl, zr], 'Color', [0.5,0.5,0.5], 'LineWidth', 6);

pl = [yl; zl] + (5/100)*[-sin(phi); cos(phi)];
pr = [yr; zr] + (5/100)*[-sin(phi); cos(phi)];
axleplot1 = plot([yl,pl(1)], [zl,pl(2)], 'k', 'LineWidth', 2);
axleplot2 = plot([yr,pr(1)], [zr,pr(2)], 'k', 'LineWidth', 2);

offsety = (10/100)*cos(phi);
offsetz = (10/100)*sin(phi);
proplot1 = plot([pl(1)-offsety,pl(1)+offsety], ...
    [pl(2)-offsetz,pl(2)+offsetz], 'cyan', 'LineWidth', 2);
proplot2 = plot([pr(1)-offsety,pr(1)+offsety], ...
    [pr(2)-offsetz,pr(2)+offsetz], 'cyan', 'LineWidth', 2);

xlabel('$y$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$z$', 'Interpreter', 'latex', 'Fontsize', 16);
hold off;

for n = 2:N+1
    q = X(1:3,n);
    y = q(1); z = q(2); phi = q(3);
    
    trajplot.XData = [trajplot.XData, y];
    trajplot.YData = [trajplot.YData, z];
    
    yl = y-(ell/2)*cos(phi);
    yr = y+(ell/2)*cos(phi);
    zl = z - (ell/2)*sin(phi);
    zr = z + (ell/2)*sin(phi);
    bodyplot.XData = [yl,yr];
    bodyplot.YData = [zl,zr];
    
    pl = [yl; zl] + (10/100)*[-sin(phi); cos(phi)];
    pr = [yr; zr] + (10/100)*[-sin(phi); cos(phi)];
    axleplot1.XData = [yl,pl(1)];
    axleplot1.YData = [zl,pl(2)];
    axleplot2.XData = [yr,pr(1)];
    axleplot2.YData = [zr,pr(2)];
    
    offsety = (10/100)*cos(phi);
    offsetz = (10/100)*sin(phi);
    proplot1.XData = [pl(1)-offsety,pl(1)+offsety];
    proplot1.YData = [pl(2)-offsetz,pl(2)+offsetz];
    proplot2.XData = [pr(1)-offsety,pr(1)+offsety];
    proplot2.YData = [pr(2)-offsetz,pr(2)+offsetz];

    pause(dt);
end