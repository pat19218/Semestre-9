% =========================================================================
% MT3005 - Ejemplo de cinemática inversa numérica para el Puma560
% =========================================================================
mdl_puma560;

% Configuraciones de prueba
q1 = [2*pi/3; pi/4; -3*pi/4; pi/4; 0; pi/4];
q2 = [0; pi; -pi/2; 0; 0; 0];

% Parámetros que requiere el algoritmo
q0 = [0; 0; 0; 0; 0; 0];    % configuración inicial 
Td = p560.fkine(q1').T;     % pose de efector final deseada
%Td = p560.fkine(q2').T;
%Td = p560.fkine(q2').T + [0,0,0,-0.3; 0,0,0,-0.3; 0,0,0,0; 0,0,0,0];

% Inicialización del algoritmo
eps = 1e-06;        % tolerancia del error
N = 100;            % número (máximo) de iteraciones
od = Td(1:3, 4);    % posición deseada del EF
q_k = q0;           % configuración inicial
T = p560.fkine(q_k').T;		
o_k = T(1:3, 4);    % posición incial del EF
ep = od - o_k;      % error inicial
n = 0;
Q = q0;             % array para almacenar la evolución de las iteraciones

% El algoritmo iterativo se repite hasta que el error llegue a la 
% tolerancia deseada o se supere el número máximo de iteraciones 
while( (norm(ep) > eps) && (n < N) )
    T = p560.fkine(q_k').T;		
    o_k = T(1:3, 4);        % posición actual del EF
    ep = od - o_k;          % error actual
    J = p560.jacob0(q_k');  % jacobiano completo
    Jv = J(1:3, :);		    % jacobiano de posición
   	
    % Opciones de algoritmos
    Ji = pinv(Jv);		                    % pseudo-inversa
    %Ji = Jv' / (Jv*Jv' + (0.1^2)*eye(3));   % Levenberg-Marquadt
    %Ji = Jv';                               % traspuesta

    q_k = q_k + Ji * ep;    % algoritmo de cinemática inversa 
    n = n + 1;
    Q = [Q, q_k];           % se almacena el histórico de la configuración
end

disp('Resultado del algoritmo de cinemática inversa:');
disp(q_k)
disp('Verificación con la pose de efector final deseada:')
disp(p560.fkine(q_k').T)

% Histórico de la configuración
figure('WindowState', 'maximized');
subplot(1,2,1);
plot(Q', 'LineWidth', 1);
ylabel('$\mathbf{q}_k$', 'Interpreter', 'latex', 'FontSize', 18);
xlabel('$k$', 'Interpreter', 'latex', 'FontSize', 18);
grid minor;

% Animación del histórico
subplot(1,2,2);
p560.plot3d(q0');
waitforbuttonpress;
p560.plot3d(Q');

