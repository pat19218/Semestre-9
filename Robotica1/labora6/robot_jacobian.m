% =========================================================================
% MT3005 - LABORATORIO 6: Cinemática diferencial numérica de manipuladores 
%                         seriales
% -------------------------------------------------------------------------
% Ver las instrucciones en la guía adjunta
% =========================================================================
function J = robot_jacobian(q, delta)    
    if(size(q, 2) ~= 1)
        error('robot_jacobian expects the configuration as a column vector.');
    end

    if(nargin == 1)
        delta = 1e-6;
    end

    % Dimensión de la configuración (DOFs)
    n = length(q); 
    
    % COMPLETAR 
    % |   |   |
    % v   v   v
    
    
    % Ciclo responsable de calcular la j-ésima columna del jacobiano, con 
    % base en el algoritmo descrito en la guía del laboratorio
    for j = 1:n
        K = robot_fkine(q); %Cinematica directa del manipulador conf. "q"
        R = tform2rotm(K);  %Extraer matriz de rotacion
        
        %datos para derivar por definicion
        q_new = q;
        q_new(j) = q(j) + delta;
        K_new = robot_fkine(q_new);
        %Primera derivada por definicion
        dKj = (K_new - K) / delta;
        
        %Cambio de posición
        dO = dKj(1:3,4);
        %Cambio de rotacion/orientacion
        dR = tform2rotm(dKj);
        
        %matriz anti-simetrica
        Sw = dR * (R');
        
        %w_q = vex(Sw);   %Matriz(fila, columna)  
                          %[vx;vy;vz] de Sw
                          %vx columna2 fila 3
                          %vy columna3 fila 1
                          %vz columna1 fila 2
        w_q = [Sw(3,2);Sw(1,3);Sw(2,1)]; 
        
        J(:, j) = [dO;w_q];
    end
end 