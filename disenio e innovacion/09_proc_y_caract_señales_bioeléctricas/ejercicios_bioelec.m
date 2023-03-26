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




%% 1.2 Graficar una señal al azar de cada clase - Figura en el reporte
%  En la Figura 1 deberá graficar una señal al azar de la clase 1, una señal al azar de la
%  clase 2, y una señal al azar de la clase 3. Grafique versus tiempo, en segundos
%  (empezando en t = 0). Use colores distintos para cada gráfica. Identifique los ejes e
%  incluya una leyenda.




%% 1.3 Obtener características en dominio del tiempo
%  Acá deberá obtener 3 características para cada señal, de cada clase:
%      - MAV de la primera mitad de la señal
%      - MAV de la segunda mitad de la señal
%      - ZC de la señal (usando un umbral de 0.05)
%  Deberá guardar las características en tres matrices, una para cada clase. Cada fila
%  representará el vector de características de una señal. Llame a las matrices así:
%  carac_emg_1, carac_emg_2, carac_emg_3




%% 1.4 Graficar los vectores de características - Figura en el reporte
%  En la Figura 2 debe graficar los vectores de características obtenidos anteriormente.
%  Use scatter3. Use un color distinto para cada clase (los mismos colores que usó en la
%  Figura 1). Etiquete los ejes, incluya una leyenda y coloque un título a la figura.




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




%% 2.3 Gráficas en tiempo y espectro de amplitud unilateral - Figuras en el reporte
%  Deberá seleccionar una señal filtrada al azar de cada clase. Para cada una deberá
%  obtener el espectro de amplitud unilateral.
%  En la Figura 3 deberá tener dos subfiguras. En la superior graficará la señal de la
%  clase sano versus tiempo, en segundos (empezando en t = 0). En la inferior graficará el
%  espectro correspondiente versus frecuencia, en Hz.
%  En la Figura 4 graficará la señal de la clase ictal versus tiempo, en segundos, en la
%  subfigura superior, y el correspondiente espectro versus frecuencia, en Hz, en la
%  subfigura inferior.




%% 2.4 Obtener características en dominio de la frecuencia
%  Acá deberá obtener 2 características para cada señal filtrada, de cada clase:
%      - Razón θ/β
%      - Razón β/α
%  Deberá guardar las características en dos matrices, una para cada clase. Cada fila
%  representará el vector de características de una señal. Llame a las matrices así:
%  carac_eeg_1, carac_eeg_2




%% 2.5 Graficar los vectores de características - Figura en el reporte
%  En la Figura 5 debe graficar los vectores de características obtenidos anteriormente.
%  Use scatter. Use un color distinto para cada clase. Etiquete los ejes, incluya una
%  leyenda y coloque un título a la figura. 




%% 2.6 Entrenar y usar un clasificador - Matriz y porcentaje en el reporte
%  Deberá entrenar algún clasificador usando el 70% de las señales (usando sus
%  correspondientes vectores de características). 
%  Luego, deberá clasificar el restante 30% de las señales. Genere una matriz de confusión
%  y calcule el porcentaje de clasificación correcta.
%  Nota: si usó una red neuronal en el inciso 1.5, pruebe usar una SVM en este inciso.
%        Deberá incluir código para el entrenamiento y la clasificación. Incluya también
%        código para obtener la matriz de confusión y el porcentaje de clasificación
%        correcta.

