% =========================================================================
% MT3005 - LABORATORIO 7: Cinemática inversa numérica de manipuladores 
%                         seriales
% -------------------------------------------------------------------------
% Para la implementación de los algoritmos numéricos ver la guía y seguir
% las instrucciones.
% 
% INSTRUCCIONES DE USO:
% -------------------------------------------------------------------------
% La función robot_ikine puede tomar un número variable de argumentos,
% siendo el mínimo 2 (Td y q0) y el máximo 7. Los parámetros que no se
% especifican toman su valor default.
%
% - Td      pose de efector final deseada (en forma de una matriz de
%           transformación homogénea de 4x4.
%
% - q0      configuración inicial (inicialización del algoritmo) en forma
%           de vector columna.
%
% - type    tipo de cinemática inversa, posibles valores:
%           -> 'pos'  para sólo cinemática inversa de posición (default).
%           -> 'rot'  para sólo cinemática inversa de orientación.
%           -> 'full' para cinemática inversa completa.
%
% - method  tipo de algoritmo numérico, posibles valores:
%           -> 'pinv'      pseudo-inversa
%           -> 'dampedls'  algoritmo de Levenberg-Marquadt
%           -> 'transpose' transpuesta
%
% - maxiter número máximo de iteraciones para el algoritmo (default = 50).
%
% - tolp    tolerancia para el error de posición (default = 1e-06).
%
% - tolo    tolerancia para el error de orientación (default = 1e-05).
%
% Finalmente, la función retorna (el segundo valor de retorno puede 
% obviarse):
% 
% - q       solución al problema de cinemática inversa, en forma de vector
%           columna.
%
% - q_hist  histórico de la evolución iterativa de la solución a la
%           cinemática inversa, corresponde a un array de tamaño n x k.
% =========================================================================
function [q, q_hist] = robot_ikine(Td, q0, type, method, maxiter, tolp, tolo)
%ROBOT_IK 
% Obtiene la cinemática inversa del robot descrito (mediante sus parámetros DH) 
% en la función robot_def. 
    if((nargin < 2) || (nargin > 7))
        error('Invalid number of arguments.');
    end

    switch nargin
        case 2
            type = 'pos';
            method = 'pinv';
            maxiter = 50;
            tolp = 1e-06;
            tolo = 1e-05;
        case 3
            method = 'pinv';
            maxiter = 50;
            tolp = 1e-06;
            tolo = 1e-05;
        case 4
            maxiter = 50;
            tolp = 1e-06;
            tolo = 1e-05;
        case 5
            tolp = 1e-06;
            tolo = 1e-05;
        case 6
            tolo = 1e-05;
    end

    if(size(q0, 2) ~= 1)
        error('robot_ikine expects the initial configuration as a column vector.');
    end

    % Inicialización
    q = q0;
    k = 0;
    q_hist = zeros(numel(q0), maxiter); % histórico de la configuración
    % COMPLETAR 
    % |   |   |
    % v   v   v
    %procedimiento para el error de  posicion
    od = Td(1:3, 4);    % posicion deseada del EF
    T = robot_fkine(q);
    o_k = T(1:3, 4);    % posicion inicial 
    ep = od - o_k;  %Error inicial
    
    %Procedimiento para error de orientacion
    R1 = Td(1:3,1:3);   %o usar tform2rotm(pose)
    R2 = T(1:3,1:3);
    Q1 = rot2cuat(R1);
    Q2 = rot2cuat(R2);
    iQ2 = invcuat(Q2);
    Qe = multcuat(Q1,iQ2);    
    eo = Qe(2:end);%cuat2rot(Qe);        %Error de orientacion
   
    % Ciclo responsable de implementar el método iterativo, según el 
    % algoritmo descrito en las notas de clase
    while( ((norm(ep) > tolp) || (norm(eo) > tolo)) && (k < maxiter))
    % COMPLETAR 
    % |   |   |
    % v   v   v 
        T = robot_fkine(q);
        
        J = robot_jacobian(q); 
        Jv = J(1:3, :);		    % jacobiano de posición
        Jw = J(4:6, :);         % jacobiano de orientacion
        
        switch type
            case 'pos'
                o_k = T(1:3, 4);    % posicion actual 
                ep = od - o_k;      % Error actual
                eo = zeros(3, 1);
                e = [ep;eo];
                
            case 'rot'
                %Procedimiento para error de orientacion
                R2 = T(1:3,1:3);
                Q2 = rot2cuat(R2);
                iQ2 = invcuat(Q2);
                Qe = multcuat(Q1,iQ2);    
                eo = Qe(2:end);%cuat2rot(Qe);    %Error de orientacion
                ep = zeros(3, 1);
                e = [ep;eo];
                    
            case 'full'
                o_k = T(1:3, 4);    % posicion actual 
                ep = od - o_k;      % Error actual
                
                R2 = T(1:3,1:3);
                Q2 = rot2cuat(R2);
                iQ2 = invcuat(Q2);
                Qe = multcuat(Q1,iQ2);    
                eo = Qe(2:end);%cuat2rot(Qe);        %Error de orientacion
                e = [ep;eo];
               
            otherwise
                error('Invalid ikine type.');
        end


        switch method
            case 'pinv'
                Jip = pinv(Jv);  % pseudo-inversa
                Jio = pinv(Jw);  
                Ji = pinv(J);
            case 'dampedls'
                lambda_square = 0.1;
                Jip = Jv' / (Jv*Jv' + (lambda_square)*eye(3)); % Levenberg-Marquadt
                Jio = Jw' / (Jw*Jw' + (lambda_square)*eye(3)); % Levenberg-Marquadt
                Ji = J' / (J*J' + (lambda_square)*eye(6));
            case 'transpose'
                alphap = ((ep')*Jv*(Jv')*ep)/((ep')*Jv*(Jv')*Jv*(Jv')*ep);
                Jip = alphap*(Jv');   % traspuesta
                
                alphao = ((eo')*Jw*(Jw')*eo)/((eo')*Jw*(Jw')*Jw*(Jw')*eo);
                Jio = alphao*(Jw');   % traspuesta
                
                alpha = ((e')*J*(J')*e)/((e')*J*(J')*J*(J')*e);
                Ji = alpha*(J');   % traspuesta
                
            otherwise
                error('Invalid ikine method.');
        end
        
        switch type
            case 'pos'
               q = q + Jip * ep;    % algoritmo de cinemática inversa
            case 'rot'
                q = q + Jio * eo;    % algoritmo de cinemática inversa
            case 'full'
               q = q + Ji * e;    % algoritmo de cinemática inversa        
            otherwise
                error('Invalid ikine type.');
        end
        
        k = k + 1;
        q_hist(:, k) = q; % se almacena la configuración en el histórico 
    end

    disp(['ikine algorithm ended after ', num2str(k), ' iterations']);
    q_hist = q_hist(:, 1:k);
    figure
    title('Historico de q')
    plot(q_hist)
end