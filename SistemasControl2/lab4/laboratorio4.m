%% Sistemas de control 2 - Laboratorio (2023)
% Laboratorio 4
% Cristhofer Isaac Patzán Martínez 
% Carne: 19218, IE3041 seccion 11
%% Parte 1
M1 = 320;   %kg
M2 = 2500;  %kg
k = 500000; %N/m
fv = 15020; %Ns/m
ks = 80000; %N/m   95000
fs = 350;   %Ns/m  28000

numerador = [fs, ks];
denominador = [(M1*M2), (fs*M2)+(fv*M2)+(fs*M1), (k*M2)+(ks*M2)+(fs*fv)+(ks*M1), (fv*k)+(fv*ks), (k*ks)];
G0 = tf(numerador, denominador);

[A,B,C,D] = tf2ss(numerador,denominador);
