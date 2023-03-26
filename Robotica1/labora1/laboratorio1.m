% =========================================================================
% MT3005 - LABORATORIO 1: Introducción a MATLAB
% -------------------------------------------------------------------------
% Ver las instrucciones en la guía adjunta
% =========================================================================
%% Inciso 2.
v = [4;5;-1];
w = [1,3,5].';

syms hx hy hz
h = [hx;hy;hz];
A = [1,0,0; 0,2,0; 0,0,3];
B = [1,2,3; -5,0,1; 4,5,6; 2,-1,-3];
b = [-1,2,0,1].';

%% Inciso 3.
C = [w,3.*w,5.*w];
x = (B.'*B)\(B.'*b);
p = dot(h'*A,h); 

%% Inciso 4.
u_hat = cross(w,v)/norm(cross(w,v));
r = w+v;
s = v-w;
t = w-u_hat;
alpha = acos(dot(v,r)/(norm(v)*norm(r))); 
beta = acos(dot(-w,-t)/(norm(w)*norm(t)));
k = dot(u_hat,s);

%% Inciso 5.
ga = [1,2,3];
f = trans_lineal(ga)';

%% Inciso 6.

T = [2,-3,1;-2 5 0;1 0 -10];% f*ga;

%% Inciso 7.
q = inv(T)*[-2;1;0];

