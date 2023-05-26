clc;clear;
robotat = robotat_connect('192.168.50.200'); 

%%
qdeseada = [0,-15,-90,90,0,-50]';
q0 = zeros(6,1);%qdeseada;
robotat_mycobot_set_gripper_state_open(robotat, 1)
robotat_mycobot_send_angles(robotat, 1, q0);  
%robotat_mycobot_send_angles(robotat, 1, [0,-0,-0,0,0,-0]');  

%%
%VALORES PARA SETEAR TODO
%BasePos = robotat_get_pose(robotat,15,'eulzyx');
%desfase = BasePos(1:2)+[+0.07,0];

O1 = robotat_get_pose(robotat, 13, 'eulzyx') % posicion de la espoja %13
ang_o1 = O1(4:6);
T1 = [eul2rotm(ang_o1),O1(1:3)';0 0 0 1];



% NO SE USA
%EfectFinal = robotat_get_pose(robotat, 11, 'eulzyx') % posicion de la espoja
%POSE1 = EulerToPose(EfectFinal)
% 
% T1 = [0,0,1,O1(1)-0.09;...
%       0,1,0,O1(2)-0.025;...
%       1,0,0,0.35;...%0.25
%       0,0,0,1];
% 
%  T1 = EulerToPose(O1)
%% Hacia objetivo

[q,qhist] = robot_ikine(T1,qdeseada,'pos');
qhist(end,end) = -30;

robotat_mycobot_send_angles(robotat, 1, (q)); 
pause(2);
%qhist(2,end) = qhist(2,end)-5;
%robotat_mycobot_send_angles(robotat, 1, qhist(:,end)); 

%% capturar objetivo
robotat_mycobot_send_angles(robotat, 1, qdeseada);
pause(3);
robotat_mycobot_set_gripper_state_closed(robotat, 1)
%Segunda parte
%% depositar

Caja = robotat_get_pose(robotat, 17, 'eulzyx') % posicion de la espoja %13

T1 = [1,0.0017,-0.0028,Caja(1)-0.09;...
      -0.0016,0.9989,0.0479,Caja(2);...
      0.0028,-0.0479,0.998,0.30;...%0.25
      0,0,0,1];
  
[q,qhist] = robot_ikine(T1,q0,'pos'); %qdeseada reemplazar
qhist = rad2deg(qhist);
robotat_mycobot_send_angles(robotat, 1, rad2deg(q)); 
pause(2);
robotat_mycobot_set_gripper_state_open(robotat, 1)
pause(5)
robotat_mycobot_send_angles(robotat, 1, qdeseada);

%% Siempre desconectarse al finalizar pruebas

robotat_disconnect(robotat)
