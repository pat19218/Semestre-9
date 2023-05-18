% Conectamos con Servidor
Robotat = robotat_connect('192.168.50.200');

%% Obtenemos coordenadas de cada uno siendo

%{
{1} Efector final MyCobot 1
{2} Efector final MyCobot 2
{3} Objeto a manipular 1
{4} Objeto a manipular 2
{5} Aprox. base MyCobot 1 
{6} Aprox. base MyCobot 2
{7} Marker fijo en caja 
{8} Marker para mediciones puntos intermedios
%} 
MC1 =  robotat_mycobot_get_coords(Robotat, 1);
MC1_pose = robotat_get_pose(Robotat, 1, 'eulzyx')
MC1_q =  robotat_mycobot_get_angles(Robotat, 1);
MC2 =  robotat_mycobot_get_coords(Robotat, 2);
MC2_pose = robotat_get_pose(Robotat, 2, 'eulzyx');
MC2_q =  robotat_mycobot_get_angles(Robotat, 2);


O1 =   robotat_get_pose(Robotat, 3, 'eulzyx')
O2 =   robotat_get_pose(Robotat, 4, 'eulzyx');
ABR1 = robotat_get_pose(Robotat, 5, 'eulzyx');
ABR2 = robotat_get_pose(Robotat, 6, 'eulzyx');
MFC =  robotat_get_pose(Robotat, 7, 'eulzyx');
MMPI = robotat_get_pose(Robotat, 8, 'eulzyx');


robotat_mycobot_send_angles(Robotat, 1, [0,0,0,0,0,0]')
robotat_mycobot_send_angles(Robotat, 2, [0,0,0,0,0,0]')

save('Datos_Objetos.mat')

%% Poses

O1 =   robotat_get_pose(Robotat, 3, 'eulzyx');
MC1_pose = robotat_get_pose(Robotat, 1, 'eulzyx');


qqq = [0;0;0;0;0;0];

T0 = robot_fkine(qqq)

%{
T1 = [1,0,0,O1(1,3)+(O1(1,3)-MC1_pose(1,3))/2;...
    0,1,0,O1(1,3)+(O1(1,2)-MC1_pose(1,2))/2;...
    0,0,1,O1(1,3)+(O1(1,1)-MC1_pose(1,1))/2;...
    0,0,0,1]
%}

T1 = [1,0,0,MC1_pose(1)-O1(1);...
    0,1,0,MC1_pose(2)-O1(2);...
    0,0,1,MC1_pose(3)-O1(3);...
    0,0,0,1]
T1 = [1,0,0,-0.64;...
    0,1,0,0;...
    0,0,1,0.45;...
    0,0,0,1]


q1 = robot_ikine(T1, qqq, 'pos' , 'transpose');
q1 = rad2deg(q1)
robotat_mycobot_send_angles(Robotat, 1, q1')

tInterval = [0 1];
tvec = 0:0.02:1;
tfInterp1 = transformtraj(T0,T1,tInterval,tvec);


i = 0;
% ciclo principal de simulación:
while 1
    q = qqq;
    
    if i <= 50
        qqq = robot_ikine(tfInterp1(:,:,i+1), q, 'pos' , 'transpose');
        qqq = rad2deg(qqq(1,:))
        robotat_mycobot_send_angles(Robotat, 1, qqq')
        
        
    elseif i >= 50
        break
    end
    
    
    % Se actualizan los tiempos actuales de simulación
    i = i + 1;

    
    % if your code plots some graphics, it needs to flushed like this:
   
end

%%
robotat_mycobot_send_angles(Robotat, 1, [0,0,0,0,0,-50]')
load('Datos_Objetos.mat');

%% Convertir a poses


quat_rotation = MC1_pose(1:4);
quat_position = MC1_pose(5:7);
eul = quat2eul(quat_rotation);
rot = eul2rotm(eul);

POSE_efector_final1 = eye(4);
POSE_efector_final1(1:3,1:3) = rot;
POSE_efector_final1(1:3,4) = quat_position; % Pose 1
%--------------------------------------------------------------------------
quat_rotation = MC2_pose(1:4);
quat_position = MC2_pose(5:7);
eul = quat2eul(quat_rotation);
rot = eul2rotm(eul);

POSE_efector_final2 = eye(4);
POSE_efector_final2(1:3,1:3) = rot;
POSE_efector_final2(1:3,4) = quat_position; % Pose 2
%--------------------------------------------------------------------------
quat_rotation = O1(1:4);
quat_position = O1(5:7);
eul = quat2eul(quat_rotation);
rot = eul2rotm(eul);

POSE_O1 = eye(4);
POSE_O1(1:3,1:3) = rot;
POSE_O1(1:3,4) = quat_position; % Pose 3
%--------------------------------------------------------------------------
quat_rotation = O2(1:4);
quat_position = O2(5:7);
eul = quat2eul(quat_rotation);
rot = eul2rotm(eul);

POSE_O2 = eye(4);
POSE_O2(1:3,1:3) = rot;
POSE_O2(1:3,4) = quat_position; % Pose 4
%--------------------------------------------------------------------------
quat_rotation = ABR1(1:4);
quat_position = ABR1(5:7);
eul = quat2eul(quat_rotation);
rot = eul2rotm(eul);

POSE_ABR1 = eye(4);
POSE_ABR1(1:3,1:3) = rot;
POSE_ABR1(1:3,4) = quat_position; % Pose 5
%--------------------------------------------------------------------------
quat_rotation = ABR2(1:4);
quat_position = ABR2(5:7);
eul = quat2eul(quat_rotation);
rot = eul2rotm(eul);

POSE_ABR2 = eye(4);
POSE_ABR2(1:3,1:3) = rot;
POSE_ABR2(1:3,4) = quat_position; % Pose 6
%--------------------------------------------------------------------------
quat_rotation = MFC(1:4);
quat_position = MFC(5:7);
eul = quat2eul(quat_rotation);
rot = eul2rotm(eul);

POSE_MFC = eye(4);
POSE_MFC(1:3,1:3) = rot;
POSE_MFC(1:3,4) = quat_position; % Pose 7
%--------------------------------------------------------------------------
quat_rotation = MMPI(1:4);
quat_position = MMPI(5:7);
eul = quat2eul(quat_rotation);
rot = eul2rotm(eul);

POSE_MMPI = eye(4);
POSE_MMPI(1:3,1:3) = rot;
POSE_MMPI(1:3,4) = quat_position; % Pose 8
%--------------------------------------------------------------------------


