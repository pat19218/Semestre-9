%% IE3038 - Diseño e Innovación en Ingeniería 1
%  Tarea de clasificación usando SVM 
%  Cristhofer Patzán

%% Generación de muestras de entrenamiento, tomado de la documentación de Matlab
rng (1)     %Semilla de los numeros aleatorios
grnpop = mvnrnd([1,0],eye(2),100); %Genero 100 puntos
redpop = mvnrnd([0,1],eye(2),100);

figure(1)   %Grafico los puntos
plot(grnpop(:,1),grnpop(:,2),'go')
hold on
plot(redpop(:,1),redpop(:,2),'ro')
hold off

%% Preparo los datos para clasificar
cdata = [grnpop;redpop];
grp = ones(200,1);  %Etiquetas
% Green label 1, red label -1
grp(101:200) = -1;
%Validación de datos cruzados
c = cvpartition(200,'KFold',10);

%% Generación de muestras de prueba
delta = 0.02; % Step size of the grid
[x1Grid, x2Grid] = meshgrid(min(cdata(:,1)):delta:max(cdata(:,1)), min(cdata(:,2)):delta:max(cdata(:,2)));
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
ModeloSVM{1} = fitcsvm(cdata,grp,'KernelFunction','linear','KernelScale','auto');
ModeloSVM{2} = fitcsvm(cdata,grp,'KernelFunction','polynomial','KernelScale','auto','PolynomialOrder',2);
ModeloSVM{3} = fitcsvm(cdata,grp,'KernelFunction','rbf','KernelScale','auto','Standardize',true);

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
    gscatter(cdata(:,1), cdata(:,2), grp); hold on;
    % Vectores de soporte
    plot(cdata(ModeloSVM{k}.IsSupportVector, 1), cdata(ModeloSVM{k}.IsSupportVector, 2),...
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
    
    %Matriz de confusion 
    subplot(1,3,3);
    cm = confusionchart(grp, ModeloVC{k}.kfoldPredict);
    cm.Title = sprintf('Matriz confusion');
end

%% Tipo de metodos
%{
%% Metodo mas optimo
opts = struct('Optimizer','bayesopt','ShowPlots',true,'CVPartition',c,'AcquisitionFunctionName','expected-improvement-plus');
svmmod = fitcsvm(cdata,grp,'KernelFunction','polynomial','OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',opts);
ModeloVC = crossval(svmmod);
%% Metodo menos optimo
lossnew = kfoldLoss(fitcsvm(cdata,grp,'CVPartition',c,'KernelFunction','polynomial',...
    'BoxConstraint',svmmod.HyperparameterOptimizationResults.XAtMinObjective.BoxConstraint,...
    'KernelScale',svmmod.HyperparameterOptimizationResults.XAtMinObjective.KernelScale));

%% Visualizo el optimo
d = 0.02;
[x1Grid,x2Grid] = meshgrid(min(cdata(:,1)):d:max(cdata(:,1)),...
    min(cdata(:,2)):d:max(cdata(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
[~,scores] = predict(svmmod,xGrid);
figure;
h = nan(3,1); % Preallocation
h(1:2) = gscatter(cdata(:,1),cdata(:,2),grp,'rg','+*');
hold on
h(3) = plot(cdata(svmmod.IsSupportVector,1),...
    cdata(svmmod.IsSupportVector,2),'ko');
contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k');
legend(h,{'-1','+1','Support Vectors'},'Location','Southeast');
axis equal
hold off
%}

