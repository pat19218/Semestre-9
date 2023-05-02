%%
%--------------------------------------------------------------------------
%   PROYECTO 2
%       Cris Pat        19218
%       Oscar Fuentes   19816
%--------------------------------------------------------------------------

%% Establezco la conexion

%Importante estar conectado a la red wifi 
robotat = robotat_connect('192.168.50.200'); 

%% Obtengo los datos de todos 

pose_arm = robotat_get_pose(robotat, 2, 'eulzyx'); %Devuelve angulos euler
pose_obj = robotat_get_pose(robotat, 4, 'eulzyx'); %Devuelve angulos euler
pose_int = robotat_get_pose(robotat, 8, 'eulzyx'); %Devuelve angulos euler
pose_end = robotat_get_pose(robotat, 7, 'eulzyx'); %Devuelve angulos euler
q0 = zeros(1,6);

%% Interpolacion de la trayectoria

tray1 = mtraj(@tpoly, pose_arm(1:3), pose_int(1:3), 30);
tray2 = mtraj(@tpoly, pose_int(1:3), pose_obj(1:3), 25);
tray3 = mtraj(@tpoly, pose_obj(1:3), q0(1:3), 25);
tray4 = mtraj(@lspb, q0(1:3), [pose_end(1:2),pose_end(3)+0.07], 25);

tray = [tray1;tray2;tray3;tray4];

%% Pose efector final objetivo

qpos = zeros(1,6);

for i = 1:size(tray, 1)
    Td = transl(tray(i,:));
    
    qpos(:,:,end+1) = robot_ikine(Td, qpos(:,:,end)','pos', 'dampedls');
end

j = 0;
i = 0;


%% Envio de configuración y manipulación del objeto

%robotat_mycobot_send_angles(robotat, 2, q0);

% ciclo principal de simulación:
while (j<200)
  
  % Se actualizan los tiempos actuales de simulación
  j = j + 1;

  if (j<55)
      i = i + 1;
      robotat_mycobot_send_angles(robotat, 1, qpos(:, :, i))
      
  elseif (j>55 && j<75)
      robotat_mycobot_set_gripper_state_closed(robotat, 1)
      
  elseif (j>75 && j<100)
      i = i + 1;
      robotat_mycobot_send_angles(robotat, 1, qpos(:, :, i)')
  
  elseif (j>100 && j<125)
      i = i + 1;
      robotat_mycobot_send_angles(robotat, 1, qpos(:, :, i)')
      
  elseif (j>130 && j<150)
      robotat_mycobot_set_gripper_state_open(robotat, 1)
 
  end
  disp(j)
end


%% Siempre desconectarse al finalizar pruebas

robotat_disconnect(robotat)
