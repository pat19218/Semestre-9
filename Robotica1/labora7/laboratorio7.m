% =========================================================================
% MT3005 - LABORATORIO 7: Cinemática inversa numérica de manipuladores 
%                         seriales
% -------------------------------------------------------------------------
% Ver las instrucciones en la guía adjunta
% =========================================================================
%% Inciso 3.
% Verificación de TODAS las variantes de cinemática inversa. 
% NO MODIFICAR, los valores se usan sólo para la autocalificación. 
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
% Respuesta a las preguntas. Coloque el valor según las opciones que se le
% presentan para cada caso.

% Método con convercia más rápida, opciones:
% 1 - pseudo-inversa
% 2 - levenberg-marquadt
% 3 - transpuesta
metodo_con_convergencia_mas_rapida = 0;

% Método con convercia más rápida, opciones:
% 1 - pseudo-inversa
% 2 - levenberg-marquadt
% 3 - transpuesta
metodo_con_convergencia_mas_suave = 0;

% Combinación que NO funcionó como se esperaba:
% 1 - IK de posición con pseudo-inversa
% 2 - IK de posición con levenberg-marquadt
% 3 - IK de posición con transpuesta
% 4 - IK de orientación con pseudo-inversa
% 5 - IK de orientación con levenberg-marquadt
% 6 - IK de orientación con transpuesta
% 7 - IK completa con pseudo-inversa
% 8 - IK completa con levenberg-marquadt
% 9 - IK completa con transpuesta
combinacion_que_no_funciono = 0;