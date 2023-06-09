%% CONEXION
clear; clc;
robotat = robotat_connect('192.168.50.200');

%% VALORES
MAX_WHEEL_VELOCITY = 500; % velocidad máxima ruedas (en rad/s)
WHEEL_RADIUS = 17; % radio de las ruedas (en mm)
DISTANCE_FROM_CENTER = 45; % distancia a ruedas (en mm)
% Velocidad lineal máxima (en mm/s)
MAX_SPEED = WHEEL_RADIUS * MAX_WHEEL_VELOCITY;
N = 7; % Seleccion robot 

%% Pose del robot
robo = robotat_get_pose(robotat,N, 'eulxyz');
T = [eul2rotm(deg2rad(robo(4:6))),[robo(1); robo(2); robo(3)]; 0,0,0,1];
trplot(T, 'frame','A','color','blue','axis',[-3.8 3.8 -4.8 4.8 0 3], 'length', 0.50);


%% MAKE MAP
% Leer markers
obs1 = robotat_get_pose(robotat,12, 'eulxyz');
obs2 = robotat_get_pose(robotat,14, 'eulxyz');
obs3 = robotat_get_pose(robotat,16, 'eulxyz');
obs4 = robotat_get_pose(robotat,18, 'eulxyz');
obs5 = robotat_get_pose(robotat,19, 'eulxyz');
obs6 = robotat_get_pose(robotat,20, 'eulxyz');
obs7 = robotat_get_pose(robotat,21, 'eulxyz');
obs8 = robotat_get_pose(robotat,22, 'eulxyz');

% Organizar datos
dataX = [obs1(1); obs2(1); obs3(1); obs4(1); obs5(1); obs6(1); obs7(1); obs8(1)];
dataY = [obs1(2); obs2(2); obs3(2); obs4(2); obs5(2); obs6(2); obs7(2); obs8(2)];
dataX_d = flip(dataX);
dataY_d = flip(dataY);
data = [dataX_d,dataY_d];

% (48,38)
% Especificaciones mapa


gridSize = 5;
res = 0.1;
gridSizeCells = round(gridSize/ res);
occupancyGrid = zeros(gridSizeCells, gridSizeCells);

% Creacion de mapa, utilizando sus respectivos obstaculos
numDataPoints = size(data, 1);
for i = 1:numDataPoints
    x = dataY_d(i);  % 
    y = dataX_d(i);  % 

    % Convert object position to grid cell index
    xIndex = round(x / res) + gridSizeCells/2;
    yIndex = round(y / res) + gridSizeCells/2;

    % Update occupancy grid
    if xIndex >= 1 && xIndex <= gridSizeCells && yIndex >= 1 && yIndex <= gridSizeCells
        occupancyGrid(xIndex, yIndex) = 1;  % Mark cell as occupied
    end
end

% Visualizar mapa
figure;
map = double(occupancyGrid);
map = flip(occupancyGrid);
colormap(flipud(gray));  % Flip colormap to have unoccupied cells as black
imshow(map);

%% CREAR TRAYECTORIAS
%% GOALS
goal = [round(1.2 / res) + gridSizeCells/2 ; round(-1.5 / res) + gridSizeCells/2];

figure;




