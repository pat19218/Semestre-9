% =========================================================================
% MT3005 - LABORATORIO 6: Cinem�tica diferencial num�rica de manipuladores 
%                         seriales
% -------------------------------------------------------------------------
% Ver las instrucciones en la gu�a adjunta
% =========================================================================
%% Inciso 2.
% Verificaci�n de la matriz de par�metros DH del manipulador. 
% NO MODIFICAR, los valores se usan s�lo para la autocalificaci�n. 
qtest = (pi/6) * ones(6, 1);
DH = robot_def(qtest);

%% Inciso 3.
% Verificaci�n de la cinem�tica directa del manipulador. 
% NO MODIFICAR, los valores se usan s�lo para la autocalificaci�n. 
K = robot_fkine(qtest);

%% Inciso 5.
% Verificaci�n de la cinem�tica diferencial del manipulador. 
% NO MODIFICAR, los valores se usan s�lo para la autocalificaci�n.
J = robot_jacobian(qtest);
Jv = J(1:3, :); 
Jw = J(4:6, :);

%% Inciso 6.
% An�lisis de singularidades
q3 = [0;0;0;0;pi/2;pi/2];
robot_ellipsoid(q3, 'v')
q4 = [0;0;0;0;pi/2;0];
robot_ellipsoid(q4, 'v')
% Se establecen las cantidades a evaluar, el punteo y el tipo de 
% calificaci�n, luego se guardan junto con las soluciones.
% BORRAR DEL ARCHIVO A SUBIR
%res_names = ["DH", "K", "Jv", "Jw"];
%res_points = [10, 10, 30, 30];
%res_type = zeros(size(res_points));
%res_msg = ' + 20 figuras Inciso 6.';
% save('laboratorio6.sol');





