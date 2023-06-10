caracteristicas = [1 1 1 1 0 0 0 0; 1 1 0 0 1 1 0 0; 1 0 1 0 1 0 1 0];
resultado1 = [1 1 0 0 0 0 0 0];
resultado2 = [1 1 1 0 1 0 1 0];

%% modelo 1
% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize, trainFcn);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[net, tr] = train(net, caracteristicas, resultado1);


% Test the Network
y = net(caracteristicas);  % Se pasan los datos por la red.
e = gsubtract(resultado1, y); %%error
performance = perform(net, resultado1, y)
tind = vec2ind(resultado1);  % Investiguen esta útil función. Con ella se pude determinar la clase
yind = vec2ind(y);  % fácilmente. Básicamente, busca en qué fila está el número mayor.
                    % Si no tienen el toolbox que tiene a esta función, sólo es cuestión
                    % de determinar el índice de la fila con el mayor valor (por cada
                    % vector columna). Ese índice sería la clase asignada.
percentErrors = sum(tind ~= yind)/numel(tind);

% View the Network
view(net)

%% modelo 2


net2 = patternnet(hiddenLayerSize, trainFcn);

% Setup Division of Data for Training, Validation, Testing
net2.divideParam.trainRatio = 70/100;
net2.divideParam.valRatio = 15/100;
net2.divideParam.testRatio = 15/100;

% Train the Network
[net2, tr2] = train(net2, caracteristicas, resultado2);


% Test the Network
y2 = net2(caracteristicas);  % Se pasan los datos por la red.
e2 = gsubtract(resultado2, y2); %%error
performance2 = perform(net2, resultado2, y2)
tind2 = vec2ind(resultado2);  % Investiguen esta útil función. Con ella se pude determinar la clase
yind2 = vec2ind(y2);  % fácilmente. Básicamente, busca en qué fila está el número mayor.
                    % Si no tienen el toolbox que tiene a esta función, sólo es cuestión
                    % de determinar el índice de la fila con el mayor valor (por cada
                    % vector columna). Ese índice sería la clase asignada.
percentErrors2 = sum(tind2 ~= yind2)/numel(tind2);

% View the Network
view(net2)