%% IE3038 - Diseño e Innovación en Ingeniería 1
%  Ejemplo de clasificación usando SVM (1)
%  Luis Alberto Rivera

%% Generación de muestras de entrenamiento, tomado de la documentación de Matlab
rng(1);  % con esto, cada vez se generan los mismos valores aleatorios
n = 100; % Número de muestras por cuadrante

r1 = sqrt(rand(2*n,1));                     % Radios aleatorios
t1 = [pi/2*rand(n,1); (pi/2*rand(n,1)+pi)]; % Ángulos aleatorios para cuadrantes 1 y 3
X1 = [r1.*cos(t1), r1.*sin(t1)];            % Conversión de polar a cartesiano

r2 = sqrt(rand(2*n,1));
t2 = [pi/2*rand(n,1)+pi/2; (pi/2*rand(n,1)-pi/2)]; % Ángulos aleatorios para cuadrantes 2 y 4
X2 = [r2.*cos(t2), r2.*sin(t2)];

X = [X1; X2];        % Predictores % Todas las muestras de entrenamiento
Y = ones(4*n, 1);    % Etiquetas
Y(2*n + 1:end) = -1; % Etiquetas  (una clase tendrá 1, otra clase tendrá -1)

figure(1); clf;
gscatter(X(:,1), X(:,2), Y);  % scatter por grupos
legend({'Clase 2', 'Clase 1'}, 'Location', 'Best');
grid on;
title('Datos de entrenamiento (simulados)')


%% Generación de muestras de prueba
delta = 0.02; % Step size of the grid
[x1Grid, x2Grid] = meshgrid(min(X(:,1)):delta:max(X(:,1)), min(X(:,2)):delta:max(X(:,2)));
xGrid = [x1Grid(:), x2Grid(:)]; % reorganiza las muestras como vectores fila


%% Crear celdas y vectores para guardar modelos y otras cosas
M = 3;
ModeloSVM = cell(1, M);
ModeloVC = cell(1, M);
errorVC = zeros(1, M);
asignado = cell(1, M);
valores = cell(1, M);
titulos = {'Kernel Lineal', 'Kernel Polinomial Grado 2', 'Kernel Gaussiano'};

%% Entrenamiento, variando Kernels y ciertos parámetros
ModeloSVM{1} = fitcsvm(X,Y,'KernelFunction','linear','KernelScale','auto');
ModeloSVM{2} = fitcsvm(X,Y,'KernelFunction','polynomial','KernelScale','auto','PolynomialOrder',2);
ModeloSVM{3} = fitcsvm(X,Y,'KernelFunction','rbf','KernelScale','auto','Standardize',true);

% Se hace validación cruzada con las muestras de entrenamiento, se calcula el error
% de clasificación de la validación cruzada, se clasifican las muestras de prueba,
% y se grafican resultados. Todo lo anterior para los 6 modelos de arriba.
for k = 1:3
    % Validación cruzada, clasificación errónea
    ModeloVC{k} = crossval(ModeloSVM{k});
    errorVC(k) = kfoldLoss(ModeloVC{k});
    
    % Clasificación de las muestras de prueba
    [asignado{k}, valores{k}] = predict(ModeloSVM{k}, xGrid); % etiquetas asignadas, valores
    
    % Gráficas
    figure(k+1); clf;
    subplot(1,3,1);
    gscatter(X(:,1), X(:,2), Y); hold on;
    % Vectores de soporte
    plot(X(ModeloSVM{k}.IsSupportVector, 1), X(ModeloSVM{k}.IsSupportVector, 2),...
         'ko', 'MarkerSize', 10);
    % Frontera de decisión
    contour(x1Grid, x2Grid, reshape(valores{k}(:,2), size(x1Grid)), [0 0], 'k');
    grid on;
    title('M. de Entrenamiento y Frontera de Decisión')
    legend({'Clase 2', 'Clase 1', 'V. de soporte'}, 'Location', 'Best');
    
    subplot(1,3,2);
    gscatter(xGrid(:,1),xGrid(:,2),asignado{k});
    legend({'Clase 2', 'Clase 1'}, 'Location', 'Best');
    grid on;
    title('Muestras de Prueba');
    sgtitle(sprintf('%s.    Error Val. Cruzada: %.2f%%', titulos{k}, 100*errorVC(k)));
    
    subplot(1,3,3);
    cm = confusionchart(Y, ModeloVC{k}.kfoldPredict);
    cm.Title = sprintf('Matriz confusion');
end


%% Para ilustrar nuevamente cómo clasificar muestras nuevas
Xtest = [-1, 1; 3, 1.2; -0.7, -1.2; 2, -1];  % 4 muestras (vectores fila)
modelo = ModeloSVM{2};
Clasif_test = predict(modelo, Xtest)  % -1 significa clase 2, 1 significa clase 1

%% matriz confusion
