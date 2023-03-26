% =========================================================================
% IE3041 - EJEMPLO RENDEZVOUS EN 2 DIMENSIONES
% -------------------------------------------------------------------------
% Se presenta un ejemplo básico de cómo una red de agentes bi-dimensionales
% alcanzan el consenso empleando mediciones de distancia, ejemplificando
% cómo surgen naturalmente sistemas LTI en aplicaciones diversas.
% =========================================================================
clear all;
%% Parámetros del sistema
% Laplaciano del grafo
L = [ 3, -1, -1, -1,  0,  0; 
     -1,  3, -1, -1,  0,  0; 
     -1, -1,  2,  0,  0,  0; 
     -1, -1,  0,  3, -1,  0; 
      0,  0,  0, -1,  2, -1; 
      0,  0,  0,  0, -1,  1]; % no dirigido
  
% L = [ 1,  0,  0,  0,  0, -1; 
%      -1,  1,  0,  0,  0,  0; 
%       0, -1,  1,  0,  0,  0; 
%       0,  0, -1,  1,  0,  0; 
%       0,  0,  0, -1,  1,  0; 
%       0,  0,  0,  0, -1,  1]; % digirido

agents = size(L, 1); % número de agentes     
% Si el Laplaciano no es dirigido entonces es simétrico
if(norm(L-L', 'fro'))
    is_directed = 1;
else
    is_directed = 0;
end

%% Definición del sistema dinámico
% Campo vectorial del sistema dinámico LTI, se emplea el producto de
% Kronecker para considerar agentes planares
f = @(x,u) -kron(L, eye(2))*x;

%% Parámetros de la simulación
dt = 0.05; % período de muestreo
t0 = 0; % tiempo inicial
tf = 5; % tiempo final
K = (tf-t0)/dt; % número de iteraciones

%% Inicialización y condiciones iniciales
s = 10; % factor de escala del mundo en donde existen los agentes
x0 = 2*s*rand(agents*2,1) - s; % condición inicial
x = x0; % vector de estado 
% Array para almacenar las trayectorias de las variables de estado del 
% sistema
X = zeros(numel(x),K+1);
% Inicialización del array
X(:,1) = x0;

%% Solución recursiva del sistema dinámico
for k = 1:K    
    % Se actualiza el estado del sistema mediante una discretización por 
    % el método de Runge-Kutta (RK4)
    k1 = f(x, 0);
    k2 = f(x+(dt/2)*k1, 0);
    k3 = f(x+(dt/2)*k2, 0);
    k4 = f(x+dt*k3, 0);
    x = x + (dt/6)*(k1+2*k2+2*k3+k4);
    
    % Se guardan las trayectorias del estado
    X(:,k+1) = x;
end


%% Animación y generación de figuras (NO modificar)
% Evolución en el tiempo de la coordenada x de los agentes
figure;
t = t0:dt:tf;
Z = [];
for j = 0:agents-1
    Z = [Z; X(2*j+1, :)];
end
plot(t, Z', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('Coordenada $x$ de agentes', 'Interpreter', 'latex', 'Fontsize', 16);
grid minor;

% Evolución en el tiempo de la coordenada y de los agentes
figure;
t = t0:dt:tf;
Z = [];
for j = 1:agents
    Z = [Z; X(2*j, :)];
end
plot(t, Z', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('Coordenada $y$ de agentes', 'Interpreter', 'latex', 'Fontsize', 16);
grid minor;

% Animación del movimiento de los agentes planares junto con la
% visualización del grafo de intercambio de información entre los mismos
figure;
xlim(s*[-1, 1]);
ylim(s*[-1, 1]);
grid minor;
hold on;

q = X(:,1);
q = reshape(q, [2, agents]);

edges_plot = gobjects(1, numel(L));
idx = 1;
for i = 1:agents
    for j = 1:agents
        if(L(i,j) == 0)
            if(is_directed)
                edges_plot(idx) = quiver(q(1,j), q(2,j), q(1,i)-q(1,j), ...
                q(2,i)-q(2,j), 1, 'MaxHeadSize', 0.5, 'ShowArrowHead', ...
                'on', 'LineStyle', 'none', 'LineWidth', 1);
            else
                edges_plot(idx) = quiver(q(1,j), q(2,j), q(1,i)-q(1,j), ...
                q(2,i)-q(2,j), 0, 'MaxHeadSize', 0.5, 'ShowArrowHead', ...
                'off', 'LineStyle', 'none', 'LineWidth', 1);
            end
        else
            if(is_directed)
               edges_plot(idx) = quiver(q(1,j), q(2,j), q(1,i)-q(1,j), ...
                q(2,i)-q(2,j), 1, 'MaxHeadSize', 0.5, 'ShowArrowHead', ...
                'on', 'Color', 'r', 'LineStyle', '-', 'LineWidth', 1); 
            else
               edges_plot(idx) = quiver(q(1,j), q(2,j), q(1,i)-q(1,j), ...
                q(2,i)-q(2,j), 0, 'MaxHeadSize', 0.5, 'ShowArrowHead', ...
                'off', 'Color', 'r', 'LineStyle', '-', 'LineWidth', 1); 
            end
        end
        idx = idx + 1;
    end
end

agentsplot = scatter(q(1,:), q(2,:), 50, 'k', 'filled');

xlabel('$x$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$y$', 'Interpreter', 'latex', 'Fontsize', 16);
hold off;

for k = 2:K
    q = X(:,k);
    q = reshape(q, [2, agents]);
    
    agentsplot.XData = q(1,:);
    agentsplot.YData = q(2,:);
    
    idx = 1;
    for i = 1:agents
        for j = 1:agents
            edges_plot(idx).XData = q(1,j);
            edges_plot(idx).YData = q(2,j);
            edges_plot(idx).UData = q(1,i)-q(1,j);
            edges_plot(idx).VData = q(2,i)-q(2,j);
            idx = idx + 1;
        end
    end

    pause(dt);
end