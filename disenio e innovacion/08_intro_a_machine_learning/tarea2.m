%% IE3038 - Diseño e Innovación en Ingeniería 1
%  Tarea entrenar una ANN 
%  Cristhofer Patzán

%%

[x,t] = iris_dataset; %datos, target/clasificacion
net = patternnet(10,'trainscg');

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

net = train(net,x,t);

y = net(x);
perf = perform(net,t,y);
classes = vec2ind(y);

view(net)