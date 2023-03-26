%% IE3038 - Diseño e Innovación en Ingeniería 1
%  Ejemplo de uso de la función detecta_EMG
%  Luis Alberto Rivera

%%
load datos_detecta_EMG.mat

figure(1); clf
plot(y);
xlim([1, length(y)])
title('Señal capturada completa');

es = detecta_EMG(y, Fs, win, Tn, ga, 2);

% NOTAS:
% * Ver los comentarios de la función detecta_EMG
% * win debe ser según el tiempo que se estime que durará la actividad EMG de interés
% * Tn es un aproximado del tiempo estimado antes de que empiece la actividad.
% * Probar distintos valores de ga. Típicamente, valores entre 1.1 y 2 deberían funcionar.
%   Depende de cuánto ruido se tenga.
% * Si se tiene una matriz con varias señales, se puede colocar la función en un ciclo
%   for, o se podría modificar la función para aceptar y devolver matrices.
