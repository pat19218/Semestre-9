function poses_interp = InterpolacionPoses(pose1,pose2,n)

% Interpola n veces entre las dos poses
poses_interp = zeros(4, 4, n+1);

for i = 1:(n+1)
    % Calcula el parámetro de interpolación
    t = (i-1)/n;
    
    % Interpola la rotación utilizando Slerp
    r1 = pose1(1:3, 1:3);
    r2 = pose2(1:3, 1:3);
    q1 = rotm2quat(r1);
    q2 = rotm2quat(r2);
    q_interp = slerp(q1, q2, t);
    r_interp = quat2rotm(q_interp);
    
    % Interpola la traslación utilizando la interpolación lineal
    t1 = pose1(1:3, 4);
    t2 = pose2(1:3, 4);
    t_interp = (1 - t) * t1 + t * t2;
    
    % Combina la rotación y la traslación en la matriz de pose interpolada
    pose_interp = eye(4);
    pose_interp(1:3, 1:3) = r_interp;
    pose_interp(1:3, 4) = t_interp;
    
    % Agrega la matriz de pose interpolada a la lista de poses interpoladas
    poses_interp(:, :, i) = pose_interp;
end

end

function q_interp = slerp(q1, q2, t)
% Interpola entre dos quaterniones utilizando Slerp
% q1: el primer quaternion
% q2: el segundo quaternion
% t: el parámetro de interpolación, entre 0 y 1
omega = acos(dot(q1, q2));
q_interp = (sin((1 - t)*omega)*q1 + sin(t*omega)*q2)/sin(omega);
end