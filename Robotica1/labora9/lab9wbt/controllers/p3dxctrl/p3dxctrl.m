% ============================================================
% NO MODIFICAR
% ============================================================
TIME_STEP = 64;
MAX_WHEEL_VELOCITY = 12.3; % velocidad máxima ruedas (en rad/s)
WHEEL_RADIUS = (195/2); % radio de las ruedas (en mm)
DISTANCE_FROM_CENTER = (381/2); % distancia a ruedas (en mm)
% Velocidad lineal máxima (en mm/s)
MAX_SPEED = WHEEL_RADIUS * MAX_WHEEL_VELOCITY;

% Handles para controlar los motores de las ruedas del robot
left_wheel = wb_robot_get_device('left wheel');
right_wheel = wb_robot_get_device('right wheel');

% Handles de los sensores
gps = wb_robot_get_device('gps');
compass = wb_robot_get_device('compass');

% Set up para hacer control de velocidad en las ruedas
wb_motor_set_position(left_wheel, Inf);
wb_motor_set_position(right_wheel, Inf);
wb_motor_set_velocity(left_wheel, 0.0);
wb_motor_set_velocity(right_wheel, 0.0);

% Se habilitan los sensores
wb_gps_enable(gps, TIME_STEP);
wb_compass_enable(compass, TIME_STEP);

% Posiciones de meta
goal1 = [-4; 0];
goal2 = [3; -4];
goal3 = [1; 4];
goal4 = [3; 4];
goal_points = [goal1, goal2, goal3, goal4]; %2*4

% Se carga el mapa (occupancy grid) y se muestra
load('lab9map.mat');
%figure;
%imshow(map);
map = double(map); % Requerido por la Toolbox

i = 0; % tiempo actual de simulación (en iteraciones)
t = 0; % tiempo actual de simulación (en segundos)
% ============================================================


% ============================================================
% MODIFICAR
% ============================================================
% Operaciones previas a la simulación
wb_motor_set_position(left_wheel, Inf);
wb_motor_set_position(right_wheel, Inf);
wb_motor_set_velocity(left_wheel, 0.0);
wb_motor_set_velocity(right_wheel, 0.0);
% Inicialización de parámetros

% PID posición
kpP = 100;
kiP = 10;
kdP = 10;
EP = 0;
eP_1 = 0;

eP=10
ell=DISTANCE_FROM_CENTER;
xi = wb_gps_get_values(gps)';
% Difeomorfismo para linealización por feedback
finv = @(xi,mu) [1,0; 0,1/(ell)] * [cos(xi(3)), -sin(xi(3)); sin(xi(3)), cos(xi(3))]' * [mu(1); mu(2)];

% PID orientación
kpO = 1;
kiO = 0.001;
kdO = 0;
EO = 0;
eO_1 = 0;

% Acercamiento exponencial
v0 = 400;
alpha = 0.5;
flag=2;
flag2=0;
goal_index = 1;

%%LQI
sigma=[0;0];
Cr = eye(2);
B = eye(2);
R = eye(2);
A = zeros(2); 
Dr = zeros(2);
AA = [A, zeros(size(Cr')); Cr, zeros(size(Cr,1))];
BB = [B; Dr];
QQ = eye(size(A,1) + size(Cr,1));
QQ(3,3) =1; QQ(4,4) = 0.7;
Klqi = lqr(AA, BB, QQ, R);

%%Trayectorias
trayec=load('trayectorias.mat');
trayectoria1=(trayec.trayectoria1-250)*10/500

% ciclo principal de simulación:
cont=1
if flag==0
      while wb_robot_step(TIME_STEP) ~= -1
        xi = wb_gps_get_values(gps)';
        xi(1:2)'
        xi0 = wb_compass_get_values(compass);
        x = xi(1); y = xi(2); theta = atan2(xi0(1), xi0(2));
        % Se actualizan los tiempos actuales de simulación
        i = i + 1;
        t = t + TIME_STEP/1000;
      
    
          
           
          e = [goal1(1) - x; goal1(2) - y];
          thetag = atan2(e(2), e(1));
                    
          eP = norm(e);
          eO = thetag - theta;
          eO = atan2(sin(eO), cos(eO));
                    
           % %Control de velocidad lineal
           kP = v0 * (1-exp(-alpha*eP^2)) / eP;
           v = kP*eP;
                    
           % %Control de velocidad angular
           eO_D = eO - eO_1;
           EO = EO + eO;
           w = kpO*eO + kiO*EO + kdO*eO_D;
           eO_1 = eO;
                  
           % %Se combinan los controladores
           u = [v; w];
          left_wheel_speed = (v - w*DISTANCE_FROM_CENTER) / WHEEL_RADIUS;
          right_wheel_speed = (v + w*DISTANCE_FROM_CENTER) / WHEEL_RADIUS;
          wb_motor_set_velocity(left_wheel, left_wheel_speed);
          wb_motor_set_velocity(right_wheel, right_wheel_speed);
          end
elseif flag==2
    while wb_robot_step(TIME_STEP) ~= -1
        i = i + 1;
        t = t + TIME_STEP/1000;
        xi = wb_gps_get_values(gps);
        xi0 = wb_compass_get_values(compass);
        x = xi(1); y = xi(2); theta = atan2(xi0(1), xi0(2));
        e = [trayectoria1(cont,1) - x; trayectoria1(cont,2) - y];
        thetag = atan2(e(2), e(1));

        eP = norm(e)
        eO = thetag - theta;
        eO = atan2(sin(eO), cos(eO));

        % %Control de velocidad lineal
        kP = v0 * (1-exp(-alpha*eP^2)) / eP;
        v = kP*eP;

        % %Control de velocidad angular
        eO_D = eO - eO_1;
        EO = EO + eO;
        w = kpO*eO + kiO*EO + kdO*eO_D;
        eO_1 = eO;

        % %Se combinan los controladores
        u = [v; w];
        left_wheel_speed = (v - w*DISTANCE_FROM_CENTER) / WHEEL_RADIUS;
        right_wheel_speed = (v + w*DISTANCE_FROM_CENTER) / WHEEL_RADIUS;
        wb_motor_set_velocity(left_wheel, left_wheel_speed);
        wb_motor_set_velocity(right_wheel, right_wheel_speed);
        if eP < 0.5
          cont=cont+1;
        end

     end
 %Se guardan las trayectorias del estado y las entradas
 % %XI(:,n+1) = xi;
 % %U(:,n+1) = u;
elseif flag==1
  while wb_robot_step(TIME_STEP) ~= -1
        i = i + 1;
        t = t + TIME_STEP/1000;
    xi = wb_gps_get_values(gps)';
    xi0 = wb_compass_get_values(compass);
    xi(3)=atan2(xi0(1), xi0(2));

    %xi0 = wb_compass_get_values(compass);
    x = xi(1:2);
    sigma = sigma + (Cr*x - goal1)*(TIME_STEP/1000);
    mu = -Klqi*[x; sigma];
    u=finv(xi,mu);
    if (xi(1)-goal1(1))<0.08 && (xi(2)-goal1(2))<0.08
       left_wheel_speed = (u(1) - u(2)*DISTANCE_FROM_CENTER) / WHEEL_RADIUS
       right_wheel_speed = (u(1) + u(2)*DISTANCE_FROM_CENTER) / WHEEL_RADIUS
       wb_motor_set_velocity(left_wheel, 0);
       wb_motor_set_velocity(right_wheel, 0);
    else
        left_wheel_speed = (u(1) - u(2)*DISTANCE_FROM_CENTER) / WHEEL_RADIUS
       right_wheel_speed = (u(1) + u(2)*DISTANCE_FROM_CENTER) / WHEEL_RADIUS
       wb_motor_set_velocity(left_wheel,  left_wheel_speed);
       wb_motor_set_velocity(right_wheel,  right_wheel_speed);
     end
  end
end
  % if your code plots some graphics, it needs to flushed like this:
  drawnow;