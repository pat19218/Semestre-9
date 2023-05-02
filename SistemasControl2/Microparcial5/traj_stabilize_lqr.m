function K = traj_stabilize_lqr(dyn_handle, Xd, Ud, Q, R, S, t0, tf, dt)
%TRAJ_STABILIZE_LQR Gets the LQR time-varying gain matrix for trajectory stabilization 
%   Assumes constant Q and R matrices
%   Requires linloc function to linealize the dynamics
    N = length(Ud);
    P = zeros(length(Xd(:,1)), length(Xd(:,1)));
    K = zeros(length(Ud(:,1)), length(Xd(:,1)));
    P(:,:,N) = S; % final value condition
    n = N; % set the control (time) horizon
    
    % Solve the Differential Riccati Equation backwards (with forward
    % Euler) and get the control gain matrix for each time step
    while(n > 1)
        [A,B,~,~] = loclin_best(dyn_handle, dyn_handle, Xd(:, n), Ud(:, n));
        P(:,:,n-1) = P(:,:,n) - ...
            dt * (-A'*P(:,:,n) - P(:,:,n)*A - Q + P(:,:,n)*B*inv(R)*B'*P(:,:,n));
        K(:,:,n) = inv(R)*B'*P(:,:,n);
        n = n - 1;
    end
end

