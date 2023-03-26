function T = trans_rigida(x,y,theta) %angulo en grados
    T = [cos(deg2rad(theta)), -sin(deg2rad(theta)), x; sin(deg2rad(theta)), cos(deg2rad(theta)), y; 0, 0, 1];

end