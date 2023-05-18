function pose = EulerToPose(eulerxyz)
x = eulerxyz(1);
y = eulerxyz(2);
z = eulerxyz(3);
roll = deg2rad(eulerxyz(4));
pitch = deg2rad(eulerxyz(5));
yaw = deg2rad(eulerxyz(6));

Rz = [cos(yaw) -sin(yaw) 0,0;
      sin(yaw) cos(yaw)  0,0;
      0        0         1,0;
      0,0,0,1];
Ry = [cos(pitch) 0 sin(pitch),0;
      0          1 0,0;
      -sin(pitch) 0 cos(pitch),0;
      0,0,0,1];
Rx = [1 0         0,0;
      0 cos(roll) -sin(roll),0;
      0 sin(roll) cos(roll),0;
      0,0,0,1];
  

T = [1 0 0 x;
     0 1 0 y;
     0 0 1 z;
     0 0 0 1];


M =  T* Rz * Ry * Rx ;


pose = eye(4);
pose(1:3, 1:3) = M(1:3, 1:3);
pose(1:3, 4) = M(1:3, 4);


end