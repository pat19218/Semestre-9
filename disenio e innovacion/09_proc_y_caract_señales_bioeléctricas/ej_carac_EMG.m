%% IE3038 - Diseño e Innovación en Ingeniería 1
%  Ejemplo de extracción de características de señales EMG
%  Luis Alberto Rivera

%% Cargar datos y graficar una señal de ejemplo
load datos_EMG.mat

N = size(EMG_signals, 2);  % Número de muestras por señal
K = size(EMG_signals, 1);  % Número de señales
t = (0:(N-1))/Fs_emg;

k = randi(K);  % Entero al azar entre 1 y K
figure(1); clf;
plot(t, EMG_signals(k, :));
xlabel('t (s)');
ylabel('V');
grid on;
title('Señal EMG de ejemplo');


%% Extracción de características (dominio del tiempo): MAV y ZC
mav = zeros(K, 1);
zc = zeros(K, 1);

for turno = 1:K
    mav(turno) = mean(abs(EMG_signals(turno, :)));
    zc(turno) = ZC_v2(EMG_signals(turno, :), 0.05);  
end

vec_car = [mav, zc]; % Está como vector fila

figure(2); clf;
scatter(mav, zc);  % Equivalente: scatter(vec_car(1, 1), vec_car(1, 2));
xlabel('mav');
ylabel('zc');
grid on;
title('Vector de características, EMG');

% Modificar lo anterior para extraer las características de todas las señales en
% EMG_signals, y graficar todos los vectores de características en la misma figura.
% Ayudas: Usar un ciclo. Predefinir variables (por eficiencia). vec_car quedaría como una
% matriz de varias filas.
