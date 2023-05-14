%%
%--------------------------------------------------------------------------
%   PROYECTO 2
%       Cris Pat        19218
%       Oscar Fuentes   19816
%--------------------------------------------------------------------------

%% Establezco la conexion

%Importante estar conectado a la red wifi 
clear;clc;
robotat = robotat_connect('192.168.50.200'); 

%% Obtengo los datos de todos 
q0 = zeros(1,6);
robotat_mycobot_send_angles(robotat, 2, q0);

GripPos = robotat_mycobot_get_coords(robotat,2);
%GripOr = robotat_get_pose(Rport,1,'eulXYZ');
ObjPos = robotat_get_pose(robotat,4,'XYZ');
%IntPoint =  robotat_get_pose(Rport,8,'eulXYZ');
BasePos = robotat_get_pose(robotat,6,'XYZ');

%% Obtención de posiciones de movimiento

CordGrip1 = GripPos(1:3)/1000; %pasar de mm a metros, ya que la pos del griper se obtiene con getcords

ObjPos1 = transl(BasePos(1:3))*[ObjPos(1:3)';1]; %transformación BTI*OTI = OTB (objeto respecto a la base)
ObjPos1 = ObjPos1(1:3)';

ObjPos2 = [ObjPos1(1)+0.1;ObjPos1(2)+0.1;ObjPos1(3)-0.1]; %desfase de la esponja

ObjPos1(3) = ObjPos1(3);
ObjPos1(2) = CordGrip1(2);
ObjPos1(1) = ObjPos1(1); %posición intermedia

%% Interpolacion 
mov1 = mtraj(@tpoly,CordGrip1',ObjPos1,10); %del griper a posición intermedia

mov = mov1;

qrob = zeros(1,6);

for i = 1:size(mov,1) %
    dummy =[eye(3),mov(i,:)';zeros(1,3),1];
    qrob(:,:,end+1) = robot_ikine(dummy,qrob(:,:,end)','pos');
end


qrob(:,:,end+1) = [qrob(:,1,end),qrob(:,2,end),qrob(:,3,end),qrob(:,4,end),deg2rad(135),deg2rad(-155)]; %Rotación del efector final
qrob(:,:,end+1) = [qrob(:,1,end),qrob(:,2,end),qrob(:,3,end),qrob(:,4,end),deg2rad(135),deg2rad(-155)];

%% 
PosInt = robot_fkine(qrob(:,:,end)');
ObjPosInt = PosInt(1:3,4);%obtener posición intermedia en  x y z

mov2 = mtraj(@tpoly,ObjPosInt',ObjPos2',10); %de posicion intermedia a esponja

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
clc
robotat_mycobot_set_gripper_state_open(robotat,2);
robotat_mycobot_send_angles(robotat,2,[0;0;0;0;0;0]); %asegurar posición incial en 0
pause(1);
while(k<size(qrob,3))
    try
        robotat_mycobot_send_angles(robotat,2,qrob(:,:,k)');
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
