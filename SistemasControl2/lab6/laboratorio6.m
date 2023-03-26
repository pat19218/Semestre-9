%% Laboratorio 6

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

%% Diseño de control por pole placement
% Seleccionamos nuestros polos:
    %5ms<tr<10ms    ts<100ms    10<Mp<20
p = [-110, -40+230i, -40-230i]; 
%Matriz K de la ley de control lineal
K = place(A,B,p);

%mejora para lazo cerrado
Acl = A - B*K;
% Usamos la función de pole placement con las matrices del sistema continuo
sys_cl = ss(Acl,B,C,D);  
sys = ss(A,B,C,D);  

%step(tf(sys_cl))
[u,t] = gensig('square',1.5,3,0.001); %(tipo, periodo, tiempo simulacion, tiempo muestreo )
u = u + 1;
%figure(1)
%plot(t,u)
%axis([0 3 0 3])%[x y]

%corrijo el desfase
Nbar = rscale(sys,K);

figure(1)
lsim(sys_cl*Nbar,u,t);
xlabel('Time')
ylabel('Voltage (V)')

linearSystemAnalyzer(sys_cl)

%% para el segundo caso

% Seleccionamos nuestros polos:
 %  ts<25ms    Mp=0
p1 = [-110, -40, -900]; 
%Matriz K de la ley de control lineal
K1 = place(A,B,p1);

%mejora para lazo cerrado
Acl1 = A - B*K1;
% Usamos la función de pole placement con las matrices del sistema continuo
sys_cl1 = ss(Acl1,B,C,D);  
sys1 = ss(A,B,C,D);  

%corrijo el desfase
Nbar1 = rscale(sys1,K1);

figure(1)
lsim(sys_cl1*Nbar1,u,t);
xlabel('Time')
ylabel('Voltage (V)')

linearSystemAnalyzer(sys_cl)


%%

    





