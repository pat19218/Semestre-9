
%% Conexion con el servidor del Robotat
clear all;clc;
%Conexión con robotat
myCobot = robotat_connect('192.168.50.200');


%% Obteniendo los valores base de los marcadores
qzeros = zeros(6,1);
qzeros(6) = -45;
robotat_mycobot_send_angles(myCobot,1,qzeros);
robotat_mycobot_set_gripper_state_open(myCobot,1);  
pause(3);

%% Posiciones de objetos y definición de trayectoria

% Obtener posiciones inciales de los marcadores
marcador_base = robotat_get_pose(myCobot,15,'eulxyz'); %Robot 1 
%marcador_base(1) = marcador_base(1) + 0.07 ;
%marcador_base(3) = marcador_base(3); %desfase del marcador de la base

marcador_objeto = robotat_get_pose(myCobot,13,'eulxyz'); % objeto a capturar
marcador_gripper = robotat_mycobot_get_coords(myCobot,1); 
marcador_caja = robotat_get_pose(myCobot,17,'eulxyz'); 

%marcador_interm = robotat_get_pose(myCobot,8,'eulxyz'); 
marcador_interm = [0,-15,-90,90,0,-50];

base_pos = marcador_base(1:3);
obj_pos =  marcador_objeto(1:3);
caja_pos = marcador_caja(1:3);
caja_pos(1) = marcador_caja(1);

grip_pos = marcador_gripper(1:3)/1000;
interm_pos = marcador_interm(1:3);

obj_or = marcador_objeto(4:6);

%posicion de la esponja respecto a la base
obj_pos = (transl(-base_pos)) * [obj_pos';1]  ;
obj_pos = obj_pos(1:3);

%posicion de la caja respecto a la base
caja_pos = (transl(-base_pos)) * [caja_pos';1]  ;
caja_pos = caja_pos(1:3);
caja_pos(1) = caja_pos(1)-0.05;
caja_pos(3) = caja_pos(3)+0.20;

%posicion del pto intermedio respecto a la base
interm_pos = (transl(-base_pos)) * [interm_pos';1]  ;
interm_pos = interm_pos(1:3);
interm_pos(3) = grip_pos(3)-0.15;

%  pos_int = [obj_pos(1)+0.1;obj_pos(2)+0.1;obj_pos(3)-0.1];

% Primera prueba de movimiento

if obj_pos(2)>0
    obj_pos2 = [obj_pos(1)+0.05;obj_pos(2);obj_pos(3)];
elseif obj_pos(2) <=0
    obj_pos2 = [obj_pos(1)+0.05;obj_pos(2)-0.04;obj_pos(3)];
end


obj_pos(3) = grip_pos(3)-0.05;
obj_pos(2) = obj_pos(2);
obj_pos(1) = obj_pos(1);


%Trayectoria del griper hacia intermedio prev. esponja
traj1 = mtraj(@tpoly,grip_pos',obj_pos',10);

mov = [traj1];

qpos = zeros(1,6);

for i = 1:size(mov,1)
    Td =transl(mov(i,:));
    qpos(:,:,end+1) = robot_ikine(Td,qpos(:,:,end)','pos','pinv');
end

 qpos(:,:,end+1) = [qpos(:,1,end),qpos(:,2,end),qpos(:,3,end),qpos(:,4,end),qpos(:,5,end),-deg2rad(obj_or(3)-0.05+pi/2)];
% qpos(:,:,end+1) = [qpos(:,1,end),qpos(:,2,end),qpos(:,3,end),qpos(:,4,end),deg2rad(135),deg2rad(-155)];

pos_int = robot_fkine(qpos(:,:,end)');
pos_int = pos_int(1:3,4);


%Trayectoria del intermedio hacia esponja 
mov2 = mtraj(@tpoly,pos_int',obj_pos2',10);

mov = [mov2];

for i = 1:size(mov,1)
    Td =transl(mov(i,:));
    qpos(:,:,end+1) = robot_ikine(Td,qpos(:,:,end)','pos','pinv');
end

% traj 2
%Trayectoria de esponja hacia intermedio prev. caja

mov3 = mtraj(@tpoly,obj_pos2',interm_pos',10);

mov = [mov3];

for i = 1:size(mov,1)
    Td =transl(mov(i,:));
    qpos(:,:,end+1) = robot_ikine(Td,qpos(:,:,end)','pos','pinv');
end

% Trayectoria del intermedio hacia caja

mov4 = mtraj(@tpoly,interm_pos',caja_pos',10);

mov = [mov4];

for i = 1:size(mov,1)
    Td =transl(mov(i,:));
    qpos(:,:,end+1) = robot_ikine(Td,qpos(:,:,end)','pos','pinv');
end

qpos = rad2deg(qpos);


qpos = max(-160,qpos);
qpos = min(160,qpos);

%% Movimiento de captura de esponja

%robotat_mycobot_set_gripper_state_open(myCobot,2);
%pause(2);

for k=1:size(qpos,3)
    try
        robotat_mycobot_send_angles(myCobot,1,qpos(:,:,k)');
        pause(0.3);
%         
        if k == 22
            robotat_mycobot_set_gripper_state_closed(myCobot,1);
            pause(2);
        end
%         
    catch
        disp('Error envio de datos');
    end
end

robotat_mycobot_set_gripper_state_open(myCobot,1);

