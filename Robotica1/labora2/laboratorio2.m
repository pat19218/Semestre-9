% =========================================================================
% MT3005 - LABORATORIO 2: Cinemática de cuerpos rígidos en 2D
% -------------------------------------------------------------------------
% Ver las instrucciones en la guía adjunta
% =========================================================================
%% Inciso 2. NO modificar, sólo se usa para la auto-calificación
fun_trans_rigida = trans_rigida(1, 2, 45); 

%% Inciso 3. NO modificar, sólo se usa para la auto-calificación
fun_cart2hom = cart2hom([-1; 2; 4]);
fun_hom2cart = hom2cart(fun_cart2hom);

%% Inciso 4. 
% {I}: marco de referencia inercial
% {B}: marco de referencia del robot
% {C}: marco de referencia del sensor 1
% {D}: marco de referencia del sensor 2
IT_B = trans_rigida(0, 1, 90);
BT_C = trans_rigida(0.5, -0.5, -45);
BT_D = trans_rigida(0.5, 0.5, 45);

IT_C = IT_B*BT_C;
IT_D = IT_B*BT_D;

Cp = cart2hom([2;0]);
Dp = cart2hom([1;0]);

Ip1 = hom2cart(IT_C*Cp);
Ip2 = hom2cart(IT_D*Dp);
sensor_malo = 2;

%% Inciso 5.
p1 = [0;0];
p2 = [1;0];
p3 = [1;1];
p4 = [0;1];

v1 = hom2cart(trans_rigida(2, 3, 30)*cart2hom(p1));
v2 = hom2cart(trans_rigida(2, 3, 30)*cart2hom(p2));
v3 = hom2cart(trans_rigida(2, 3, 30)*cart2hom(p3));
v4 = hom2cart(trans_rigida(2, 3, 30)*cart2hom(p4));

P = [p1 p2 p3 p4];
V = [v1 v2 v3 v4];

patch(V(1,:),V(2,:),'red')
hold on
patch(P(1,:),P(2,:),'green')
grid on
axis([0 5 0 5]) %[xmin xmax ymin ymax]