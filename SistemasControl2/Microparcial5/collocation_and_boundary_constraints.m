function [c, ceq] = collocation_and_boundary_constraints(X, U, N, dt, x0, xN)
    c = []; % restricciones de desigualdad
    
    % Se inicializa el vector de restricciones de igualdad
    ceq = [];
    
    m = 1; % kg
    ell = 1; % m
    g = 9.81; % m/s^2

    % Campo vectorial del sistema (anclado)
    dynamics = @(x,u) [                               x(2); 
                        -(g/ell)*sin(x(1)) + (1/m*ell^2)*u ];
    % Se establecen las restricciones de colocación
    for k = 1:N 
        ceq = [ceq; X(:,k+1) - X(:,k) - ...
            (1/2)*dt*( dynamics(X(:,k+1),U(:,k+1)) + dynamics(X(:,k),U(:,k)) )];
    end
    
    % Se establecen las restricciones de frontera
    ceq = [ ceq; 
            X(:,1) - x0; 
            X(:,end) - xN ];
end