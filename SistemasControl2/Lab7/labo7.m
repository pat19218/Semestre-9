%% Laboratorio 7 
clear; clc;
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

load('variables.mat')

G = tf(linsys1);
%% Matrices
A = [-((R1+R2)/(R1*R2*c1)) 1/(R2*c1) -1/(R2*c1); 0 0 -1/(R3*c2); -1/(R2*c3) 1/(R2*c3) -(R2+R3)/(R2*R3*c3)];
B = [1/(R1*c1);0;0];
C = [0 1 0];
D = 0;

%% Controlabilida
Gamma = ctrb(A,B);
rank(Gamma); %es controlable

%% Diseño de control por LQR
% Seleccionamos las matrices de penalización
Q = eye(3);     %cantidad de variables salidas
R = eye(1);     %cantidad de variables entradas
% Usamos la función de lqr con las matrices del sistema y las de penalización
Klqr = lqr(A,B,Q,R);


%   objetivo    K = [-0.9300    0.5295   -5.0900]
Q = [10 0 0;...
    0 1 0;...
    0 0 1];     %cantidad de variables salidas
R = 1;     %hace q se acerque  mas a cero mientras más grande
% Usamos la función de lqr con las matrices del sistema y las de penalización
Klqr1 = lqr(A,B,Q,R);

%% Diseño de control por pole placement
% Seleccionamos nuestros polos favoritos (no se pueden repetir en Matlab):
p = [-110, -40+230i, -40-230i]; 
% Usamos la función de pole placement con las matrices del sistema continuo
Kpp = place(A, B, p);  
%Matriz K de la ley de control lineal
K = place(A,B,p);

%--------------------------------------------------------------------------
%               Diseño de observador por pole placement
%--------------------------------------------------------------------------
% Seleccionamos nuestros polos favoritos (recordando que deben ser agresivos):
p2 = p; 
% Usamos la función de pole placement con las matrices del sistema continuo
Lpp = place(A', C', p2)'; 

%--------------------------------------------------------------------------
%       Diseño de observador por aprox. Kalman en estado estable
%--------------------------------------------------------------------------
% Se establecen las matrices de penalización
%QL = B*B';
%RL = eye(1);

% Usamos la función de lqr con las matrices del sistema y las de penalización
Lkss = lqr(A', C', Q, R)';






