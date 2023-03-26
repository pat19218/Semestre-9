% Lab 3

R1 = 1000;
R2 = 10000;
R3 = 10000;
c1 = 1e-6;
c2 = 0.1e-6;
c3 = 10e-6;

b_0 = 1/(R1*R2*R3*c1*c2*c3);
b_1 = 0;
b_2 = 0;

a_0 = 1/(R1*R2*R3*c1*c2*c3);
a_1 = ((c2*(R2+R3)*(R1+R2))+(R1*R2*(c1-c2)))/(R1*(R2^2)*R3*c1*c2*c3);
a_2 = ((R1*c1*(R2+R3))+(R3*c3*(R1+R2)))/(R1*R2*R3*c1*c3);


%% canonica controlable
A1 = [0 1 0; 0 0 1; -a_0 -a_1 -a_2];
B1 = [0;0;1];
C1 = [b_0 b_1 b_2];
D1 = 0;

%% Cononica observable
A2 = [-a_2 1 0; -a_1 0 1; -a_0 0 0];
B2 = [b_2;b_1;b_0];
C2 = [1 0 0];
D2 = 0;

%% Ecus. diferencia
A3 = [-((R1+R2)/(R1*R2*c1)) 1/(R2*c1) -1/(R2*c1); 0 0 -1/(R3*c2); -1/(R2*c3) 1/(R2*c3) -(R2+R3)/(R2*R3*c3)];
B3 = [1/(R1*c1);0;0];
C3 = [0 1 0];
D3 = 0;

%% Parte II
numerador = b_0;
denominador = [1 a_2 a_1 a_0];
G0 = tf(numerador,denominador);

[A4,B4,C4,D4] = tf2ss(numerador,denominador);

%en simulink armo el circuito y luego en model linealizer saco la ss 
%save('variables.mat', 'linsys1')
load('variables.mat')

A5 = linsys1.A;
B5 = linsys1.B;
C5 = linsys1.C;
D5 = linsys1.D;

%% Funciones de transferencias apartir de los conjuntos
s = tf('s');
G1 = C1/(s*eye(3)-A1)*B1+D1;
G2 = C2/(s*eye(3)-A2)*B2+D2;
G3 = C3/(s*eye(3)-A3)*B3+D3;
G4 = C4/(s*eye(3)-A4)*B4+D4;
G5 = C5/(s*eye(3)-A5)*B5+D5;



