function f = dynamics(x, u)
    % Parámetros del sistema
    m1 = 0.5; 
    m2 = 0.5; 
    l1 = 1; 
    l2 = 1; 
    g = 9.81; 
    
    % Se obtienen las coordenadas generalizadas a partir del vector de
    % estado
    q = x(1:2);
    dq = x(3:4);
    
    % Matrices del sistema mecánico no lineal
    D = [(m1+m2)*l1^2+m2*l2^2+2*m2*l1*l2*cos(q(2)), m2*l2^2+m2*l1*l2*cos(q(2)); 
        m2*l2^2+m2*l1*l2*cos(q(2)), m2*l2^2];
    C = [0, -m2*l1*l2*(2*dq(1)+dq(2))*sin(q(2)); m2*l1*l2*dq(1)*sin(q(2)), 0];
    G = g*[(m1+m2)*l1*sin(q(1))+m2*l2*sin(q(1)+q(2)); m2*l2*sin(q(1)+q(2))];
    B = [1,0; 0,1];

    % Definición del sistema dinámico 
    ff = [dq; -D^(-1)*(C*dq + G)];
    fg = [0,0; 0,0; D^(-1)*B];
    f = ff + fg*u;
end