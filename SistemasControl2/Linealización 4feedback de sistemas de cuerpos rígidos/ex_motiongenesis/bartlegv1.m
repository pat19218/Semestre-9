%-------------------------------+--------------------------+-------------------+-----------------
% Quantity                      | Value                    | Units             | Description
%-------------------------------|--------------------------|-------------------|-----------------
LA                              =  1;                      % m                   Constant
LB                              =  4;                      % m                   Constant
LC                              =  2.5;                    % m                   Constant
LN                              =  3;                      % m                   Constant
LD                              =  2.6;                    % m                   Constant
LE                              =  3;                      % m                   Constant
mA                              =  1;                      % kg                  Constant
mB                              =  1;                      % kg                  Constant
mC                              =  1.5;                    % kg                  Constant
mE                              =  0.5;                    % kg                  Constant

qA                              =  0;                      % rad                 Initial Value
qE                              =  0;                      % rad                 Initial Value
qAp                             =  0;                      % rad/sec             Initial Value
qEp                             =  0;                      % rad/sec             Initial Value
t0                              =  0;                      % second              Initial Time
tf                              =  20;                     % sec                 Final Time
dt                              =  0.01;                   % sec                 Integration Step
%------------------------------------------------------------------------------------------------
% Evaluate constants
IA = 0.08333333333333333*mA*LA^2;
IB = 0.08333333333333333*mB*LB^2;
IC = 0.08333333333333333*mC*(LC+LD)^2;
IE = 0.3333333333333333*mE*LE^2;

% Drag force constant: 0.5*rho*Cd*A*r_arm
Kdrag = 5;

% Solve for the remaining initial conditions
syms qB qC
Loop = [LA*cos(qA)+LB*cos(qB)-LC*cos(qC); LA*sin(qA)+LB*sin(qB)-LC*sin(qC)-LN];
[qBs, qCs] = vpasolve(Loop == [0;0], qB, qC);
clear qB qC
qB = double(qBs(1));
qC = double(qCs(1));

% Setup the simulation
K = (tf - t0) / dt;
x0 = [qA, qB, qC, qE, qAp, qEp]';
x = x0;
X = x;

u = 0;
U = u;

for k = 0:K-1
    u = 10;
    k1 = propulsor_dynamics(x, u);
    k2 = propulsor_dynamics(x+(dt/2)*k1, u);
    k3 = propulsor_dynamics(x+(dt/2)*k2, u);
    k4 = propulsor_dynamics(x+dt*k3, u);
    x = x + (dt/6)*(k1+2*k2+2*k3+k4);
    
    X = [X, x];
    U = [U, u];
end

figure;
t = t0:dt:tf;
plot(t, X', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$q_A(t)$', '$q_B(t)$', '$q_C(t)$', '$q_E(t)$', ...
    '$\dot{q}_A$', '$\dot{q}_E$', 'Location', 'northwest', 'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 12);

figure;
s = 7;
xlim(s*[-0.5, 1.5]);
ylim(s*[-0.5, 1.5]);
grid off;
hold on;

x = X(:,1);
qA = x(1);
qB = x(2);
qC = x(3);
qE = x(4);

pA = [LA*cos(qA), LA*sin(qA)]';
pB = pA + [LB*cos(qB), LB*sin(qB)]';
pC = [0, LN]';
pD = pC + [(LC+LD)*cos(qC), (LC+LD)*sin(qC)]';
pE = pD + [LE*cos(qC+qE), LE*sin(qC+qE)]';

h1 = plot([0,pA(1)], [0,pA(2)], 'Color', [0,0.4470,0.7410], 'LineWidth', 2);
h2 = plot([pA(1), pB(1)], [pA(2), pB(2)], 'Color', [0.8500,0.3250,0.0980], 'LineWidth', 2);
h3 = plot([pC(1), pD(1)], [pC(2), pD(2)], 'Color', [0.9290,0.6940,0.1250], 'LineWidth', 2);
h4 = plot([pD(1), pE(1)], [pD(2), pE(2)], 'Color', [0.4940,0.1840,0.5560], 'LineWidth', 2);

for k = 2:K+1
    x = X(:,k);
    qA = x(1);  
    qB = x(2);
    qC = x(3);
    qE = x(4);
    
    pA = [LA*cos(qA), LA*sin(qA)]';
    pB = pA + [LB*cos(qB), LB*sin(qB)]';
    pC = [0, LN]';
    pD = pC + [(LC+LD)*cos(qC), (LC+LD)*sin(qC)]';
    pE = pD + [LE*cos(qC+qE), LE*sin(qC+qE)]';

    h1.XData = [0,pA(1)];
    h1.YData = [0,pA(2)];
    h2.XData = [pA(1), pB(1)];
    h2.YData = [pA(2), pB(2)];
    h3.XData = [pC(1), pD(1)];
    h3.YData = [pC(2), pD(2)];
    h4.XData = [pD(1), pE(1)];
    h4.YData = [pD(2), pE(2)];
    
    pause(dt);
end