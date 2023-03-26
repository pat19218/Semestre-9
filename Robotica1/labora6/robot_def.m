% =========================================================================
% MT3005 - LABORATORIO 6: Cinemática diferencial numérica de manipuladores 
%                         seriales
% -------------------------------------------------------------------------
% Ver las instrucciones en la guía adjunta
% =========================================================================
function [DH, IT_B, ET_F] = robot_def(q)
%ROBOT_DEF 
% Función en donde deben definirse los parámetros cinemáticos del manipulador 
% serial de interés.

    % Matriz de parámetros DH <-- COMPLETAR
    theta = [q(1);q(2)-pi/2;q(3);q(4)-pi/2;q(5)+pi/2;q(6)];
    d_j = [131.22; 0; 0; 63.4; 75.05; 45.6];
    a_j = [0; -110.4; -96; 0; 0; 0];
    alpha = [pi/2; 0; 0; pi/2; -pi/2; 0];
    DH = [theta, d_j, a_j, alpha];
    
    % Transformaciones de base y herramienta
    IT_B = eye(4);
    ET_F = eye(4);
end