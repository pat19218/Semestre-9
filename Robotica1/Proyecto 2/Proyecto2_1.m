% Conectamos con Servidor
Robotat = robotat_connect('192.168.50.200');

%% 

t = robotat_get_pose(Robotat, 15, 'eulzyx');
desface = t(1:2);

% Sabremos pos

q0 = zeros(6,1);
TT = [1,0,0,-0.1;...
    0,1,0,0;...
    0,0,1,0.2;...
    0,0,0,1];

ET_F = [ 1, 0, 0,             -0.4683+0.1;
         0, 1, 0,             0.0245;
         0, 0, 1, (13+150)/1000;
         0, 0, 0,             1 ];

[ahist,qhist1] = robot_ikine(TT,q0, 'pos', 'transpose');
ahist = rad2deg(ahist);
robotat_mycobot_send_angles(Robotat, 11, ahist);
disp(ahist)

trplot(EulerToPose(TT), 'frame', 'A', 'color', 'b')
hold on
trplot(EulerToPose(ET_F), 'frame', 'A', 'color', 'r')
xlim([-10 10])
ylim([-10 10])
zlim([-10 10])

  

%% Obtener las posiciones de los objetos

%load('Datos_objetos.mat','MC1_pose','O1');

%robotat_mycobot_send_angles(Robotat, 1, [0,0,0,0,0,0]);
MC1_pose = robotat_get_pose(Robotat, 11, 'eulzyx');
O1 =   robotat_get_pose(Robotat, 13, 'eulzyx');

% [-7.78419791818854,-29.6569114684046,-171.994921549238]

%load('Datos_Objetos','O1','MC1_pose')

% Configuracion inicial 
q0 = zeros(6,1);


% Tranformar posiciones a poses
Pose_inicial = robot_fkine(q0);
Efector_final_pose = EulerToPose(MC1_pose);
Pose_Esponja = EulerToPose(O1);

Pose_Intermedia = Pose_Esponja;
Pose_Intermedia(3,4) = Efector_final_pose(3,4)+(+Pose_Esponja(3,4) - Efector_final_pose(3,4))/2;

%%{
temp1 = Efector_final_pose(3,4);
temp2 = Pose_Esponja(3,4);

Efector_final_pose(3,4) = temp2;
Pose_Esponja(3,4) = temp1;
%%}

% correciones


  % Efector_final_pose(3,4) = 0
 %  Pose_Esponja(3,4) = 0.5




% tInterval = [0 1];
% tvec = 0:0.02:1;
n = 20;
Conjunto1 = InterpolacionPoses(Efector_final_pose,Pose_Intermedia,n);
Conjunto2 = InterpolacionPoses(Pose_Intermedia,Pose_Esponja,n);

ahist = q0;
q = q0;
for i = 2:size(Conjunto1,3)
   [ahist,qhist1] = robot_ikine(Conjunto1(:,:,i),ahist, 'pos', 'transpose');
   %ahist = qhist1(:,end);
   qf = q;
   q = [qf,qhist1];
end

ahist = q(:,end);

for i = 2:size(Conjunto2,3)
   [ahist,qhist1] = robot_ikine(Conjunto1(:,:,i),ahist, 'pos', 'transpose');
  % ahist = qhist1(:,end);
   qf = q;
   q = [qf,qhist1];
end

q = rad2deg(q);

save('q','q');

robotat_mycobot_send_angles(Robotat, 11, q(:,472));

robotat_mycobot_send_angles(Robotat, 11, [0,0,0,0,0,0]);

%{
ahist = q(:,end);

for i = 2:size(Conjunto2,3)
   [~,qhist1] = robot_ikine(Conjunto2(:,:,i),ahist, 'pos', 'transpose');
   ahist = qhist1(1:end,end);
   qf = q;
   q = [qf,qhist1];
end
%}

%% Mandar al robot trayectoria
for i = 1:size(q,2)
robotat_mycobot_send_angles(Robotat, 11, q(:,i));  
pause(0.3);
end

%%

robotat_mycobot_send_angles(Robotat, 11, q(:,1));
robotat_mycobot_send_angles(Robotat, 11, [0,0,0,0,0,0]);

%%

T1 = [1,0,0,-0.64;...
      0,1,0,0;...
      0,0,1,1;...
      0,0,0,0.70]


q1 = robot_ikine(T1, zeros(6,1), 'pos' , 'transpose');
q1 = rad2deg(q1)
robotat_mycobot_send_angles(Robotat, 11, q1')


Efector_final_pose = [1,0,0,-0.49;...
                      0,1,0,0.075;...
                      0,0,1,0;...
                      0,0,0,0];
              
T1 =        [1,0,0,-0.666;...
                      0,1,0,0.20;...
                      0,0,1,0.1;...
                      0,0,0,0];
