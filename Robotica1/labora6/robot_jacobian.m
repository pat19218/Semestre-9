% =========================================================================
% MT3005 - LABORATORIO 6: Cinem�tica diferencial num�rica de manipuladores 
%                         seriales
% -------------------------------------------------------------------------
% Ver las instrucciones en la gu�a adjunta
% =========================================================================
function J = robot_jacobian(q, delta)    
    if(size(q, 2) ~= 1)
        error('robot_jacobian expects the configuration as a column vector.');
    end

    if(nargin == 1)
        delta = 1e-6;
    end

    % Dimensi�n de la configuraci�n (DOFs)
    n = length(q); 
    
    % COMPLETAR 
    % |   |   |
    % v   v   v
    
    
    % Ciclo responsable de calcular la j-�sima columna del jacobiano, con 
    % base en el algoritmo descrito en la gu�a del laboratorio
    for j = 1:n
        K = robot_fkine(q); %Cinematica directa del manipulador conf. "q"
        R = tform2rotm(K);  %Extraer matriz de rotacion
        
        %datos para derivar por definicion
        q_new = q;
        q_new(j) = q(j) + delta;
        K_new = robot_fkine(q_new);
        %Primera derivada por definicion
        dKj = (K_new - K) / delta;
        
        %Cambio de posici�n
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