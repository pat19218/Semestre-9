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
    DH = [ q(1), 131.22/1000,        0,  pi/2;
           q(2)-pi/2,        0,   -110.4/1000,     0;
           q(3),        0, -96/1000,     0;
           q(4)-pi/2,  63.4/1000,        0,  pi/2;
           q(5)+pi/2,  75.05/1000,        0, -pi/2;
           q(6),   45.6/1000,        0,     0 ];
    
    % Transformaciones de base y herramienta
    %IT_B = [rotx(0)*roty(0)*rotz(0),[-0.2817;0.0408;0.1824];zeros(1,3),1];
    IT_B = eye(4);
    
    IT_B = [ -1, 0, 0, -0.4165; 
             0, -1, 0, -0.0275; 
             0,  0, 1, -61.14/1000;
             0,  0, 0,  1.0 ];
    
%     ET_F = [ 1, 0, 0,             0; 
%              0, 1, 0,             0; 
%              0, 0, 1, 175/1000;
%              0, 0, 0,             1 ];
    ET_F = transl([0,0,150/1000])*trotz(-45);
end