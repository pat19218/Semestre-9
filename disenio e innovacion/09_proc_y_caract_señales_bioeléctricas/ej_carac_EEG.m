%% IE3038 - Diseño e Innovación en Ingeniería 1
%  Ejemplo de extracción de características de señales EEG
%  Luis Alberto Rivera

%% Cargar datos y graficar el total de muestras
load datos_EEG.mat

N_tot = size(EEG_signals, 2);  % Número de muestras totales
t_tot = (0:(N_tot-1))/Fs_eeg;

figure(3); clf;
plot(t_tot, EEG_signals);
xlabel('t (s)');
ylabel('mV');
title('Muestras totales, 1 canal EEG')
grid on;


%% Tomar un segmento de las muestras correspondiente a 10 segundos, centrarlo, graficarlo
%  en tiempo, obtener su espectro de amplitud unilateral, y graficarlo también.
K = ceil(N_tot/(Fs_eeg*10));  % Se usa ceil porque la división puede no dar un entero.
k = randi(K);  % Entero al azar entre 1 y K

N_por_10_seg = floor(Fs_eeg*10);  % Se usa floor para garantizar que sea entero
segmento = EEG_signals((N_por_10_seg*(k-1)+1):min([N_por_10_seg*k, N_tot]));
segmento = segmento - mean(segmento);
N_seg = length(segmento);
t_seg = (0:(N_seg-1))/Fs_eeg;

SEG = fft(segmento);
P1 = abs(SEG/N_seg);
P1 = P1(1:N_seg/2+1); P1(2:end-1) = 2*P1(2:end-1);
funi = Fs_eeg*(0:(N_seg/2))/N_seg;

figure(4); clf;
subplot(2, 1, 1);
plot(t_seg, segmento);
xlim([t_seg(1), t_seg(end)]);
xlabel('t (s)');
ylabel('mV');
grid on;
title('Segmento EEG de ejemplo (centrado, sin filtrar)');

subplot(2,1,2);
stem(funi, P1);
xlim([funi(1), funi(end)]);
xlabel('f (Hz)');
title('Espectro de Amplitud Unilateral');


%% Extracción de características (dominio de la frecuencia): θ/β y β/α
%Theta = bandpower(segmento, Fs_eeg, [4 8]);  % theta (θ, 4–8 Hz)
%Beta = bandpower(segmento, Fs_eeg, [12 30]); % beta (β, 12–30 Hz)
%Alpha = bandpower(segmento, Fs_eeg, [8 12]); % alpha (α, 8–12 Hz)

%razon_1 = Theta/Beta;
%razon_2 = Beta/Alpha;


Theta = zeros(k, 1);
Beta = zeros(k, 1);
Alpha = zeros(k, 1);
razon_1 = zeros(k, 1);
razon_2 = zeros(k, 1);

for turno = 1:K
    trozo = EEG_signals((N_por_10_seg*(turno-1)+1):min([N_por_10_seg*turno, N_tot]));
    trozo = trozo - mean(trozo);

    Theta(turno) = bandpower(trozo, Fs_eeg, [4 8]);  % theta (θ, 4–8 Hz)
    Beta(turno) = bandpower(trozo, Fs_eeg, [12 30]); % beta (β, 12–30 Hz)
    Alpha(turno) = bandpower(trozo, Fs_eeg, [8 12]); % alpha (α, 8–12 Hz)

    razon_1(turno) = Theta(turno)/Beta(turno);
    razon_2(turno) = Beta(turno)/Alpha(turno);
end   

vec_car = [razon_1, razon_2]; % Está como vector fila

figure(5); clf;
scatter(razon_1, razon_2);  % Equivalente: scatter(vec_car(1, 1), vec_car(1, 2));
xlabel('θ/β');
ylabel('β/α');
grid on;
title('Vector de características, EEG');


% Modificar lo anterior para extraer las características de todos los segmentos en
% EEG_signals, y graficar todos los vectores de características en la misma figura.
% Ayudas: Usar un ciclo. Predefinir variables (por eficiencia). vec_car quedaría como una
% matriz de varias filas.
