%%
%--------------------------------------------------------------------------
%           PID constants
%--------------------------------------------------------------------------
% Define the system parameters
Tr = 0.5;   % rise time
Mp = 0.2;   % maximum overshoot
Ts = 2.0;   % settling time
tau = 1.0;  % time constant of the process

% Calculate damping ratio and natural frequency
%--------------we can use function damp---------------
zeta = -log(Mp) / sqrt(pi^2 + log(Mp)^2);
wn = pi / (Tr * sqrt(1 - zeta^2));

% Calculate initial value of controller gain Kc
Kp_initial = 1.0;  % initial value of Kp
Kc = (wn^2 * tau) / Kp_initial;

% Calculate Kp, Ki, and Kd
Kp = 0.6 * (Kc / tau);
Ki = (1.2 * Kc) / tau;
Kd = (0.075 * Kc * tau);

% Print the results
disp(['Kp = ', num2str(Kp)]);
disp(['Ki = ', num2str(Ki)]);
disp(['Kd = ', num2str(Kd)]);


num = wn^2;
den = [1 2*zeta*wn wn^2];
G = tf(num, den);

C1 = pid(Kp,Ki,Kd);
LC1 = feedback(C1.*G,1);
lcp = pole(LC1);
[WnLC, ZLC]=damp(LC1);
C2 = pid(ZLC(1), ZLC(2), ZLC(3));
LC2 = feedback(C2.*G,1);
step(LC2);
stepinfo(LC2)


%%
%--------------------------------------------------------------------------
%           Using linear optimization
%--------------------------------------------------------------------------
% Define the decision variables
Kp = optimvar('Kp', 'LowerBound', 0, 'UpperBound', 100);
Ki = optimvar('Ki', 'LowerBound', 0, 'UpperBound', 100);
Kd = optimvar('Kd', 'LowerBound', 0, 'UpperBound', 100);

% Define the objective function to minimize (in this case, we want to minimize the sum of Kp, Ki, and Kd)
obj = Kp + Ki + Kd;

% Define the constraints
Tr = 0.5; % rise time
Mp = 0.2; % maximum overshoot
Ts = 2.0; % settling time
tau = 1.0; % time constant of the process

zeta = -log(Mp) / sqrt(pi^2 + log(Mp)^2);
wn = pi / (Tr * sqrt(1 - zeta^2));

A = [
    zeta*wn*tau, tau^2, zeta*tau;
    zeta*tau, tau, wn*tau;
    1/(2*zeta), tau/(2*zeta), 1/(1e-9 + Kp.UpperBound + Ki.UpperBound/wn + Kd.UpperBound*wn);
    -1/(2*zeta), -tau/(2*zeta), 1/(1e-9 - Kp.LowerBound - Ki.LowerBound/wn - Kd.LowerBound*wn);
    0, tau, 1/(1e-9 - Kp.LowerBound - Ki.LowerBound/wn - Kd.LowerBound*wn);
    0, -tau, -1/(1e-9 + Kp.UpperBound + Ki.UpperBound/wn + Kd.UpperBound*wn)
];

b = [
    1.02;
    0.98;
    exp(-zeta*pi/sqrt(1 - zeta^2));
    exp(-zeta*pi/sqrt(1 - zeta^2));
    -4.6;
    4.6
];

constr = optimconstr(6,1);
constr(1) = A(1,:) * [Kp; Ki; Kd] <= b(1);
constr(2) = A(2,:) * [Kp; Ki; Kd] <= b(2);
constr(3) = A(3,:) * [Kp; Ki; Kd] <= b(3);
constr(4) = A(4,:) * [Kp; Ki; Kd] <= b(4);
constr(5) = A(5,:) * [Kp; Ki; Kd] <= b(5);
constr(6) = A(6,:) * [Kp; Ki; Kd] <= b(6);

% Solve the problem
prob = optimproblem('Objective', obj, 'Constraints', constr);
[sol, fval, exitflag] = solve(prob);

% Print the results
fprintf('Kp = %f\n', sol.Kp);
fprintf('Ki = %f\n', sol.Ki);
fprintf('Kd = %f\n', sol.Kd);

C1 = pid(Kp,Ki,Kd);
LC1 = feedback(C1.*G,1);
lcp = pole(LC1);
[WnLC, ZLC]=damp(LC1);
C2 = pid(ZLC(1), ZLC(2), ZLC(3));
LC2 = feedback(C2.*G,1);
step(LC2);
stepinfo(LC2)

%%
%--------------------------------------------------------------------------
%           Using quadratic optimization NO ME CONVENCE DEL TODO
%--------------------------------------------------------------------------

% Define the rise time, maximum overshoot, and settling time
tr = 0.5;  % seconds
Mp = 0.2;  % percent
ts = 2.0;  % seconds

% Define the second-order LTI system
wn = 4 / (Mp * tr);
zeta = sqrt((log(Mp)^2) / (pi^2 + log(Mp)^2));
num = wn^2;
den = [1 2*zeta*wn wn^2];
G = tf(num, den);

% Define the objective function
Q = diag([1, 1, 1]);
c = zeros(3, 1);

% Define the constraints
%--------------modify---------------------------
A = [1 0 0;
     0 1 0;
     0 0 1;
     1/ts 0 0;
     0 1/ts 0;
     0 0 1/ts];
 
b = [wn*sqrt(1-2*zeta^2);
     wn*zeta-1/(wn*ts);
     1/(Mp*wn);
     Inf;
     Inf;
     Inf];

% Solve the quadratic program using quadprog
[K, fval] = quadprog(Q, c, A, b);

% Display the solution
disp(['Optimal value of Kp: ' num2str(K(1))]);
disp(['Optimal value of Ki: ' num2str(K(2))]);
disp(['Optimal value of Kd: ' num2str(K(3))]);

%%
%--------------------------------------------------------------------------
%           Using quadratic optimization MAS CREIBLE
%--------------------------------------------------------------------------
% Define the parameters of the second-order LTI system
Tr = 0.5;   % Rise time
Mp = 0.2;  % Maximum overshoot
Ts = 2.0;   % Settling time

% Define the transfer function of the second-order LTI system
G = tf(1, [1 2*0.7*sqrt((log(Mp))^2/(pi^2 + (log(Mp))^2)) 1]);

% Define the optimization problem
H = [2/Tr 0 0; 0 2/Ts 0; 0 0 2];
f = [0; 0; 0];
A = [-1 0 0; 0 -1 0; 0 0 -1];
b = [0; 0; 0];
lb = [-100; -100; -100];
ub = [100; 100; 100];
x0 = [0; 0; 0];

% Solve the optimization problem using quadprog
[x,fval,exitflag,output] = quadprog(H,f,A,b,[],[],lb,ub,x0);

% Extract the optimal values of Kp, Ki, and Kd
Kp = x(1);
Ki = x(2);
Kd = x(3);

% Display the results
fprintf('Optimal value of Kp: %f\n', Kp);
fprintf('Optimal value of Ki: %f\n', Ki);
fprintf('Optimal value of Kd: %f\n', Kd);

C1 = pid(Kp,Ki,Kd);
LC1 = feedback(C1.*G,1);
lcp = pole(LC1);
[WnLC, ZLC]=damp(LC1);
C2 = pid(ZLC(1), ZLC(2), ZLC(3));
LC2 = feedback(C2.*G,1);
step(LC2);
stepinfo(LC2)


%%
%--------------------------------------------------------------------------
%           Using non-linear program
%--------------------------------------------------------------------------
