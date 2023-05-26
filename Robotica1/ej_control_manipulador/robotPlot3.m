% NOTA: agregar uso de transformaciones de base y herramienta
% function h = robotPlot3(DH, IT_B, ET_F, Q, dt, jointypes, plotscale) 
function h = robotPlot3(DH, IT_B, Q, t, jointypes, plotscale, linkwidth) 
    % jointypes es un string con la secuencia de juntas del manipulador,
    % por ejemplo para un manipulador con tres revolutas jointypes debe ser
    % 'RRR'. Esto indica cuál columna debe ignorarse en la matriz DH del
    % manipulador.
 
    [n, K] = size(Q); 
    
    P = zeros(3, n+2);
    A = IT_B; %genDHmatrix(0, 0, 0, 0);
    P(:,2) = A(1:3,4);
    
    for i = 1:n
        if(jointypes(i) == 'R')
            A = A*genDHmatrix(Q(i,1)+DH(i,2), DH(i,2), DH(i,3), DH(i,4));
        elseif(jointypes(i) == 'P')
            A = A*genDHmatrix(DH(i,1), Q(i,1)+DH(i,2), DH(i,3), DH(i,4));
        end
        P(:,i+2) = A(1:3,4);
    end
    
    figure('units', 'normalized', 'outerposition', [0 0 1 1]);
    h = plot3(P(1,:), P(2,:), P(3,:), 'Color', [0.5, 0.5, 0.5], ...
        'LineWidth', linkwidth);
    xlim(plotscale*[-1,1]);
    ylim(plotscale*[-1,1]);
    zlim(plotscale*[-1,1]);
    axis('square');
    grid minor;
%     view(90,0);
    
    dt = t(2:end) - t(1:end-1);
    
    if(K > 1)
        for k = 2:K
            P = zeros(3, n+2);
            A = IT_B; %genDHmatrix(0, 0, 0, 0);
            P(:,2) = A(1:3,4);
            
            for i = 1:n
                if(jointypes(i) == 'R')
                    A = A*genDHmatrix(Q(i,k), DH(i,2), DH(i,3), DH(i,4));
                elseif(jointypes(i) == 'P')
                    A = A*genDHmatrix(DH(i,1), Q(i,k), DH(i,3), DH(i,4));
                end
                P(:,i+2) = A(1:3,4); 
            end
            
            h.XData = P(1,:);
            h.YData = P(2,:);
            h.ZData = P(3,:);
            pause(dt(k-1));
        end
    end
end