%% Establezco la conexion

%Importante estar conectado a la red wifi 
clear;clc;
robotat = robotat_connect('192.168.50.200'); 

%% Obtengo los datos de todos 
q0 = zeros(1,6);
robotat_mycobot_send_angles(robotat, 1, q0);

GripPos = robotat_mycobot_get_coords(robotat,11);%ef final
ObjPos = robotat_get_pose(robotat,13,'XYZ');    %esponja pos
BasePos = robotat_get_pose(robotat,15,'XYZ');   %base mycobot

%% Ajuste a mm

CordGrip1 = GripPos(1:3)/1000;  %pasar de mm a metros, ya que la pos del 
                                % griper se obtiene con getcords


%transformación BTI*OTI = OTB (objeto respecto a la base)                                
ObjPos1 = transl(BasePos(1:3))*[ObjPos(1:3)';1];
ObjPos1 = ObjPos1(1:3)';

%desfase de la esponja
ObjPos2 = [ObjPos1(1)+0.1;ObjPos1(2)+0.1;ObjPos1(3)-0.1]; 

ObjPos1(3) = ObjPos1(3);
ObjPos1(2) = CordGrip1(2);
ObjPos1(1) = ObjPos1(1); %posición intermedia

%Interpolacion de la trayectoria
tray1 = mtraj(@tpoly, ef_pos, posint1, 30);
% tray2 = mtraj(@tpoly, posint1, lata_pos, 25);
% tray3 = mtraj(@tpoly, lata_pos, posint2, 25);
% tray4 = mtraj(@lspb, posint2, contendor_pos, 25);

%tray = [tray1;tray2;tray3;tray4];
mov = tray1;

%Pose efector final objetivo
qrob = zeros(1,6);

%% trayectoria 1

for i = 1:size(mov,1) %
    dummy =[eye(3),mov(i,:)';zeros(1,3),1];
    qrob(:,:,end+1) = robot_ikine(dummy,qrob(:,:,end)','pos');
end

qrob(:,:,end+1) = [qrob(:,1,end),qrob(:,2,end),qrob(:,3,end),qrob(:,4,end),deg2rad(135),deg2rad(-155)]; %Rotación del efector final
qrob(:,:,end+1) = [qrob(:,1,end),qrob(:,2,end),qrob(:,3,end),qrob(:,4,end),deg2rad(135),deg2rad(-155)];

%% trayectoria 2

PosInt = robot_fkine(qrob(:,:,end)');
ObjPosInt = PosInt(1:3,4);%obtener posición intermedia en  x y z

mov2 = mtraj(@tpoly,ObjPosInt',ObjPos2',25); %de posicion intermedia a esponja

mov = mov2;

for i = 1:size(mov,1)
    dummy =[eye(3),mov(i,:)';zeros(1,3),1];
    qrob(:,:,end+1) = robot_ikine(dummy,qrob(:,:,end)','pos');
end


qrob = rad2deg(qrob); 
qrob = max(-160,qrob);
qrob = min(160,qrob);

%% Envio de configuración y manipulación del objeto

%robotat_mycobot_send_angles(robotat, 2, q0);
k = 1;
robotat_mycobot_set_gripper_state_open(robotat,2);
robotat_mycobot_send_angles(robotat,2,[0;0;0;0;0;0]); %asegurar posición incial en 0
pause(1);
while(k<size(qrob,3))
    try
        robotat_mycobot_send_angles(robotat,1,qrob(:,:,k)');
        k=k+1;
        pause(0.3);
    catch
        disp('Error envio de datos');
    end
end

robotat_mycobot_set_gripper_state_closed(robotat,2);
robotat_mycobot_send_angles(robotat, 2, q0);

%% Siempre desconectarse al finalizar pruebas

robotat_disconnect(robotat)

j = 0;
i = 0;




