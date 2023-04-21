%% IE3038 - Diseño e Innovación en Ingeniería 1
%  Ejercicios de procesamiento, extracción de características y clasificación de señales
%  bioeléctricas
%  Nombre: Cristhofer Isaac Patzán Martínez
%  Carné: 19218
%  Sección: 20

%  ESCRIBA EL CÓDIGO CORRESPONDIENTE EN LOS ESPACIOS DEBAJO DE LAS INSTRUCCIONES EN CADA
%  UNA DE LAS SECCIONES. ANTES DE ENTREGAR SU SCRIPT, ASEGÚRESE DE QUE CORRA SIN
%  ERRORES. AL CALIFICAR, SE CORRERÁ EL SCRIPT PARA VER SI SE GENERAN LOS RESULTADOS Y
%  GRÁFICAS SOLICITADAS. PUEDE ASUMIR QUE EL .mat ESTÁ DISPONIBLE EN EL "Current Folder".

%  Las imágenes, gráficas, matrices de confusión y porcentajes de clasificación correcta
%  que generará deben incluirse en un reporte (.pdf). Organice los resultados según los
%  incisos a continuación.

%% 1.1 Cargar datos EMG (las señales ya están filtradas y centradas)
%  Cargue los datos contenidos en datos_bioelec.mat. En esta primera parte, usarán las
%  variables EMG_c1, EMG_c2 y EMG_c3, que contienen señales de tres gestos distinos
%  realizados con la mano (tres clases). También usarán Fs_emg.
%  Note que las señales están como vectores fila. Note también que no se tiene el mismo
%  número de señales por clase.
clear;clc;
load('datos_bioelec.mat')


%% 1.2 Graficar una señal al azar de cada clase - Figura en el reporte
%En la Figura 1 deberá graficar una señal al azar de la clase 1, una señal al azar de la
%clase 2, y una señal al azar de la clase 3. Grafique versus tiempo, en segundos
%(empezando en t = 0). Use colores distintos para cada gráfica. Identifique los ejes e
%incluya una leyenda.

data = {EMG_c1, EMG_c2, EMG_c3};
N = zeros(1, 3);
K = zeros(1, 3);
for i = 1:3
    N(i) = size(data{i}, 2);
    K(i) = size(data{i}, 1);
end

dif = K(1) - K(2);
if dif < 0
    EMG_c1 = [EMG_c1;zeros(abs(dif),N(1))];
    K(1) = size(EMG_c1, 1);
elseif dif > 0
    EMG_c2 = [EMG_c2;zeros(abs(dif),N(2))];    
    K(2) = size(EMG_c2, 1);
end
dif = K(1) - K(3);
if dif < 0
    EMG_c1 = [EMG_c1;zeros(abs(dif),N(1))];
    EMG_c2 = [EMG_c2;zeros(abs(dif),N(2))];
    K(1) = size(EMG_c1, 1);
    K(2) = size(EMG_c2, 1);
elseif dif > 0
    EMG_c3 = [EMG_c3;zeros(abs(dif),N(2))];
    K(3) = size(EMG_c3, 1);
end

t = (0:(N(1)-1))/Fs_emg;

k1 = randi(K(1));  % Entero al azar entre 1 y K
k2 = randi(K(2));  % Entero al azar entre 1 y K
k3 = randi(K(3));  % Entero al azar entre 1 y K

figure(1); clf;
hi = sgtitle('Señales EMG vs tiempo');
hi.FontSize = 18;
hi.Color = 'r';
hi.FontName = 'verdana';
    subplot(3,1,1);
        plot(t, EMG_c1(k1, :),'Color',[0.1, 0.5, 0.1]);
        %axis([0 1 -1 1])
        legend('Señal tipo 1');
        xlabel('t (s)');
        ylabel('V');
        grid on;
    subplot(3,1,2);
        plot(t, EMG_c2(k2, :),'Color',[0.5, 0.0, 0.1]);
        %axis([0 1 -1 1])
        legend('Señal tipo 2');
        xlabel('t (s)');
        ylabel('V');
        grid on;
    subplot(3,1,3);
        plot(t, EMG_c3(k3, :),'Color',[0.2, 0.5, 0.5]);
        %axis([0 1 -1 1])
        legend('Señal tipo 3');
        xlabel('t (s)');
        ylabel('V');
        grid on;



%% 1.3 Obtener características en dominio del tiempo
%  Acá deberá obtener 3 características para cada señal, de cada clase:
%      - MAV de la primera mitad de la señal
%      - MAV de la segunda mitad de la señal
%      - ZC de la señal (usando un umbral de 0.05)
%  Deberá guardar las características en tres matrices, una para cada clase. Cada fila
%  representará el vector de características de una señal. Llame a las matrices así:
%  carac_emg_1, carac_emg_2, carac_emg_3


mav1 = zeros(K(1)/2, 1);
mav2 = zeros(K(1)/2, 1);
zc1 = zeros(K(1), 1);
for turno = 1:(K(1))
    if turno <= ((K(1)/2))
        mav1(turno) = mean(abs(EMG_c1(turno, :)));
    else
        mav2(turno - (K(1)/2)) = mean(abs(EMG_c1(turno, :)));
    end    
    zc1(turno) = ZC_v2(EMG_c1(turno, :), 0.05);  
end
carac_emg_1 = [mav2,mav1,zc1(1:(K(1)/2))]; % Está como vector fila

for turno = 1:(K(1))
    if turno <= ((K(1)/2))
        mav1(turno) = mean(abs(EMG_c2(turno, :)));
    else
        mav2(turno - (K(1)/2)) = mean(abs(EMG_c2(turno, :)));
    end    
    zc1(turno) = ZC_v2(EMG_c2(turno, :), 0.05);  
end
carac_emg_2 = [mav1, mav2, zc1(1:(K(1)/2))]; % Está como vector fila

for turno = 1:(K(1))
    if turno <= ((K(1)/2))
        mav1(turno) = mean(abs(EMG_c3(turno, :)));
    else
        mav2(turno - (K(1)/2)) = mean(abs(EMG_c3(turno, :)));
    end    
    zc1(turno) = ZC_v2(EMG_c3(turno, :), 0.05);  
end
carac_emg_3 = [mav1, mav2, zc1(1:(K(1)/2))]; % Está como vector fila

%% 1.4 Graficar los vectores de características - Figura en el reporte
%  En la Figura 2 debe graficar los vectores de características obtenidos anteriormente.
%  Use scatter3. Use un color distinto para cada clase (los mismos colores que usó en la
%  Figura 1). Etiquete los ejes, incluya una leyenda y coloque un título a la figura.

s1 = 5*ones(K(1)/2,1);
s2 = 20*ones(K(1)/2,1);
s3 = 35*ones(K(1)/2,1);
c1 = [0.1, 0.5, 0.1];
c2 = [0.5, 0.0, 0.1];
c3 = [0.2, 0.5, 0.5];

figure(2)
    hold on
    scatter3(carac_emg_1(:,1), carac_emg_1(:,2), carac_emg_1(:,3),s1,c1);
    scatter3(carac_emg_2(:,1), carac_emg_2(:,2), carac_emg_2(:,3),s2,c2);
    scatter3(carac_emg_3(:,1), carac_emg_3(:,2), carac_emg_3(:,3),s3,c3);
    grid on
    title('Muestras segun sus caracteristicas')
    xlabel('CARACTERISTICA 1')
    ylabel('CARACTERISTICA 2')
    zlabel('CARACTERISTICA 3')
    legend([{'First'},{'Second'},{'Third'}])
    hold off


%% 1.5 Entrenar y usar un clasificador - Matriz(matrices) y porcentaje(s) en el reporte
%  Deberá entrenar algún clasificador usando el 80% de las señales (usando sus
%  correspondientes vectores de características). 
%  Luego, deberá clasificar el restante 20% de las señales. Genere una matriz de confusión
%  y calcule el porcentaje de clasificación correcta.
%  Nota: si quiere usar una red neuronal, puede usar el "Neural Network Pattern
%        Recognition" app. En ese caso, no es necesario que incluya código para el
%        entrenamiento y la clasificación en sí. Tampoco para generar las matrices de
%        confusión. Lo puede hacer todo dentro del app. Sin embargo, sí debe incluir
%        código para preparar las muestras y los targets.
%        Si usa el app, puede dejar 10% para validación y 10% para evaluación (con 80%
%        para entrenamiento).

%p1 = randperm(size(carac_emg_1,1),0.80*size(carac_emg_1,1));%posiciones alazar 80%
%p2 = setdiff(1:size(carac_emg_1,1), p1);      % 20% sobrante

X_ann_1 = [carac_emg_1;carac_emg_2;carac_emg_3]';
T_ann_1 =[ones(size(carac_emg_1,1),1),zeros(size(carac_emg_1,1),1),zeros(size(carac_emg_1,1),1);...
          zeros(size(carac_emg_1,1),1),ones(size(carac_emg_1,1),1),zeros(size(carac_emg_1,1),1);...
          zeros(size(carac_emg_1,1),1),zeros(size(carac_emg_1,1),1),ones(size(carac_emg_1,1),1)]';

net = patternnet(10,'trainscg');
% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 80/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 10/100;

net = train(net,X_ann_1,T_ann_1);

y = net(X_ann_1);
perf = perform(net,T_ann_1,y);
classes = vec2ind(y);

%view(net)
%Para clasificar otros usar vec2ind(net(a')) donde "a" es el vector de
%caracteristicas en forma horizontal [0.14	0.17 55]



%% 2.1 Cargar datos EEG, segmentarlos y organizarlos en matrices
%  Cargue los datos contenidos en datos_bioelec.mat.
%  En esta segunda parte usarán las variables EEG_sano y EEG_ictal, que se encuentran en
%  el archivo datos_bioelec.mat. Dichas variables contienen registros de un paciente sano
%  (sin convulsiones epilépticas) y de un paciente en estado ictal (convulsión
%  epiléptica), respectivamente. También usarán Fs_eeg.

%  Los registros duran varios minutos. Para cada clase, deberá segmentar los registros en
%  señales de 10 segundos. Deberá guardar las señales en matrices similares a la EMG_c1,
%  es decir, las señales deben quedar como vectores fila. Llame a las matrices así:
%  EEG_sano_seg y EEG_ictal_seg.
%  Nota: El último segmento de cada conjunto tendrá algunas muestras menos que las demás.
%        Utilice "zero padding" para completar esas últimas señales.

%load('datos_bioelec.mat')  %ya cargados al inicio

N_tot_sano = size(EEG_sano, 2);     % Número de muestras totales sano
N_tot_ictal = size(EEG_ictal, 2);   % Número de muestras totales ictal

K4 = ceil(N_tot_sano/(Fs_eeg*10));% Se usa ceil porque la división puede no 
K5 = ceil(N_tot_ictal/(Fs_eeg*10));% dar un entero.
N_por_10_seg = floor(Fs_eeg*10);%Se usa floor para garantizar que sea entero

if (K4*N_por_10_seg) ~= N_tot_sano
    dif = abs((N_tot_sano-(K4*N_por_10_seg))-N_por_10_seg);
    EEG_sano = [EEG_sano, zeros(1,dif)];
end
if (K5*N_por_10_seg) ~= N_tot_ictal
    dif = abs((N_tot_ictal-(K5*N_por_10_seg))-N_por_10_seg);
    EEG_ictal = [EEG_ictal, zeros(1,dif)];
end
N_tot_sano = size(EEG_sano, 2);     % Número de muestras totales sano
N_tot_ictal = size(EEG_ictal, 2);   % Número de muestras totales ictal

K4 = ceil(N_tot_sano/(Fs_eeg*10));% Se usa ceil porque la división puede no 
K5 = ceil(N_tot_ictal/(Fs_eeg*10));% dar un entero.
N_por_10_seg = floor(Fs_eeg*10);%Se usa floor para garantizar que sea entero

EEG_sano_seg = zeros(K4, N_por_10_seg);
EEG_ictal_seg = zeros(K5, N_por_10_seg);

%----------------------- matriz de segmentos ------------------------------

for turno = 1:(K4)
    EEG_sano_seg(turno,:) = EEG_sano((N_por_10_seg*(turno-1)+1):min([N_por_10_seg*turno, N_tot_sano]));
end
EEG_sano_seg = EEG_sano_seg - mean(EEG_sano_seg);

for turno = 1:(K5)
    EEG_ictal_seg(turno,:) = EEG_ictal((N_por_10_seg*(turno-1)+1):min([N_por_10_seg*turno, N_tot_ictal]));
end
EEG_ictal_seg = EEG_ictal_seg - mean(EEG_ictal_seg);


%% 2.2 Filtrado de las señales EEG
%  Se requiere filtrar cada señal EEG. Deberá diseñar dos filtros: uno pasa bajas de
%  segundo orden y frecuencia de corte de 45 Hz, y uno pasa altas de segundo orden y
%  frecuencia de corte de 0.5 Hz. Use funciones aprendidas en el curso de Procesamiento de
%  Señales (ej. butter).
%  Nota 1: por el filtro pasa altas, ya no es necesario centrar la señal.
%  Nota 2: también se podría diseñar un filtro pasa bandas de orden cuatro.

%  Aplique los filtros a cada una de las señales. Recuerde aplicar los filtros en cascada,
%  es decir, al resultado de aplicar el primer filtro le debe aplicar el segundo filtro.
%  Las señales filtradas deben quedar guardadas en matrices llamadas EEG_sano_filt y
%  EEG_ictal_filt (siempre como vectores fila).

Wc_low = 45/Fs_eeg;             %FrecuenciaCorte / FrecuenciaMuestreo
Wc_high = 0.5/Fs_eeg;

% [nume , deno] = butter(orden, corte, tipoFiltro)
  [b_low, a_low] = butter(2,Wc_low,'low');
[b_high, a_high] = butter(2,Wc_high,'high');

%SenialFiltrada = filter(nume, deno, senial)
EEG_sano_filt = filter(b_high, a_high, EEG_sano_seg);
EEG_sano_filt = filter(b_low, a_low, EEG_sano_filt);
EEG_ictal_filt = filter(b_high, a_high, EEG_ictal_seg);
EEG_ictal_filt = filter(b_low, a_low, EEG_ictal_filt);
% figure
% hi = sgtitle('Señales EMG ');
% hi.FontSize = 18;
% hi.Color = 'r';
% hi.FontName = 'verdana';
%     subplot(2,1,1);
%         plot(EEG_ictal_seg(1,:));
%         hold on
%         plot(EEG_ictal_filt(1,:));
%         hold off
%         title('Señales ictal')
%         legend([{'Medida'},{'filtrada'}])
%     subplot(2,1,2);
%         plot(EEG_sano_seg(1,:));
%         hold on
%         plot(EEG_sano_filt(1,:));
%         hold off
%         title('Señales sano')
%         legend([{'Medida'},{'filtrada'}])
    
%% 2.3 Gráficas en tiempo y espectro de amplitud unilateral - Figuras en el reporte
%  Deberá seleccionar una señal filtrada al azar de cada clase. Para cada una deberá
%  obtener el espectro de amplitud unilateral.
%  En la Figura 3 deberá tener dos subfiguras. En la superior graficará la señal de la
%  clase sano versus tiempo, en segundos (empezando en t = 0). En la inferior graficará el
%  espectro correspondiente versus frecuencia, en Hz.
%  En la Figura 4 graficará la señal de la clase ictal versus tiempo, en segundos, en la
%  subfigura superior, y el correspondiente espectro versus frecuencia, en Hz, en la
%  subfigura inferior.

N_seg = N_por_10_seg;
t_seg = (0:(N_seg-1))/Fs_eeg;


k = randi(K4);  % Entero al azar entre 1 y K
SEG_SANO = fft(EEG_sano_filt(k,:));
P1_sano = abs(SEG_SANO/N_seg);
P1_sano = P1_sano(1:N_seg/2+1); P1_sano(2:end-1) = 2*P1_sano(2:end-1);
funi_sano = Fs_eeg*(0:(N_seg/2))/N_seg;

figure(3); clf;
    subplot(2, 1, 1);
        plot(t_seg, EEG_sano_filt(k,:));
        xlim([t_seg(1), t_seg(end)]);
        xlabel('t (s)');
        ylabel('mV');
        grid on;
        title('Segmento EEG SANO (centrado, filtrado)');
    subplot(2,1,2);
        stem(funi_sano, P1_sano);
        xlim([funi_sano(1), funi_sano(end)]);
        xlabel('f (Hz)');
        title('Espectro de Amplitud Unilateral de señal seleccionada');
        

k = randi(K5);  % Entero al azar entre 1 y K
SEG_ICTAL = fft(EEG_ictal_filt(k,:));
P1_ictal = abs(SEG_ICTAL/N_seg);
P1_ictal = P1_ictal(1:N_seg/2+1); P1_ictal(2:end-1) = 2*P1_ictal(2:end-1);
funi_ictal = Fs_eeg*(0:(N_seg/2))/N_seg;

figure(4); clf;
    subplot(2, 1, 1);
        plot(t_seg, EEG_ictal_filt(k,:));
        xlim([t_seg(1), t_seg(end)]);
        xlabel('t (s)');
        ylabel('mV');
        grid on;
        title('Segmento EEG ICTAL (centrado, filtrado)');
    subplot(2,1,2);
        stem(funi_ictal, P1_ictal);
        xlim([funi_ictal(1), funi_ictal(end)]);
        xlabel('f (Hz)');
        title('Espectro de Amplitud Unilateral de señal seleccionada');

%--------------------------------------------------------------------------
% Subfigura1 una señal alazar, Subfigura2 Funilateral de todas las seniales
%--------------------------------------------------------------------------
% SEG_SANO = fft(EEG_sano_filt);
% P1_sano = abs(SEG_SANO/N_seg);
% P1_sano = P1_sano(1:N_seg/2+1); P1_sano(2:end-1) = 2*P1_sano(2:end-1);
% funi_sano = Fs_eeg*(0:(N_seg/2))/N_seg;
% 
% figure(3); clf;
%     subplot(2, 1, 1);
%         plot(t_seg, EEG_sano_filt(k,:));
%         xlim([t_seg(1), t_seg(end)]);
%         xlabel('t (s)');
%         ylabel('mV');
%         grid on;
%         title('Segmento EEG (centrado, filtrado)');
%     subplot(2,1,2);
%         stem(funi_sano, P1_sano);
%         xlim([funi_sano(1), funi_sano(end)]);
%         xlabel('f (Hz)');
%         title('Espectro de Amplitud Unilateral');
%% 2.4 Obtener características en dominio de la frecuencia
%  Acá deberá obtener 2 características para cada señal filtrada, de cada clase:
%      - Razón θ/β
%      - Razón β/α
%  Deberá guardar las características en dos matrices, una para cada clase. Cada fila
%  representará el vector de características de una señal. Llame a las matrices así:
%  carac_eeg_1, carac_eeg_2

Theta = zeros(1,K4);
Beta = zeros(1,K4);
Alpha = zeros(1,K4);
razon_1 = zeros(1,K4);
razon_2 = zeros(1,K4);

for turno = 1:K4
    Theta(turno) = bandpower(EEG_sano_filt(turno,:), Fs_eeg, [4 8]);  % theta (θ, 4–8 Hz)
    Beta(turno) = bandpower(EEG_sano_filt(turno,:), Fs_eeg, [12 30]); % beta (β, 12–30 Hz)
    Alpha(turno) = bandpower(EEG_sano_filt(turno,:), Fs_eeg, [8 12]); % alpha (α, 8–12 Hz)

    razon_1(turno) = Theta(turno)/Beta(turno);
    razon_2(turno) = Beta(turno)/Alpha(turno);
end   
carac_eeg_1 = [razon_1', razon_2']; % Está como vector columna

for turno = 1:K5
    Theta(turno) = bandpower(EEG_ictal_filt(turno,:), Fs_eeg, [4 8]);  % theta (θ, 4–8 Hz)
    Beta(turno) = bandpower(EEG_ictal_filt(turno,:), Fs_eeg, [12 30]); % beta (β, 12–30 Hz)
    Alpha(turno) = bandpower(EEG_ictal_filt(turno,:), Fs_eeg, [8 12]); % alpha (α, 8–12 Hz)

    razon_1(turno) = Theta(turno)/Beta(turno);
    razon_2(turno) = Beta(turno)/Alpha(turno);
end   
carac_eeg_2 = [razon_1', razon_2']; % Está como vector columna


%% 2.5 Graficar los vectores de características - Figura en el reporte
%  En la Figura 5 debe graficar los vectores de características obtenidos anteriormente.
%  Use scatter. Use un color distinto para cada clase. Etiquete los ejes, incluya una
%  leyenda y coloque un título a la figura. 

figure(5); clf;
hold on;
scatter(carac_eeg_1(:,1), carac_eeg_1(:,2));  % Equivalente: scatter(vec_car(1, 1), vec_car(1, 2));
scatter(carac_eeg_2(:,1), carac_eeg_2(:,2));  % Equivalente: scatter(vec_car(1, 1), vec_car(1, 2));
xlabel('θ/β');
ylabel('β/α');
grid on;
hold off;
legend([{'caracteristica eeg 1 sano'},{'caracteristica eeg 2 ictal'}])
title('Vector de características, EEG');



%% 2.6 Entrenar y usar un clasificador - Matriz y porcentaje en el reporte
%  Deberá entrenar algún clasificador usando el 70% de las señales (usando sus
%  correspondientes vectores de características). 
%  Luego, deberá clasificar el restante 30% de las señales. Genere una matriz de confusión
%  y calcule el porcentaje de clasificación correcta.
%  Nota: si usó una red neuronal en el inciso 1.5, pruebe usar una SVM en este inciso.
%        Deberá incluir código para el entrenamiento y la clasificación. Incluya también
%        código para obtener la matriz de confusión y el porcentaje de clasificación
%        correcta.
%--------------------------------------------------------------------------
%       Segementacion de datos para entrenar SVM
%--------------------------------------------------------------------------
%posiciones alazar 70% (aprox)
entrena1 = randperm(size(carac_eeg_1,1),ceil(0.70*size(carac_eeg_1,1)));
% 30% sobrante(aprox)
valida1 = setdiff(1:size(carac_eeg_1,1), entrena1);      

%posiciones alazar 70%(aprox)
entrena2 = randperm(size(carac_eeg_2,1),ceil(0.70*size(carac_eeg_2,1)));
% 30% sobrante(aprox)
valida2 = setdiff(1:size(carac_eeg_2,1), entrena2);      

Y1 = ones(ceil(0.70*size(carac_eeg_1,1)),1);
Y2 = -1*ones(ceil(0.70*size(carac_eeg_2,1)),1);
Y_train = [Y1;Y2];  %etiquetas para entrenamiento
Y1 = ones(size(valida1,2),1);
Y2 = -1*ones(size(valida2,2),1);
Y_test = [Y1;Y2];   %etiquetas para prueba

X1 = zeros(size(entrena1,2),2);
X2 = zeros(size(entrena2,2),2);

for pos = 1:1:size(entrena1,2)
    X1(pos,:) = carac_eeg_1(entrena1(pos),:);
end
for pos = 1:1:size(entrena2,2)
    X2(pos,:) = carac_eeg_2(entrena2(pos),:);
end
X_train = [X1;X2];

X1 = zeros(size(valida1,2),2);
X2 = zeros(size(valida2,2),2);

for pos = 1:1:size(valida1,2)
    X1(pos,:) = carac_eeg_1(valida1(pos),:);
end
for pos = 1:1:size(valida2,2)
    X2(pos,:) = carac_eeg_2(valida2(pos),:);
end
X_test = [X1;X2];


% figure;
% gscatter(X_test(:,1), X_test(:,2), Y_test);  % scatter por grupos
% legend({'Clase 2', 'Clase 1'}, 'Location', 'Best');
% grid on;
% title('Datos de entrenamiento')

%--------------------------------------------------------------------------
%       Crear celdas y vectores para guardar modelos y otras cosas
%--------------------------------------------------------------------------
M = 3;
ModeloSVM = cell(1, M);
ModeloVC = cell(1, M);
errorVC = zeros(1, M);
asignado = cell(1, M);
valores = cell(1, M);
titulos ={'Kernel Lineal','Kernel Polinomial Grado 4','Kernel Gaussiano'};
%--------------------------------------------------------------------------
%       Entrenamiento, variando Kernels y ciertos parámetros
%--------------------------------------------------------------------------
ModeloSVM{1} = fitcsvm(X_train,Y_train,'KernelFunction','linear','KernelScale','auto');
ModeloSVM{2} = fitcsvm(X_train,Y_train,'KernelFunction','polynomial','KernelScale','auto','PolynomialOrder',2);
ModeloSVM{3} = fitcsvm(X_train,Y_train,'KernelFunction','rbf','KernelScale','auto','Standardize',true);

% Se hace validación cruzada con las muestras de entrenamiento, se calcula el error
% de clasificación de la validación cruzada, se clasifican las muestras de prueba,
% y se grafican resultados. Todo lo anterior para los 6 modelos de arriba.
for k = 1:3
    % Validación cruzada, clasificación errónea
    ModeloVC{k} = crossval(ModeloSVM{k});
    errorVC(k) = kfoldLoss(ModeloVC{k});
    
    % Clasificación de las muestras de prueba
    [asignado{k}, valores{k}] = predict(ModeloSVM{k}, X_test); 
                                    % etiquetas asignadas, valores
    
    % Gráficas
    figure(k+5); clf;
    subplot(1,3,1);
    gscatter(X_train(:,1), X_train(:,2), Y_train); hold on;
    % Vectores de soporte
    plot(X_train(ModeloSVM{k}.IsSupportVector, 1), X_train(ModeloSVM{k}.IsSupportVector, 2),...
         'ko', 'MarkerSize', 10);
    % Frontera de decisión
    %contour(x1Grid, x2Grid, reshape(valores{k}(:,2), size(x1Grid)), [0 0], 'k');
    grid on;
    title('M. de Entrenamiento y Frontera de Decisión')
    legend({'Clase 2', 'Clase 1', 'V. de soporte'}, 'Location', 'Best');
    
    subplot(1,3,2);
    gscatter(X_test(:,1),X_test(:,2),asignado{k});
    legend({'Clase 2', 'Clase 1'}, 'Location', 'Best');
    grid on;
    title('Muestras de Prueba');
    sgtitle(sprintf('%s.    Error Val. Cruzada: %.2f%%', titulos{k}, 100*errorVC(k)));
    
    subplot(1,3,3);
    cm = confusionchart(Y_train, ModeloVC{k}.kfoldPredict);
    cm.Title = sprintf('Matriz confusion');
end


