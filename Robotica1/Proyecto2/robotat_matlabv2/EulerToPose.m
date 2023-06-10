function pose = EulerToPose(eulerxyz)
x = eulerxyz(1);
y = eulerxyz(2);
z = eulerxyz(3);
roll = deg2rad(eulerxyz(4));
pitch = deg2rad(eulerxyz(5));
yaw = deg2rad(eulerxyz(6));


rotacion1 = trotz(yaw) * troty(pitch) * trotx(roll); % Matriz de rotación
traslacion1 = eye(4); % Matriz de translación
traslacion1(1:3, 4) = [x; y; z]; % Asignar las coordenadas de traslación


% Calcular la transformación homogénea del objeto 1
pose = traslacion1 * rotacion1;

end