%% IE3038 - Diseño e Innovación en Ingeniería 1
%  Ejemplo de clasificación usando SVM (2)
%  Luis Alberto Rivera

%% Cargar datos, armar matriz con muestras de entrenamiento y las etiquetas, graficar
load ej_svm2_datos.mat
N1 = size(X1_train, 1);
N2 = size(X2_train, 1);
X_train = [X1_train; X2_train];  % Todas las muestras de entrenamiento
Y = [ones(N1,1); -1*ones(N2,1)]; % Etiquetas

figure(1); clf;
gscatter(X_train(:,1), X_train(:,2), Y);
legend({'Clase 2', 'Clase 1'}, 'Location', 'Best');
grid on;
title('Muestras de Entrenamiento');

%% Crear celdas y vectores para guardar modelos y otras cosas
M = 2;
ModeloSVM = cell(1, M);
ModeloVC = cell(1, M);
errorVC = zeros(1, M);
asignado = cell(1, M);
valores = cell(1, M);
titulos = {'Kernel Polinomial Grado 3','Kernel Gaussiano'};

ModeloSVM{1} = fitcsvm(X_train, Y, 'KernelFunction', 'polynomial',...
                       'KernelScale', 'auto', 'PolynomialOrder', 3);
ModeloSVM{2} = fitcsvm(X_train, Y, 'KernelFunction', 'rbf', 'KernelScale', 'auto');

% Se hace validación cruzada con las muestras de entrenamiento, se calcula el error
% de clasificación de la validación cruzada, se clasifican las muestras de prueba,
% y se grafican resultados. Todo lo anterior para los 6 modelos de arriba.
for k = 1:M
    % Validación cruzada, clasificación errónea
    ModeloVC{k} = crossval(ModeloSVM{k});
    errorVC(k) = kfoldLoss(ModeloVC{k});
    
    % Clasificación de las muestras de prueba
    [asignado{k}, valores{k}] = predict(ModeloSVM{k}, X_test); % etiquetas asignadas, valores
    
    % Gráficas
    figure(k+1); clf;
    subplot(1,2,1);
    gscatter(X_train(:,1), X_train(:,2), Y);
    hold on;
    % Vectores de soporte
    plot(X_train(ModeloSVM{k}.IsSupportVector, 1), X_train(ModeloSVM{k}.IsSupportVector, 2),...
        'ko', 'MarkerSize', 10);
    % Frontera de decisión
    contour(x1Grid, x2Grid, reshape(valores{k}(:,2), size(x1Grid)), [0 0], 'k');
    grid on;
    title('M. de Entrenamiento y Frontera de Decisión')
    legend({'Clase 2', 'Clase 1', 'V. de soporte'}, 'Location', 'Best');
    
    subplot(1,2,2);
    gscatter(X_test(:,1), X_test(:,2), asignado{k});
    legend({'Clase 2', 'Clase 1'}, 'Location', 'Best');
    grid on;
    title('Muestras de Prueba');
    sgtitle(sprintf('%s.    Error Val. Cruzada: %.2f%%', titulos{k}, 100*errorVC(k)));
end
