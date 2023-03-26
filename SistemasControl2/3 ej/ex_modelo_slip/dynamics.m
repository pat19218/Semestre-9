function f = dynamics(x, u)
    % Parámetros del sistema
    m = 500/1000; % 500g = 0.5 kg
    ell0 = 50/100; % 50cm = 0.5 m
    g = 9.81; % 9.81 m/s^2     
    k = 10; % 10 N/m 

    % Definición del sistema dinámico 
   % f = [x(3); x(4); x(1)*x(4)^2-g*cos(x(2))-(k/m)*(x(1)-ell0)+u(1); 
    %        -(2/x(1))*x(3)*x(4)+(g/x(1))*sin(x(2))+u(2)];
        
    %modifico solo la elongacion
    f = [x(3); x(4); x(1)*x(4)^2-g*cos(x(2))-(k/m)*(x(1)-ell0)+u; 
            -(2/x(1))*x(3)*x(4)+(g/x(1))*sin(x(2))];
        
end