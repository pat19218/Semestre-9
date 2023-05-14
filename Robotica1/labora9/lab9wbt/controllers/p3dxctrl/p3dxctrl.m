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
goal_points = [goal1, goal2, goal3, goal4];

% Se carga el mapa (occupancy grid) y se muestra
load('lab9map.mat');
figure;
imshow(map);
map = double(map); % Requerido por la Toolbox

i = 0; % tiempo actual de simulación (en iteraciones)
t = 0; % tiempo actual de simulación (en segundos)
% ============================================================


% ============================================================
% MODIFICAR
% ============================================================
% Operaciones previas a la simulación

% Initialize position data array
positionData = [];

% ciclo principal de simulación:
while wb_robot_step(TIME_STEP) ~= -1
  
  v_left = 1.78*rand;
  v_right = 0.46*rand + 2;
  
  %--------------------GPS--------------------------------------
  posicion = wb_gps_get_values(gps); %x y z data
  speed = wb_gps_get_speed(gps);
  
  % Add the GPS position to the position data array
  positionData = [positionData; posicion(1), posicion(2)];
  
  % Plot the GPS position and the path
  figure(3)
  plot(posicion(1), posicion(2), 'ro', 'MarkerSize', 10);
  hold on;
  plot(positionData(:,1), positionData(:,2), 'b-');
  hold off;
  % Set the plot limits
  xlim([-5, 5]);
  ylim([-5, 5]);
  %--------------------COMPASS---------------------------------
  orientacion = wb_compass_get_values(compass)
  ang_bearing = get_bearing_in_degrees(compass)
    
  %--------------------MOTION----------------------------------
  % send actuator commands, e.g.:
  %wb_motor_set_velocity(left_wheel, v_left);
  %wb_motor_set_velocity(right_wheel, v_right);
  
  % Se actualizan los tiempos actuales de simulación
  i = i + 1;
  t = t + TIME_STEP/1000;
  
  % if your code plots some graphics, it needs to flushed like this:
  drawnow;
end

% cleanup code goes here: write data to files, etc.
