%% IE3038 - Dise�o e Innovaci�n en Ingenier�a 1
%  Ejemplo de uso de la funci�n detecta_EMG
%  Luis Alberto Rivera

%%
load datos_detecta_EMG.mat

figure(1); clf
plot(y);
xlim([1, length(y)])
title('Se�al capturada completa');

es = detecta_EMG(y, Fs, win, Tn, ga, 2);

% NOTAS:
% * Ver los comentarios de la funci�n detecta_EMG
% * win debe ser seg�n el tiempo que se estime que durar� la actividad EMG de inter�s
% * Tn es un aproximado del tiempo estimado antes de que empiece la actividad.
% * Probar distintos valores de ga. T�picamente, valores entre 1.1 y 2 deber�an funcionar.
%   Depende de cu�nto ruido se tenga.
% * Si se tiene una matriz con varias se�ales, se puede colocar la funci�n en un ciclo
%   for, o se podr�a modificar la funci�n para aceptar y devolver matrices.
