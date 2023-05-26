%%
%--------------------------------------------------------------------------
%   PROYECTO 2
%       Cris Pat        19218
%       Oscar Fuentes   19816
%--------------------------------------------------------------------------

%% obtencion de data

robotat= robotat_connect('192.168.50.200');
pause(1);

objeto = robotat_get_pose(robotat,13,'eulzyx');
base = robotat_get_pose(robotat,15,'eulzyx');
canasta = robotat_get_pose(robotat,17,'eulzyx');

%% Posicion inicial y variables

flag = 0;       % transicion de ir por el obj a soltar el obj
contador = 1;   % movimiento del brazo
time = 0;       % al terminar la secuencia se desconecta

q0 = zeros(6, 1);

robotat_mycobot_send_angles(robotat, 1, q0);
pause(0.05);
robotat_mycobot_set_gripper_state_open(robotat, 1);
pause(0.05);

%% Inversar y trayectoria

K0 = robot_fkine(q0);
[Q0, qist] = robot_ikine(K0, q0, 'full', 'transpose', 1000);
Q0 = rad2deg(Q0);

K2 = trans_hom(rotz(0)*roty(0)*rotx(0), [-0.1; 0; 0.4]);
[Q2, qist] = robot_ikine(K2, Q0, 'full', 'transpose', 1000);
Q2 = rad2deg(Q2);

[Q3, qist] = robot_ikine(K2, Q2, 'full', 'transpose', 1000);
Q3 = rad2deg(Q3);

QA = [Q0, Q2];
trayect = trapveltraj(QA,150);
QA = trayect;

QB = [Q2, Q3];
trayect = trapveltraj(QB,100);
QB = trayect;

%% main

while time <= 300
    if flag == 0
        if contador <= width(QA)
            robotat_mycobot_send_angles(robotat, 1, QA(:,contador))
        else
            robotat_mycobot_set_gripper_state_closed(robotat, 1);
            flag = 1;
            contador = 0;
        end

    else
        if contador <= width(QB)
            robotat_mycobot_send_angles(robotat, 1, QB(:,contador));
        else
            robotat_mycobot_set_gripper_state_open(robotat, 1);
        end

    end

    contador = contador + 1;
    time = time +1;
    pause(0.01);
end
%% Siempre desconectarse al finalizar pruebas

robotat_disconnect(robotat)
