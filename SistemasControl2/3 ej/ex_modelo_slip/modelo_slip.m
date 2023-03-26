clear all;
% =========================================================================
% SIMULACIÓN DEL MODELO SLIP
% =========================================================================
% El siguiente script implementa la simulación del modelo SLIP con un
% torque de entrada en la "cadera" y una fuerza de entrada para comprimir 
% la pierna.
% =========================================================================        
%% Parámetros de la simulación
dt = 0.01; % período de muestreo
t0 = 0; % tiempo inicial
tf = 10; % tiempo final
K = (tf-t0)/dt; % número de iteraciones

%% Espacio para trabajar
%Punto de operacion
xss = [0.5;0.5;0;0];

%f(xss, uss) == 0 -->F(z)==0, z==uss
%        ^
fun = @(z)dynamics(xss, z);
uss = fsolve(fun, rand(2,1)) %verificar q si resuelva la ecu

disp('Si el valor es cero es buen punto de equilibrio: ')
round(dynamics(xss, uss)) %si es cero entonces tengo un punto de operacion valido

%Linealizacion, Estabilidad y Controlabilidad
[A,B,C,D] = loclin_best(@dynamics,@outputs,xss,uss);
disp('Einge valores: ')
eig(A)
disp('controlabilidad: ')
rank(ctrb(A,B))%si es igual al orden del sistema es totalmente controlable

%Se calcula el LQR   CONTROL
Q = eye(4); %tamaño del vector del estadp    ^
R = eye(2); %tamaño del vector de entrada
%q tan intenso será el control, 1 es el control normal
ganancia_control = 1;
Klqr = ganancia_control*lqr(A,B,Q,R);

delta = 0.1;

%% Inicialización y condiciones iniciales
%x0 = [0.5; 0.5; 0.5; 0.5];
x0 = xss + delta;
u0 = [0; 0];
x = x0; % vector de estado
u = u0; % vector de entradas
% Arrays para almacenar las trayectorias de las variables de estado,
% entradas y salidas del sistema
X = zeros(numel(x),K+1);
U = zeros(numel(u),K+1);
% Inicialización de arrays
X(:,1) = x0;
U(:,1) = u0;

%% Solución recursiva del sistema dinámico
for k = 0:K
    % Se define la entrada para el sistema
    %u = [0; 0];  %Forma natural
    u = -Klqr*(x-xss)+uss; %Controlado
    
    % Se actualiza el estado del sistema mediante una discretización por 
    % el método de Runge-Kutta (RK4)
    k1 = dynamics(x, u);
    k2 = dynamics(x+(dt/2)*k1, u);
    k3 = dynamics(x+(dt/2)*k2, u);
    k4 = dynamics(x+dt*k3, u);
    x = x + (dt/6)*(k1+2*k2+2*k3+k4);
    
    % Se guardan las trayectorias del estado y las entradas
    X(:,k+1) = x;
    U(:,k+1) = u;
end









%% Generación de figuras (NO modificar)
t = t0:dt:tf;

figure;
subplot(1,2,1);
plot(t, X', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$\ell(t)$', '$\theta(t)$', '$\dot{\ell}(t)$', ...
    '$\dot{\theta(t)}$', 'Location', 'southeast', 'Orientation', ...
    'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 16);
grid minor;
axis square;

subplot(1,2,2);
plot(t, U', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{u}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$f(t)$', '$\tau(t)$', 'Location', 'southeast', ...
    'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 16);
grid minor;
axis square;


%% Animación (NO modificar)
% Funciones internas para la animación
p = @(x) [-x(1)*sin(x(2)); x(1)*cos(x(2))];

figure;
s = 3;
r = 0.1;
xlim(s*[-1, 1]);
ylim(s*[-1, 1]);
grid off;
hold on;

q = X(:,1);
r1 = p(q); x1 = r1(1); y1 = r1(2);
h = plot([0,x1], [0,y1], 'Color', [0.5, 0.5, 0.5], 'LineWidth', 3);
c1 = circle(x1,y1,r);

for k = 2:K+1
    q = X(:,k);
    r1 = p(q); x1 = r1(1); y1 = r1(2);
    h.XData = [0,x1];
    h.YData = [0,y1];
    c1.Position(1:2) = [x1-r, y1-r];
    pause(dt);
end