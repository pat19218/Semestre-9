% ============================================================
% NO MODIFICAR
% ============================================================
TIME_STEP = 64;
MAX_JOINT_SPEEDS = [pi; pi; pi; 2*pi; 2*pi; 2*pi];

% Handles para controlar los motores de las juntas del robot
joint_handles(1) = wb_robot_get_device('shoulder_pan_joint');
joint_handles(2) = wb_robot_get_device('shoulder_lift_joint');
joint_handles(3) = wb_robot_get_device('elbow_joint');
joint_handles(4) = wb_robot_get_device('wrist_1_joint');
joint_handles(5) = wb_robot_get_device('wrist_2_joint');
joint_handles(6) = wb_robot_get_device('wrist_3_joint');

% Handles para controlar los motores del gripper
gripper_handles(1) = wb_robot_get_device('finger_1_joint_1');
gripper_handles(2) = wb_robot_get_device('finger_2_joint_1');
gripper_handles(3) = wb_robot_get_device('finger_middle_joint_1');

% Velocidad de los motores de las juntas
% (se están empleando a la mitad de su velocidad máxima)
joint_speeds = 0.5 * MAX_JOINT_SPEEDS; 
for i = 1:6
  wb_motor_set_velocity(joint_handles(i), joint_speeds(i));
end

% Se coloca al robot en su configuración cero (HOME)
q0 = zeros(6, 1);
robot_set_config(joint_handles, q0);

i = 0; % tiempo actual de simulación (en iteraciones)
t = 0; % tiempo actual de simulación (en segundos)
% ============================================================


% ============================================================
% MODIFICAR
% ============================================================

%Descripcion y planificacion de trayectorias

%Coordenadas EF
ef_pos = [-0.817, -0.354, -0.005];

%Coordenadas xyz de las dos posiciones finales deseadas
lata_pos = [0.75, 0.5, 0.22];
posint1 = [0.3, 0.65, 0.5];
contendor_pos = [0.5, -0.82, 0.7];
posint2 = [0.7, -0.07, 0.68];

%Interpolacion de la trayectoria
tray1 = mtraj(@tpoly, ef_pos, posint1, 30);
tray2 = mtraj(@tpoly, posint1, lata_pos, 25);
tray3 = mtraj(@tpoly, lata_pos, posint2, 25);
tray4 = mtraj(@lspb, posint2, contendor_pos, 25);

tray = [tray1;tray2;tray3;tray4];

%Pose efector final objetivo
qpos = zeros(1,6);

for i = 1:size(tray, 1)
    Td = transl(tray(i,:));
    qpos(:,:,end+1) = robot_ikine(Td, qpos(:,:,end)','pos', 'dampedls');
end

j = 0;
i = 0;

% ciclo principal de simulación:
while wb_robot_step(TIME_STEP) ~= -1
  
  % Se actualizan los tiempos actuales de simulación
  j = j + 1;
  t = t + TIME_STEP/1000;

  if (j<55)
      i = i + 1;
      robot_set_config(joint_handles, qpos(:, :, i)');
      
  elseif (j>55 && j<75)
      gripper_close(gripper_handles);
      
  elseif (j>75 && j<100)
      i = i + 1;
      robot_set_config(joint_handles, qpos(:, :, i)');
  
  elseif (j>100 && j<125)
      i = i + 1;
      robot_set_config(joint_handles, qpos(:, :, i)');
      
  elseif (j>130 && j<150)
      gripper_open(gripper_handles);
      
  end
  disp(j)
  % if your code plots some graphics, it needs to flushed like this:
  drawnow;
end
