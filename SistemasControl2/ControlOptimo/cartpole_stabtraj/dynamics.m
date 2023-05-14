function f = dynamics(x, u)  
    % Parámetros del sistema
    m = 0.3;
    M = 1;
    ell = 0.5;
    g = 9.81;

    % Campo vectorial del sistema dinámico
    % q = [x theta] dq = [dx dtheta]
    dq1 = ( ell*m*sin(x(2))*x(4)^2 + u + m*g*cos(x(2))*sin(x(2)) )/ ( M + m*(1 - cos(x(2))^2) );
    dq2 = -( ell*m*cos(x(2))*sin(x(2))*x(4)^2 + u*cos(x(2)) + (M+m)*g*sin(x(2)) ) / (ell*M + ell*m*(1-cos(x(2))^2) );
    
    f = [ x(3); x(4); dq1; dq2 ]; 
end