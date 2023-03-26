%% IE3038 - Diseño e Innovación en Ingeniería 1
%  Ejercicios de Aprendizaje Supervisado
%  Nombre: Cristhofer Isaac Patzan Martinez
%  Carné: 19218
%  Sección: 20

%  ESCRIBA EL CÓDIGO CORRESPONDIENTE EN LOS ESPACIOS DEBAJO DE LAS INSTRUCCIONES EN CADA
%  UNA DE LAS 6 SECCIONES. ANTES DE ENTREGAR SU SCRIPT, ASEGÚRESE DE QUE CORRA SIN
%  ERRORES. AL CALIFICAR, SE CORRERÁ EL SCRIPT PARA VER SI SE GENERAN LOS RESULTADOS Y
%  GRÁFICAS SOLICITADAS. PUEDE ASUMIR QUE EL .mat ESTÁ DISPONIBLE EN EL "Current Folder".
clear;clc;
%% (1) Graficar los datos X1 y X2
%  Cargue las variables X1 y X2 que están en el archivo ejercicios_apr_sup.mat
load('ejercicios_apr_sup.mat')

%  Las muestras en X1 corresponden a datos de una clase, y las muestras en X2 corresponden
%  a otra clase. Las muestras son vectores fila (estos serían los "feature vectors").
%  Notar que cada columna corresponde a una característica (feature).
%  En la figura 1, grafique las muestras usando scatter3. Use colores distintos para cada
%  clase. Active el grid, etiquete los ejes, coloque una leyenda y un título en la figura.
%  Deberá incluir la imagen en su reporte.
N1 = size(X1, 1);
N2 = size(X2, 1);

%s = [5*ones(N1,1); 20*ones(N2,1)];
%c = [ones(N1,1); 2*ones(N2,1)];
s1 = 5*ones(N1,1);
s2 = 20*ones(N2,1);
c1 = ones(N1,1);
c2 = 2*ones(N2,1);

figure(1)
%scatter3(X_train(:,1), X_train(:,2), X_train(:,3),s,c); %(feature1,feature2, feature3, size, color)
%legend
hold on
scatter3(X1(:,1), X1(:,2), X1(:,3),s1,c1);
scatter3(X2(:,1), X2(:,2), X2(:,3),s2,c2);
grid on
title('Muestras segun sus caracteristicas')
xlabel('CARACTERISTICA 1')
ylabel('CARACTERISTICA 2')
zlabel('CARACTERISTICA 3')
legend([{'First'},{'Second'}])
hold off




%% (2) Separar los datos X1 y X2 en conjuntos de entrenamiento y prueba; entrenar las SVM
%  80% de las muestras en X1 y en X2 se usarán para entrenar clasificadores SVM. El 20%
%  restante se usará para evaluar.
%  Las muestras de entrenamiento se deben seleccionar aleatoriamente. Coloque dichas
%  muestras en una variable llamada X_train. Note que en esa variable deben estar muestras
%  tanto de X1 como de X2. Coloque las muestras restantes en una variable llamada X_test.
%  Allí deben estar las muestras de X1 y X2 que no quedaron en X_train.
%  Importante: ningún dato que esté en X_train debe estar en X_test, y vice-versa.
%  También debe crear variables que contengan a las etiquetas. Las etiquetas de las
%  muestras de entrenamiento deben estar en una variable llamada Y_train. Y las etiquetas
%  de las muestras de evaluación deben estar en una variable llamada Y_test.

%  Use X_train y Y_train para entrenar dos clasificadores SVM. Use la función fitcsvm. El
%  primer clasificador deberá usar una 'KernelFunction' polinomial. Pruebe algunos órdenes
%  y deje el que mejor rendimiento le dé (más adelante se explica cómo verificar el
%  rendimiento). El segundo SVM deberá usar una 'KernelFunction' gaussiana (rbf).

%  Nota: No necesita usar variables tipo celda. Los modelos (resultados de fitcsvm) pueden
%        ser variables independientes. Si quiere usar una celda, lo puede hacer, por
%        supuesto.

%  Ayuda: para obtener las muestras de forma aleatoria, investigue la función randperm.
%         Con ella puede generar vectores de enteros de 1 a N en un orden aleatorio, que
%         puede usar como índices. N sería el número de muestras en este caso. Puede
%         generar un vector de índices aleatorios para X1 y otro para X2. Con ellos puede
%         generar variables que serían subconjuntos de X1 y X2, para luego armar las
%         variable X_train y X_test.
%         Para las etiquetas, revise lo hecho en el script ej_svm2.m.

X_all = [X1; X2];  % Todas las muestras de entrenamiento
p1 = randperm(size(X_all,1),0.80*size(X_all,1));    %posiciones alazar 80%
p2 = setdiff(1:size(X_all,1), p1);      % 20% sobrante

X_train = zeros(size(p1,2),size(X1,2));     %Matriz de entreno
Y_train = zeros(size(p1,2),1);
%Lleno la matriz de entreno con las posiciones aleatorias al 80 porciento
%En el caso de  las etiquetas por el orden en el que se coloco X_all se
%apartir en que punto es distinto
for i = 1:1:(0.80*size(X_all,1))
    X_train(i,:) = X_all(p1(i),:);
    if p1(i) > N1
        Y_train(i) = 1;
    else
        Y_train(i) = -1;
    end
end

X_test = zeros(size(p2,2),size(X1,2));     %Matriz de prueba
Y_test = zeros(size(p2,2),1);
%Lleno la matriz de prueba con las posiciones aleatorias al 20 porciento
for i = 1:1:(0.20*size(X_all,1))
    X_test(i,:) = X_all(p2(i),:);
    if p2(i) > N1
        Y_test(i) = 1;
    else
        Y_test(i) = -1;
    end
end

% Verifico si se repiten los números
if isempty(intersect(p1, p2))
    disp('p1 y p2 no tienen los mismos numeros')
else
    disp('p1 y p2 tienen los mismosnumeros')
end

%% Crear celdas y vectores para guardar modelos y otras cosas
M = 2;
ModeloSVM = cell(1, M);
ModeloVC = cell(1, M);
errorVC = zeros(1, M);
asignado = cell(1, M);
valores = cell(1, M);
titulos = {'Kernel Polinomial Grado 3','Kernel Gaussiano'};

ModeloSVM{1} = fitcsvm(X_train, Y_train, 'KernelFunction', 'polynomial','KernelScale', 'auto', 'PolynomialOrder', 3);
ModeloSVM{2} = fitcsvm(X_train, Y_train, 'KernelFunction', 'rbf', 'KernelScale', 'auto');

%% (3) Clasificar los datos de prueba y generar matriz de confusión, clasificadores SVM
%  Use los modelos entrenados anteriormente y la función predict para clasificar las
%  muestras en X_test. Note que la función predict devuelve las etiquetas asignadas por el
%  clasificador. Con dichas etiquetas (clase asignada) y las etiquetas en Y_test (clase
%  real), deberá generar matrices de confusión y porcentajes de clasificación correcta.


% Se hace validación cruzada con las muestras de entrenamiento, se calcula el error
% de clasificación de la validación cruzada, se clasifican las muestras de prueba
for k = 1:M
    % Validación cruzada, clasificación errónea
    ModeloVC{k} = crossval(ModeloSVM{k});
    errorVC(k) = kfoldLoss(ModeloVC{k});
    
    % Clasificación de las muestras de prueba
    [asignado{k}, valores{k}] = predict(ModeloSVM{k}, X_test); % etiquetas asignadas, valores
end

figure(2)
hi = sgtitle('Matrices de confusion');
hi.FontSize = 18;
hi.Color = 'r';
hi.FontName = 'verdana';
subplot(1,2,1);
cm1 = confusionchart(Y_test, asignado{1});
cm1.Title = sprintf('Modelo poinomial grado ');
subplot(1,2,2);
cm2 = confusionchart(Y_test, asignado{2});
cm2.Title = sprintf('Modelo Gausiano');


%  Nota: a diferencia de lo hecho en los ejemplos de clase, no necesita generar gráficas
%        con los vectores de soporte y las fronteras de decisión. Eso es fácil para
%        muestras en 2D, pero se complica más en 3D. Tampoco necesita definir todas las
%        variables que se definieron en los ejemplos de clase (ModeloVC, errorVC,
%        valores). Sólo necesita variables para los resultados de la clasificación
%        (etiquetas asignadas).

%  Puede generar las matrices "a mano", es decir, sin usar funciones de Matlab específicas
%  para matrices de confusión. Se compara elemento por elemento de las etiquetas asignadas
%  y las reales. Si la etiqueta real era de la clase 1, y la etiqueta asignada es la de la
%  clase 1, se aumenta un contador para la posición (1,1) de la matriz. Si la etiqueta
%  real era de la clase 2, y la etiqueta asignada es de la clase 2, se aumenta un contador
%  para la posición (2,2) de la matriz. En caso de no haber coincidencia entre la clase
%  asignada y la real, se aumentan contadores para las posiciones (1,2) o (2,1) de la
%  matriz, según sea el caso. Lo anterior se puede hacer con ciclos o con comparaciones,
%  indexados lógicos y operaciones entre matrices.
%  Alternativamente, puede investigar y usar funciones de Matlab para generar y graficar
%  las matrices de confusión. 
%  No es obligación, pero un buen ejercicio sería generar las matrices de ambas formas,
%  para comprobar sus resultados y verificar que ha entendido bien cómo se generan.
%  Los porcentajes de clasificación correcta se calculan dividiendo la suma de los
%  elementos de la diagonal de la matriz (los elementos correctamente clasificados) entre
%  el total de los elementos de la matriz (todos los elementos que se clasificaron).

%  En el reporte deberá incluir los porcentajes de clasificación correcta e imágenes con
%  las matrices de confusión de ambos clasificadores (el SVM con el Kernel polinomial que
%  más alto porcentaje de clasificación haya dado, y el SVM con el Kernel Gaussiano). Las
%  imágenes pueden ser tablas generadas en Word o Excel, o figuras generadas con una
%  función de Matlab. Si usted genera las tablas, asegúrese de identificar las filas y
%  columnas (clase real/clase asignada). Si genera figuras con funciones de Matlab,
%  agrégueles títulos a las figuras (el Kernel usado). En caso de usar las funciones de
%  Matlab, use las figuras 2 y 3.




%% (4) Organizar muestras X1 y X2, crear etiquetas y entrenar una red neuronal
%  En esta sección deberá colocar todas las muestras de X1 y X2 en una sola variable,
%  llamada X_ann_1. Además, deberá crear una variable llamada T_ann_1 con los "targets",
%  los cuales servirán para identificar la clase de las muestras.
%  Ayuda: revise el archivo ej_ann.m. Allí se explica cómo deben quedar los "targets" para
%         cada muestra, según la clase a la que pertenece (columnas o filas con unos y
%         ceros). Ese script tiene código generado por el app. Se observan los comandos
%         que permiten entrenar redes y clasificar muestras sin la necesidad de la
%         interfaz gráfica, lo cual es conveniente muchas veces.

%  Teniendo las variables X_ann_1 y T_ann_1, deberá usar el "Neural Network Pattern
%  Recognition" app de Matlab para entrenar una red neuronal y obtener las matrices de
%  confusión como en los ejemplos de la clase. Puede dejar el tamaño de la red y los
%  porcentajes de entrenamiento, validación y prueba por defecto. También puede cambiar
%  esos parámetros, para ver qué pasa.
%  Ayuda: Note que el app permite seleccionar si las muestras (predictors) y los targets
%         (responses) están como columnas o como filas. Tenga cuidado de armar la variable
%         T_ann_1 de forma consistente con la variable X_ann_1.

%  En el reporte deberá incluir una imagen donde se muestre la red ya entrenada, y otra
%  imagen que muestre las matrices de confusión resultantes. 

% Como columnas deben estar las muestras y filas sus caracteristicas
% En el caso de etiquetas en columna indican el tipo de muestra (1 si es 
% esa muestra y 0 para todas aquellas que no lo sea) y en fila
% la cantidad total de tipos
X_ann_1 = X_all';
T_ann_1 = [ones(size(X1, 1),1),zeros(size(X1, 1),1);zeros(size(X2, 1),1),ones(size(X2, 1),1)]';

net = patternnet(10,'trainscg');
% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

net = train(net,X_ann_1,T_ann_1);

y = net(X_ann_1);
perf = perform(net,T_ann_1,y);
classes = vec2ind(y);

view(net)
%% (5) Graficar los datos Xa, Xb y Xc
%  Cargue las variables Xa, Xb y Xc que están en el archivo ejercicios_apr_sup.mat
%  Cada variable contiene muestras de una clase distinta (los datos son vectores fila).
%  En la figura 4, grafique las muestras usando scatter3. Use colores distintos para cada
%  clase. Active el grid, etiquete los ejes, coloque una leyenda y un título en la figura.

%  Deberá incluir la imagen en su reporte.
Na = size(Xa, 1);
Nb = size(Xb, 1);
Nc = size(Xc, 1);

sa = 5*ones(Na,1);
sb = 20*ones(Nb,1);
sc = 40*ones(Nc,1);
ca = ones(Na,1);
cb = 2*ones(Nb,1);
cc = 3*ones(Nc,1);

figure(4)
hold on
scatter3(Xa(:,1), Xa(:,2), Xa(:,3),sa,ca);
scatter3(Xb(:,1), Xb(:,2), Xb(:,3),sb,cb);
scatter3(Xc(:,1), Xc(:,2), Xc(:,3),sc,cc);
grid on
title('Muestras segun sus caracteristicas')
xlabel('CARACTERISTICA 1')
ylabel('CARACTERISTICA 2')
zlabel('CARACTERISTICA 3')
legend([{'First'},{'Second'},{'THIRD'}])
hold off


%% (6) Organizar muestras Xa, Xb y Xc y crear etiquetas para una red neuronal
%  En esta sección deberá colocar todas las muestras de Xa, Xb y Xc en una sola variable,
%  llamada X_ann_2. Además, deberá crear una variable llamada T_ann_2 con los "targets",
%  los cuales servirán para identificar la clase de las muestras. Nuevamente tenga cuidado
%  de armar las variables X_ann_2 y T_ann_2 de forma consistente.
%  Teniendo las variables X_ann_2 y T_ann_2, deberá usar el "Neural Network Pattern
%  Recognition" app de Matlab para entrenar una red neuronal y obtener las matrices de
%  confusión como en el inciso (4).

%  En el reporte deberá incluir una imagen donde se muestre la red ya entrenada, y otra
%  imagen que muestre las matrices de confusión resultantes. 

X_ann_2 = [Xa; Xb; Xc]';
T_ann_2 = [ones(size(Xa, 1),1),zeros(size(Xa, 1),1), zeros(size(Xa, 1),1)...
          ;zeros(size(Xb, 1),1),ones(size(Xb, 1),1), zeros(size(Xb, 1),1)...
          ;zeros(size(Xc, 1),1),zeros(size(Xc, 1),1), ones(size(Xc, 1),1)...
          ]';
      
net1 = patternnet(10,'trainscg');
% Setup Division of Data for Training, Validation, Testing
net1.divideParam.trainRatio = 70/100;
net1.divideParam.valRatio = 15/100;
net1.divideParam.testRatio = 15/100;

net1 = train(net1,X_ann_2,T_ann_2);

y1 = net1(X_ann_2);
perf = perform(net1,T_ann_2,y1);
classes = vec2ind(y1);

view(net1)
