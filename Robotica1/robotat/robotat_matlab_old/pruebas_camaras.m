%% Establezco la conexion
robotat = robotat_connect('192.168.50.200'); %Importante estar conectado a la red wifi 

%% Empiezo a extraer datos
xi3 = robotat_get_pose(robotat, 3, 'quat'); %Devuelve los cuarteniones
rob1 = robotat_get_pose(robotat, 3, 'eulzyx'); %Devuelve angulos euler

%% Obtengo los datos de todos 
xi = robotat_get_pose(robotat, 1:10, 'quat'); %Devuelve los cuarteniones
ang = robotat_get_pose(robotat, 1:10, 'eulzyx'); %Devuelve angulos euler

%% Siempre desconectarse al finalizar pruebas

robotat_disconnect(robotat)