% =========================================================================
% IE3041 - DINÁMICA DEL PÉNDULO DOBLE (CON EULER-LAGRANGE)
% -------------------------------------------------------------------------
% Dinámica obtenida para el péndulo doble mediante modelado directo 
% empleando las ecuaciones de Euler-Lagrange.
% =========================================================================
function f = dynamics(x, u)
    % Parámetros del sistema    
    m1 = 0.5; % kg
    m2 = 0.5; % kg
    l1 = 1; % m
    l2 = 1; % m
    g = 9.81; %m/s^2
    
    % Se desempacan las variables de estado
    q = x(1:2);
    dq = x(3:4);

    % Matrices del sistema mecánico, según la ecuación general del manipulador
    D = [ (m1+m2)*l1^2+m2*l2^2+2*m2*l1*l2*cos(q(2)),  m2*l2^2+m2*l1*l2*cos(q(2));
                         m2*l2^2+m2*l1*l2*cos(q(2)),  m2*l2^2                     ];
    
    C = [                        0, -m2*l1*l2*(2*dq(1)+dq(2))*sin(q(2)); 
          m2*l1*l2*dq(1)*sin(q(2)), 0                                    ];
    
    G = g*[ (m1+m2)*l1*sin(q(1))+m2*l2*sin(q(1)+q(2)); 
            m2*l2*sin(q(1)+q(2))                       ];
    
    B = [ 1, 0; 
          0, 1 ];

    % Campo vectorial del sistema 
    ff = [ dq; 
           -D^(-1)*(C*dq + G) ];
    
    fg = [ 0, 0; 
           0, 0; 
           D^(-1)*B ];
    
    f = ff + fg*u;
end


