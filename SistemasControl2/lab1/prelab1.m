%% Sistemas de control 2 - Laboratorio (2023)
% Laboratorio 1
% Cristhofer Isaac Patzán Martínez 
% Carne: 19218, IE3041 seccion 11

%% Primera Parte}

% Creo los valores de los dispositivos

R1 = 1000; R2 = 10000; R3 = 10000;
C1 = 1e-6; C2 = 0.1e-6; C3 = 10e-6;
load('variables.mat')
%despues de armado el circuito, voy al MODEL LINEAZER y ejecuto el STEP
%para obtene linsys, esto lo arrastro al workspace y luego en comando
%ejecuto...
% G =tf(linsys1)
%pzplot(G)
%pole(G)
%zpk(G)
%save('varLab1.mat' , 'linsys1', 'G')
%load('variables.mat')
%step(feedback(C*tf1,1))


%Caso1
T1 = 0.001; 
syms z
S = (z-1)/(T1*z);
%por tustis
C_1tustin = c2d(C,T1,'tustin');
H_tustin = c2d(tf1,T1,'tustin');
step(5*feedback(C_1tustin*H_tustin,1));

%por Zero-pole
C_1zpM = c2d(C,T1,'matched');
H_zpM = c2d(tf1,T1,'matched'); %Zero-pole matching method
step(5*feedback(C_1zpM*H_zpM,1));

%por backeuler
H1 = simplify((1e07)/(S^3 + 1120*S^2 + 3.1e04*S + 1e07));
H_be_T1 = tf([10,0,0,0],[2161,- 5271,4120,- 1000],T1);
pid_1 = pid(C.Kp,C.Ki,C.kd,C.tf,'Ts',T1,'IFormula','BackwardEuler','DFormula','BackwardEuler');
step(5*feedback(H_be_T1*pid_1,1));

%Caso 2
T2 = 0.0001; 
%Por tustin
C_2tustin = c2d(C,T2,'tustin');
H_tustin2 = c2d(tf1,T2,'tustin');
step(5*feedback(C_2tustin*H_tustin2,1));

%por zero-pole
C_2zpM = c2d(C,T2,'matched');
H_zpM2 = c2d(tf1,T2,'matched'); %Zero-pole matching method
step(5*feedback(C_2zpM*H_zpM2,1));

%por backeuler
H2 = simplify((1e07)/(S^3 + 1120*S^2 + 3.1e04*S + 1e07));
H_be_T2 = tf([1,0,0,0],[111232,- 322431,311200,- 100000],T2);
pid_2 = pid(C.Kp,C.Ki,C.kd,C.tf,'Ts',T2,'IFormula','BackwardEuler','DFormula','BackwardEuler');
step(5*feedback(H_be_T2*pid_2,1));


