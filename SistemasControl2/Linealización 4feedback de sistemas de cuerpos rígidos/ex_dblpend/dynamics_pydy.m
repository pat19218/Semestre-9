% =========================================================================
% IE3041 - DINÁMICA DEL PÉNDULO DOBLE (CON PYDY)
% -------------------------------------------------------------------------
% Dinámica obtenida para el péndulo doble mediante la herramienta PyDy.
% =========================================================================
function f = dynamics_pydy(x)
    % Parámetros del sistema
    m = 1;
    l = 1;
    g = 9.81;
    
    % Se desempacan las variables de estado para que coincidan con el
    % código generado por Python
    q1 = x(1);
    q2 = x(2);
    u1 = x(3);
    u2 = x(4);
    
    % Campo vectorial del sistema
    f = [ u1; 
          u2; 
          (g*sin(q1 - 2*q2) + 3*g*sin(q1) + l*u1^2*sin(2*q1 - 2*q2) + 2*l*u2^2*sin(q1 - q2))/(l*(cos(2*q1 - 2*q2) - 3));
          (-g*sin(2*q1 - q2) + g*sin(q2) - 2*l*u1^2*sin(q1 - q2) - l*u2^2*sin(2*q1 - 2*q2)/2)/(l*(cos(q1 - q2)^2 - 2))   ];
end


