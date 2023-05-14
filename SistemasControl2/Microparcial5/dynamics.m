function f = dynamics(x, u)  
    % Parámetros del sistema
    m = 1; % kg
    ell = 1; % m
    g = 9.81; % m/s^2
    f = [ x(2); 
                    -(g/ell)*sin(x(1)) + (1/m*ell^2)*u ]; 
end