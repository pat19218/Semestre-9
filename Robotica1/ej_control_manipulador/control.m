function u = control(t, q, dq, D, C, G, B, fK, J, dJdt, h, H, dHdt)
    ctrlsel = 1; % Seleccionar el caso de control a evaluar
    
    switch ctrlsel
        % Joint space PD control with gravity compensation. Constant 
        % configuration reference.
        case 1  
            KP = 2*eye(3);
            KD = 2*eye(3);
            qd = [pi/6; pi/6; pi/6];
            u = B^(-1)*(G - KP*(q - qd) - KD*dq);
            
        % Task space PD control with gravity compensation. Constant 
        % position reference. 
        case 2
            Jp = J(1:3,:);
            Jpdt = dJdt(1:3,:);
            
            KP = 2*eye(3);
            KD = 2*eye(3);
            pd = [0.5;0.5;0.5];
            vd = [0;0;0];
            p = fK(1:3,4);
            v = Jp*dq;
            
            u = B^(-1)*( G - Jp'*KD*(p - pd) - Jp'*KD*Jp*dq );
        
        % Joint space full-state feedback linearization PD control (aka 
        % computed torque control). Constant configuration reference.
        case 3
            KP = 2*eye(3);
            KD = 2*eye(3);
            qd = [pi/6; pi/6; pi/6];
            u = B^(-1)*( D*(-KP*(q - qd) - KD*dq) + C*dq + G );
            
        % Joint space full-state feedback linearization PD control (aka 
        % computed torque control). Reference trajectory tracking.
        case 4
            KP = 2*eye(3);
            KD = 2*eye(3);
            qd = [1; 1; 1]*sin(2*pi*t);
            dqd = 2*pi*[1; 1; 1]*cos(2*pi*t);
            u = B^(-1)*( D*(-KP*(q - qd) - KD*(dq - dqd)) + C*dq + G );    
            
        % Task space full-state feedback linearization PD 
        % control. Constant position reference using the linear velocity 
        % jacobian.  
        case 5
            Jp = J(1:3,:);
            Jpdt = dJdt(1:3,:);
            % Al trabajar en el espacio de tarea volvemos a caer a los
            % posibles problemas de singularidades del jacobiano, por lo
            % que puede ser útil emplear la pseudoinversa en lugar de la
            % inversa en este caso
            use_pinv = 1;
            if(use_pinv)
                Dop = pinv(((Jp/D)*Jp'));
            else
                Dop = (((Jp/D)*Jp'))\eye(3);
            end
            Cop = Dop*( (Jp/D)*C - Jpdt )*dq;
            Gop = Dop*(Jp/D)*G;
            KP = 2*eye(3);
            KD = 2*eye(3);
            pd = [0.5;0.5;0.5];
            vd = [0;0;0];
            p = fK(1:3,4);
            v = Jp*dq;
            F = Dop*(-KP*(p - pd) - KD*(v - vd)) + Cop + Gop;
            u = B^(-1)*Jp'*F;
        
        % Task space PD control with gravity compensation using task space
        % dynamics. Constant position reference. 
        case 6
            Jp = J(1:3,:);
            Jpdt = dJdt(1:3,:);
            % Al trabajar en el espacio de tarea volvemos a caer a los
            % posibles problemas de singularidades del jacobiano, por lo
            % que puede ser útil emplear la pseudoinversa en lugar de la
            % inversa en este caso
            use_pinv = 1;
            if(use_pinv)
                Dop = pinv(((Jp/D)*Jp'));
            else
                Dop = (((Jp/D)*Jp'))\eye(3);
            end
            Cop = Dop*( (Jp/D)*C - Jpdt )*dq;
            Gop = Dop*(Jp/D)*G;
            KP = 4*eye(3);
            KD = 4*eye(3);
            pd = [0.5;0.5;0.5];
            vd = [0;0;0];
            p = fK(1:3,4);
            v = Jp*dq;
            u = B^(-1)*Jp'*(Gop - KP*(p - pd) - KD*(v - vd));
            
        % QP based operational space control. 
        % Task: end effector on desired position
        % Constraint: dynamics
        case 7
            Jp = J(1:3,:);
            Jpdt = dJdt(1:3,:);
            KP = 2*eye(3);
            KD = 2*eye(3);
            pd = [0.5;0.5;0.5];
            vd = [0;0;0];
            p = fK(1:3,4);
            v = Jp*dq;
            dwe = -KP*(p - pd) - KD*(v - vd);
            
            x = rand(length(q)+size(B,2),1);
            Als = [Jp, zeros(size(B,2), size(B,2))];
            bls = -( Jpdt*dq - dwe );
            Aeq = [D, -eye(size(B,2))];
            beq = -C*dq - G;
            lb = [-inf; -inf; -inf; -20; -20; -20];
            ub = [inf; inf; inf; 20; 20; 20];
            x = lsqlin(Als, bls, [], [], Aeq, beq, lb, ub);
            u = x(length(q)+1:end); 
    end
end

