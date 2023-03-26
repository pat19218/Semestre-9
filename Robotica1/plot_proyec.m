%% Graficas marcos de referencias
%Incercial
IT_A = eye(4);

%objeto 1
R = rotz(rob1(4))*roty(rob1(5))*rotx(rob1(6)); %Matriz de rotacion en grados
t = [0;0;0]; %Vector ubicacion del elemento respecto del inercial
AT_B = trans_hom(R, t);

%objeto 2
R = rotz(rob2(4))*roty(rob2(5))*rotx(rob2(6)); %Matriz de rotacion en grados
t = [0;0;0]; %Vector ubicacion del elemento respecto del inercial
AT_C = trans_hom(R, t);

%objeto 3
R = rotz(rob3(4))*roty(rob3(5))*rotx(rob3(6)); %Matriz de rotacion en grados
t = [0;0;0]; %Vector ubicacion del elemento respecto del inercial
AT_D = trans_hom(R, t);

%objeto 4
R = rotz(rob4(4))*roty(rob4(5))*rotx(rob4(6)); %Matriz de rotacion en grados
t = [0;0;0]; %Vector ubicacion del elemento respecto del inercial
AT_E = trans_hom(R, t);


trplot(IT_A,'color','blue','axes','3');
hold on
trplot(AT_B,'color','yellow');
trplot(AT_C,'color','green');
trplot(AT_D,'color','red');
trplot(AT_D,'color','black');
