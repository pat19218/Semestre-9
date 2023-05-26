%% Proyecto 2
% Francisco Lopez 17414
% Wilder Guerrero 18561


% robot 2

%% obtencion de data

robotat= robotat_connect('192.168.50.200');
pause(1);

objeto = robotat_get_pose(robotat,14,'eulzyx');
base = robotat_get_pose(robotat,16,'eulzyx');
canasta = robotat_get_pose(robotat,12,'eulzyx');

%% Posicion inicial y variables

flag = 0;
contador = 1;
time = 0;
robotno = 2;

q0 = zeros(6, 1);

robotat_mycobot_send_angles(robotat, robotno, q0);
pause(5);
robotat_mycobot_set_gripper_state_open(robotat, robotno);
pause(1);

%% positions

Xi = base(1);
Yi = base(2);
Zi = base(3);

Xii = objeto(1);
Yii = objeto(2);
Zii = objeto(3);
anz = objeto(4);
any = objeto(5);
anx = objeto(6);
% anz = anz - 90;

Xiii = canasta(1);
Yiii = canasta(2);
Ziii = canasta(3);

if objeto(2) <= 0 
    xa = Xii - Xi + 0.40;
    ya = Yii - Yi - 0.30;
    za = Zii - Zi + 0.30;
    an1 = anx-145;
    an2 = anz;
    an3 = any;
elseif objeto(2) > 0
    xa = Xii - Xi + 0.20;
    ya = Yii - Yi + 0.10;
    za = Zii - Zi + 0.15;
    an1 = anx-145;
    an2 = anz;
    an3 = any;
end

xb = Xiii - Xi + 0.362;
yb = Yiii - Yi - 0.031;
zb = Ziii - Zi + 0.1;

K0 = robot_fkine(q0);
[Q0, qist] = robot_ikine(K0, q0, 'full', 'transpose', 1000);
Q0 = rad2deg(Q0);

K1 = trans_hom(rotx(an1)*rotz(an2)*roty(an3), [xa; ya; za]);
[Q1, qist] = robot_ikine(K1, Q0, 'full', 'transpose', 1000);
Q1 = rad2deg(Q1);

K2 = trans_hom(rotx(-90), [-0.13; 0.2; 0.3]);
[Q2, qist] = robot_ikine(K2, Q0, 'full', 'transpose', 1000);
Q2 = rad2deg(Q2);

robotat_mycobot_send_angles(robotat, robotno, Q0);
pause(5);
robotat_mycobot_send_angles(robotat, robotno, Q1);
pause(3);
robotat_mycobot_set_gripper_state_closed(robotat, robotno);
pause(2);
robotat_mycobot_send_angles(robotat, robotno, Q0);
pause(3);
robotat_mycobot_send_angles(robotat, robotno, Q2);
pause(3);
robotat_mycobot_set_gripper_state_open(robotat, robotno);
pause(2);