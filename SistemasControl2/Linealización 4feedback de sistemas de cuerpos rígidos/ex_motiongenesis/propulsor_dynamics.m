function fxu = propulsor_dynamics(x, u)
    %-------------------------------+--------------------------+-------------------+-----------------
    % Quantity                      | Value                    | Units             | Description
    %-------------------------------|--------------------------|-------------------|-----------------
    LA                              =  1;                      % m                   Constant
    LB                              =  4;                      % m                   Constant
    LC                              =  2.5;                    % m                   Constant
    LN                              =  3;                      % m                   Constant
    LD                              =  2.6;                    % m                   Constant
    LE                              =  3;                      % m                   Constant
    mA                              =  1;                      % kg                  Constant
    mB                              =  1;                      % kg                  Constant
    mC                              =  1.5;                    % kg                  Constant
    mE                              =  0.5;                    % kg                  Constant
    %------------------------------------------------------------------------------------------------
    % Evaluate constants
    IA = 0.08333333333333333*mA*LA^2;
    IB = 0.08333333333333333*mB*LB^2;
    IC = 0.08333333333333333*mC*(LC+LD)^2;
    IE = 0.3333333333333333*mE*LE^2;
    
    % Drag force constant: 0.5*rho*Cd*A*r_arm
    Kdrag = 5;
    
    qA = x(1);
    qB = x(2);
    qC = x(3);
    qE = x(4);
    qAp = x(5);
    qEp = x(6);
    tau = u;

    qBp = -LA*sin(qA-qC)*qAp/(LB*sin(qB-qC));
    qCp = -LA*sin(qA-qB)*qAp/(LC*sin(qB-qC));
    
    qApp = -(LA*sin(qA-qB)*(4*IE+mE*LE*(LE+2*(LC+LD)*cos(qE)))*(4*IE*(LB*qBp^2+sin(qB)*(LA*sin(qA)*qAp^2-LC*sin(qC)*qCp^2)+cos(qB)*(LA*  ...
    cos(qA)*qAp^2-LC*cos(qC)*qCp^2))/(LC*sin(qB-qC))-4*Kdrag*qEp*abs(qEp)-mE*LE*(2*(LC+LD)*sin(qE)*qCp^2-(LE+2*(LC+LD)*cos(qE))*(LB*qBp^2+  ...
    sin(qB)*(LA*sin(qA)*qAp^2-LC*sin(qC)*qCp^2)+cos(qB)*(LA*cos(qA)*qAp^2-LC*cos(qC)*qCp^2))/(LC*sin(qB-qC))))/(LC*sin(qB-qC))+(mE*LE^2+  ...
    4*IE)*(4*tau+LA*(4*IB*sin(qA-qC)*(LC*qCp^2-sin(qC)*(LA*sin(qA)*qAp^2+LB*sin(qB)*qBp^2)-cos(qC)*(LA*cos(qA)*qAp^2+LB*cos(qB)*qBp^2))/(LB^2*  ...
    sin(qB-qC)^2)+mE*sin(qA-qB)*(2*LE*(LC+LD)*sin(qE)*qCp^2-2*LE*(LC+LD)*sin(qE)*(qEp+qCp)^2-(LE^2+4*(LC+LD)^2+4*LE*(LC+LD)*cos(qE))*(  ...
    LB*qBp^2+sin(qB)*(LA*sin(qA)*qAp^2-LC*sin(qC)*qCp^2)+cos(qB)*(LA*cos(qA)*qAp^2-LC*cos(qC)*qCp^2))/(LC*sin(qB-qC)))/(LC*sin(qB-qC))-(  ...
    mC*(LC+LD)^2+4*IC+4*IE)*sin(qA-qB)*(LB*qBp^2+sin(qB)*(LA*sin(qA)*qAp^2-LC*sin(qC)*qCp^2)+cos(qB)*(LA*cos(qA)*qAp^2-LC*cos(qC)*qCp^2))/(LC^2*  ...
    sin(qB-qC)^2)-mB*(2*LB*sin(qA-qB)*qBp^2+(2*cos(qA-qB)*(LC*qCp^2-sin(qC)*(LA*sin(qA)*qAp^2+LB*sin(qB)*qBp^2)-cos(qC)*(LA*cos(qA)*qAp^2+  ...
    LB*cos(qB)*qBp^2))+sin(qA-qC)*(2*LA*sin(qA-qB)*qAp^2-(LC*qCp^2-sin(qC)*(LA*sin(qA)*qAp^2+LB*sin(qB)*qBp^2)-cos(qC)*(LA*cos(qA)*qAp^2+  ...
    LB*cos(qB)*qBp^2))/sin(qB-qC)))/sin(qB-qC)))))/(LA^2*sin(qA-qB)^2*(4*IE+mE*LE*(LE+2*(LC+LD)*cos(qE)))^2/(LC^2*sin(qB-qC)^2)-(mE*LE^2+  ...
    4*IE)*(mA*LA^2+4*IA+4*LA^2*IB*sin(qA-qC)^2/(LB^2*sin(qB-qC)^2)+mB*LA^2*(4+sin(qA-qC)^2/sin(qB-qC)^2-4*sin(qA-qC)*cos(qA-qB)/sin(qB-  ...
    qC))+LA^2*sin(qA-qB)^2*(mC*(LC+LD)^2+4*IC+4*IE+mE*(LE^2+4*(LC+LD)^2+4*LE*(LC+LD)*cos(qE)))/(LC^2*sin(qB-qC)^2)));
    
    qEpp = -((mA*LA^2+4*IA+4*LA^2*IB*sin(qA-qC)^2/(LB^2*sin(qB-qC)^2)+mB*LA^2*(4+sin(qA-qC)^2/sin(qB-qC)^2-4*sin(qA-qC)*cos(qA-qB)/sin(  ...
    qB-qC))+LA^2*sin(qA-qB)^2*(mC*(LC+LD)^2+4*IC+4*IE+mE*(LE^2+4*(LC+LD)^2+4*LE*(LC+LD)*cos(qE)))/(LC^2*sin(qB-qC)^2))*(4*IE*(LB*qBp^2+  ...
    sin(qB)*(LA*sin(qA)*qAp^2-LC*sin(qC)*qCp^2)+cos(qB)*(LA*cos(qA)*qAp^2-LC*cos(qC)*qCp^2))/(LC*sin(qB-qC))-4*Kdrag*qEp*abs(qEp)-mE*  ...
    LE*(2*(LC+LD)*sin(qE)*qCp^2-(LE+2*(LC+LD)*cos(qE))*(LB*qBp^2+sin(qB)*(LA*sin(qA)*qAp^2-LC*sin(qC)*qCp^2)+cos(qB)*(LA*cos(qA)*qAp^2-  ...
    LC*cos(qC)*qCp^2))/(LC*sin(qB-qC))))+LA*sin(qA-qB)*(4*IE+mE*LE*(LE+2*(LC+LD)*cos(qE)))*(4*tau+LA*(4*IB*sin(qA-qC)*(LC*qCp^2-sin(qC)*(  ...
    LA*sin(qA)*qAp^2+LB*sin(qB)*qBp^2)-cos(qC)*(LA*cos(qA)*qAp^2+LB*cos(qB)*qBp^2))/(LB^2*sin(qB-qC)^2)+mE*sin(qA-qB)*(2*LE*(LC+LD)*sin(  ...
    qE)*qCp^2-2*LE*(LC+LD)*sin(qE)*(qEp+qCp)^2-(LE^2+4*(LC+LD)^2+4*LE*(LC+LD)*cos(qE))*(LB*qBp^2+sin(qB)*(LA*sin(qA)*qAp^2-LC*sin(qC)*qCp^2)+  ...
    cos(qB)*(LA*cos(qA)*qAp^2-LC*cos(qC)*qCp^2))/(LC*sin(qB-qC)))/(LC*sin(qB-qC))-(mC*(LC+LD)^2+4*IC+4*IE)*sin(qA-qB)*(LB*qBp^2+sin(qB)*(  ...
    LA*sin(qA)*qAp^2-LC*sin(qC)*qCp^2)+cos(qB)*(LA*cos(qA)*qAp^2-LC*cos(qC)*qCp^2))/(LC^2*sin(qB-qC)^2)-mB*(2*LB*sin(qA-qB)*qBp^2+(2*  ...
    cos(qA-qB)*(LC*qCp^2-sin(qC)*(LA*sin(qA)*qAp^2+LB*sin(qB)*qBp^2)-cos(qC)*(LA*cos(qA)*qAp^2+LB*cos(qB)*qBp^2))+sin(qA-qC)*(2*LA*sin(  ...
    qA-qB)*qAp^2-(LC*qCp^2-sin(qC)*(LA*sin(qA)*qAp^2+LB*sin(qB)*qBp^2)-cos(qC)*(LA*cos(qA)*qAp^2+LB*cos(qB)*qBp^2))/sin(qB-qC)))/sin(  ...
    qB-qC))))/(LC*sin(qB-qC)))/(LA^2*sin(qA-qB)^2*(4*IE+mE*LE*(LE+2*(LC+LD)*cos(qE)))^2/(LC^2*sin(qB-qC)^2)-(mE*LE^2+4*IE)*(mA*LA^2+4*  ...
    IA+4*LA^2*IB*sin(qA-qC)^2/(LB^2*sin(qB-qC)^2)+mB*LA^2*(4+sin(qA-qC)^2/sin(qB-qC)^2-4*sin(qA-qC)*cos(qA-qB)/sin(qB-qC))+LA^2*sin(qA-  ...
    qB)^2*(mC*(LC+LD)^2+4*IC+4*IE+mE*(LE^2+4*(LC+LD)^2+4*LE*(LC+LD)*cos(qE)))/(LC^2*sin(qB-qC)^2)));
    
%     if((qE >= 0) && (qCp < 0))
%         qEp = 0;
%     elseif((qE <= -1.5) && (qCp > 0))
%         qEp = 0;
%     end

    fxu = [qAp, qBp, qCp, qEp, qApp, qEpp]';
end