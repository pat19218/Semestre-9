% =========================================================================
% MT3005 - LABORATORIO 8: control cinemático de manipuladores seriales
% -------------------------------------------------------------------------
% Ver las instrucciones en la guía adjunta
% =========================================================================
function [DH, IT_B, ET_F] = robot_def(q)
%ROBOT_DEF 
% Función en donde deben definirse los parámetros cinemáticos del manipulador 
% serial de interés.

    % Matriz de parámetros DH
    DH = [ q(1)         ,  0.13122,        0,  pi/2;
           q(2) - (pi/2),        0,  -0.1104,     0;
           q(3)         ,        0,   -0.096,     0;
           q(4) - (pi/2),   0.0634,        0,  pi/2;
           q(5) + (pi/2),  0.07505,        0, -pi/2;
           q(6)         ,   0.0456,        0,     0 ];
    
%     Transformaciones de base y herramienta
%     IT_B = eye(4);
%     ET_F = [ 1, 0, 0,             0; 
%              0, 1, 0,             0; 
%              0, 0, 1,      (8)/1000;
%              0, 0, 0,             1 ];

    IT_B = eye(4);
    ET_F = transl([0 0 8/100])*trotz(-45);
end