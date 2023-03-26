% =========================================================================
% IE3041 - EJEMPLO LINEALIZACIÓN DE UN SATÉLITE PLANAR
% -------------------------------------------------------------------------
% Se presenta un ejemplo en donde se efectúa la simulación del modelo de un
% satélite planar y se encuentra la linealización local alrededor de una
% trayectoria analítica.
% =========================================================================
function plansat_lintraj(delta)
    %% Parámetros y dinámica del sistema
    beta = 10;
    r0 = 2;
    theta0 = pi/6;
    w0 = sqrt(beta / r0^3);
    
    % Campo vectorial del sistema
    f = @(x,u) [x(2); x(1)*x(4)^2-beta/x(1)^2+u(1); 
                x(4); -2*x(2)*x(4)/x(1)+u(2)/x(1)];
            
    % Campo vectorial de la salida (se coloca un dummy sólo para poder emplear 
    % la función linloc)
    h = @(x,u) x;
    
    %% Parámetros de la simulación
    t0 = 0;
    tf = 10; % tiempo de simulación
    dt = 0.01; % tiempo de muestreo
    K = (tf - t0) / dt;
    
    %% Inicialización y condiciones iniciales
    x0 = [r0; 0; theta0; w0]; % condición inicial
    x = x0; % vector de estado
    u0 = [0; 0]; % entradas iniciales 
    u = u0; % vector de entradas
    % Array para almacenar las trayectorias de las variables de estado
    X = zeros(numel(x0), K+1); X(:,1) = x;
    % Array para almacenar la evolución de las entradas 
    U = zeros(numel(u0), K+1); U(:,1) = u;
    
    %% Linealización
    z0 = delta * ones(size(x0)); % condiciones iniciales cercanas a cero
    z = z0; % vector de desviaciones
    ud = [0;0]; % entrada nominal/trayectoria de entrada deseada 
    % Array para almacenar las trayectorias de las desviaciones
    Z = zeros(numel(z0), K+1); Z(:,1) = z;
    
    %% Solución recursiva del sistema dinámico
    for k = 1:K
        % Torques de entrada
        u = [0; 0];
        v = u - ud;
    
        % Método RK4 para la aproximación numérica de la solución
        k1 = f(x, u);
        k2 = f(x+(dt/2)*k1, u);
        k3 = f(x+(dt/2)*k2, u);
        k4 = f(x+dt*k3, u);
        x = x + (dt/6)*(k1+2*k2+2*k3+k4);
        
        % Se obtienen las matrices de la linealización numérica alrededor de la
        % trayectoria
        [A,B,~,~] = loclin_fast(f, h, x, [0; 0]);
        
        % Se obtiene la linealización numérica del sistema alrededor de la
        % trayectoria (empleando forward euler por simplicidad)
        z = (eye(size(A)) + A*dt)*z + (B*dt)*v;
        
        % Se guardan las trayectorias de los vectores de estado y entrada
        X(:, k+1) = x;
        U(:, k+1) = u;
        
        % Se guarda la trayectoria del vector de desviaciones para la
        % linealización
        Z(:, k+1) = z;
    end
    
    %% Animación y generación de figuras (NO modificar)
    % Se grafica la evolución en el tiempo de las variables de estado
    figure;
    t = t0:dt:tf;
    plot(t, X', 'LineWidth', 1);
    xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
    ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
    l = legend('$r(t)$', '$\dot{r}(t)$', '$\theta(t)$', '$\dot{\theta}(t)$', ...
        'Location', 'northwest', 'Orientation', 'vertical');
    set(l, 'Interpreter', 'latex', 'FontSize', 12);
    
    % Se grafica la comparación entre la linealización y la solución del
    % sistema
    figure;
    subplot(1,2,1);
    plot(t, Z', 'LineWidth', 1);
    xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
    ylabel('$\mathbf{z}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
    l = legend('$\delta r(t)$', '$\delta \dot{r}(t)$', '$\delta \theta(t)$',...
        '$\delta \dot{\theta}(t)$', 'Location', 'southwest', 'Orientation',...
        'vertical');
    set(l, 'Interpreter', 'latex', 'FontSize', 12);
    
    subplot(1,2,2);
    plot(t, X', '--', 'LineWidth', 1);
    hold on;
    plot(t, (X'+Z'), 'LineWidth', 1);
    hold off;
    xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
    ylabel('$\mathbf{z}(t)+\mathbf{x}_d(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
    l = legend('$r(t)$', '$\dot{r}(t)$', '$\theta(t)$', '$\dot{\theta}(t)$', ...
        '$r^*(t) + \delta r(t)$', '$\dot{r}^*(t) + \delta \dot{r}(t)$',...
        '$\theta^*(t) + \delta \theta(t)$', '$\dot{\theta}^*(t) + \delta \dot{\theta}(t)$', ...
        'Location', 'northwest', 'Orientation', 'vertical');
    set(l, 'Interpreter', 'latex', 'FontSize', 12);
    
    % Se grafica la animación del satélite orbitando
    figure;
    s = 3;
    delt = 0.1;
    xlim(s*[-1, 1]);
    ylim(s*[-1, 1]);
    grid off;
    hold on;
    
    q = X(:,1);
    r = q(1);
    theta = q(3);
    x = r*cos(theta);
    y = r*sin(theta);
    h1 = plot(x, y, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1);
    c1 = circle(0,0,5*delt);
    c2 = circle(x,y,delt);
    
    for k = 2:K+1
        q = X(:,k);
        r = q(1);
        theta = q(3);
        x = r*cos(theta);
        y = r*sin(theta);
    
        h1.XData = [h1.XData, x];
        h1.YData = [h1.YData, y];
        c2.Position(1:2) = [x-delt, y-delt];
        
        pause(dt);
    end
end