%--------------------------------------------------------------------------
% Obtención de features en el dominio de la frecuencia de señales EEG.
% Pruebas con Patient_1_interictal_segment_0001 de Kaggle
% https://www.kaggle.com/competitions/seizure-prediction/data
% Camila Lemus Lone - 18272
% Universidad del Valle de Guatemala
%--------------------------------------------------------------------------

clc; clear;

%% 

% % Ubonn SANO
% load('SetA_Sano_UBonn.mat', 'eeg_struct')
% datos_Sano = eeg_struct.data;
% Fs_Sano = eeg_struct.sampling_frequency;
% Ts = 1/Fs;        % Período de muestreo
% 
% T = 20; %Tiempo
% N = T*Fs; %Numero de muestras (ventaneado)
% t = (0:(N-1))*Ts; %Vector de tiempo (desde 0 hasta el numero de muestras -1
% 
% ventana = canal1(1:N); 
% ventana = ventana - mean(ventana);
% figure(1); clf;
% plot(t, ventana);
% 
% X1 = fft(ventana); %Transformada de Fourier 
% 
% f_posi = Fs*(0:(N/2))/N;
% 
% P1 = abs(X1/N);
% P2 = P1(1:N/2+1);
% P2(2:end-1) = 2*P2(2:end-1);


%% Transformada de Fourier para tener señales en el dominio de la frecuencia
load('Patient_1_interictal_segment_0001.mat', 'interictal_segment_1');
Fs = interictal_segment_1.sampling_frequency; % Frecuencia de muestreo en Hz                    
Ts = 1/Fs;        % Período de muestreo
canal1 = interictal_segment_1.data(1,:);  % Extraer solo el Canal L_1 de la matriz
T = 20; %Tiempo
N = T*Fs; %Numero de muestras (ventaneado)
t = (0:(N-1))*Ts; %Vector de tiempo (desde 0 hasta el numero de muestras -1

ventana = canal1(1:N); 
ventana = ventana - mean(ventana);
figure(1); clf;
plot(t, ventana);

X1 = fft(ventana); %Transformada de Fourier 

f_posi = Fs*(0:(N/2))/N;

P1 = abs(X1/N);
P2 = P1(1:N/2+1);
P2(2:end-1) = 2*P2(2:end-1);

N100 = ceil(N*100/(Fs)); % 100 Hz

figure(2); clf;
% subplot(2,1,1);
stem(f_posi(1:N100),P2(1:N100),'r');
% title('Ventana 1');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');

%% Extracción de Features

