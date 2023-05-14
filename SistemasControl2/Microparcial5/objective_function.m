function J = objective_function(X, U, N, dt)
    J = 0; 
    
    % Se efect�a la colocaci�n trapezoidal para la funci�n objetivo 
    for k = 1:N
        J = J + (dt/2)*( (U(:,k).'*U(:,k)) + (U(:,k+1).'*U(:,k+1)));
    end
end