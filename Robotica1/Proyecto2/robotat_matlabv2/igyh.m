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

T_arm = [eye(3),pose_arm(1,1:3)';zeros(1,3),1];
T_obj = [eye(3),pose_obj(1,1:3)';zeros(1,3),1];
T_int = [eye(3),pose_int(1,1:3)';zeros(1,3),1];
T_end = [eye(3),pose_int(1,1:3)';zeros(1,3),1];

q1 = robot_ikine(T_obj,q0','pos','dampedls');

%% Interpolacion de la trayectoria

tray1 = mtraj(@tpoly, pose_arm(1:3), pose_int(1:3), 30);
tray2 = mtraj(@tpoly, pose_int(1:3), pose_obj(1:3), 25);
tray3 = mtraj(@tpoly, pose_obj(1:3), q0(1:3), 25);
tray4 = mtraj(@lspb, q0(1:3), [pose_end(1:2),pose_end(3)+0.07], 25);

tray = [tray1;tray2;tray3;tray4];

%% Pose efector final objetivo




%% Envio de configuración y manipulación del objeto




%% Siempre desconectarse al finalizar pruebas

robotat_disconnect(robotat)
