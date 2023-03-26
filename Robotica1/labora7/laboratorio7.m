% =========================================================================
% MT3005 - LABORATORIO 7: Cinem�tica inversa num�rica de manipuladores 
%                         seriales
% -------------------------------------------------------------------------
% Ver las instrucciones en la gu�a adjunta
% =========================================================================
%% Inciso 3.
% Verificaci�n de TODAS las variantes de cinem�tica inversa. 
% NO MODIFICAR, los valores se usan s�lo para la autocalificaci�n. 
qtest = (pi/6) * ones(6, 1);
q0 = zeros(6, 1);
Tdtest = robot_fkine(qtest);
qpos_pinv = robot_ikine(Tdtest, q0, 'pos', 'pinv');
qpos_dampedls = robot_ikine(Tdtest, q0, 'pos', 'dampedls');
qpos_transpose = robot_ikine(Tdtest, q0, 'pos', 'transpose', 100);

qrot_pinv = robot_ikine(Tdtest, q0, 'rot', 'pinv');
qrot_dampedls = robot_ikine(Tdtest, q0, 'rot', 'dampedls');
qrot_transpose = robot_ikine(Tdtest, q0, 'rot', 'transpose', 100);

qfull_pinv = robot_ikine(Tdtest, q0, 'full', 'pinv');
qfull_dampedls = robot_ikine(Tdtest, q0, 'full', 'dampedls');
qfull_transpose = robot_ikine(Tdtest, q0, 'full', 'transpose', 100);

%% Inciso 4.
% Respuesta a las preguntas. Coloque el valor seg�n las opciones que se le
% presentan para cada caso.

% M�todo con convercia m�s r�pida, opciones:
% 1 - pseudo-inversa
% 2 - levenberg-marquadt
% 3 - transpuesta
metodo_con_convergencia_mas_rapida = 0;

% M�todo con convercia m�s r�pida, opciones:
% 1 - pseudo-inversa
% 2 - levenberg-marquadt
% 3 - transpuesta
metodo_con_convergencia_mas_suave = 0;

% Combinaci�n que NO funcion� como se esperaba:
% 1 - IK de posici�n con pseudo-inversa
% 2 - IK de posici�n con levenberg-marquadt
% 3 - IK de posici�n con transpuesta
% 4 - IK de orientaci�n con pseudo-inversa
% 5 - IK de orientaci�n con levenberg-marquadt
% 6 - IK de orientaci�n con transpuesta
% 7 - IK completa con pseudo-inversa
% 8 - IK completa con levenberg-marquadt
% 9 - IK completa con transpuesta
combinacion_que_no_funciono = 0;