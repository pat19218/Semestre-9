function [c, ceq] = collocation_and_boundary_constraints(X, U, N, dt, x0, xN)
    c = []; % restricciones de desigualdad
    
    % Se inicializa el vector de restricciones de igualdad
    ceq = [];
    
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