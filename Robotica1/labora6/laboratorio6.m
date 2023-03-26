% =========================================================================
% MT3005 - LABORATORIO 6: Cinemática diferencial numérica de manipuladores 
%                         seriales
% -------------------------------------------------------------------------
% Ver las instrucciones en la guía adjunta
% =========================================================================
%% Inciso 2.
% Verificación de la matriz de parámetros DH del manipulador. 
% NO MODIFICAR, los valores se usan sólo para la autocalificación. 
qtest = (pi/6) * ones(6, 1);
DH = robot_def(qtest);

%% Inciso 3.
% Verificación de la cinemática directa del manipulador. 
% NO MODIFICAR, los valores se usan sólo para la autocalificación. 
K = robot_fkine(qtest);

%% Inciso 5.
% Verificación de la cinemática diferencial del manipulador. 
% NO MODIFICAR, los valores se usan sólo para la autocalificación.
J = robot_jacobian(qtest);
Jv = J(1:3, :); 
Jw = J(4:6, :);

%% Inciso 6.
% Análisis de singularidades
q3 = [0;0;0;0;pi/2;pi/2];
robot_ellipsoid(q3, 'v')
q4 = [0;0;0;0;pi/2;0];
robot_ellipsoid(q4, 'v')
% Se establecen las cantidades a evaluar, el punteo y el tipo de 
% calificación, luego se guardan junto con las soluciones.
% BORRAR DEL ARCHIVO A SUBIR
%res_names = ["DH", "K", "Jv", "Jw"];
%res_points = [10, 10, 30, 30];
%res_type = zeros(size(res_points));
%res_msg = ' + 20 figuras Inciso 6.';
% save('laboratorio6.sol');





