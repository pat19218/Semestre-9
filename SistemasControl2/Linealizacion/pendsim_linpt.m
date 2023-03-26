% =========================================================================
% IE3041 - EJEMPLO LINEALIZACIÓN DEL PÉNDULO SIMPLE
% -------------------------------------------------------------------------
% En este ejemplo se hace la comparación entre el comportamiento del modelo
% no lineal del péndulo simple y su linealización local alrededor de un
% punto de equilibrio, representada por un sistema LTI.
% =========================================================================
function pendsim_linpt(xss, delta)
    %% Parámetros y dinámica del sistema
    m = 2; % kg
    ell = 1; % m
    b = 0.8; 
    g = 9.81; % m/s^2
    
    % Campo vectorial del sistema
    f = @(x,u) [ x(2); 
                 -(g/ell)*sin(x(1)) - (b/(m*ell^2))*x(2) + (1/(m*ell^2))*u ];
    
    % Campo vectorial de la salida (se coloca un dummy sólo para poder emplear 
    % la función loclin)
    h = @(x,u) x;
             
    %% Parámetros de la simulación
    t0 = 0;
    tf = 10; % tiempo de simulación
    dt = 0.01; % período de muestreo
    K = (tf - t0) / dt; % número de iteraciones
    
    %% Linealización
    % xss - punto de operación/equilibrio deseado
    % delta - magnitud de la desviación
    dxss = delta*[1; 1]; % desviación con respecto del punto de operación
    % Se crea una función auxiliar que corresponda al campo vectorial evaluado
    % en xss, pero en función de u para encontrar una uss válida para el punto
    % de operación/equilibrio
    fu = @(u) f(xss, u); 
    uss = fsolve(fu, 0); % se encuentra el valor de uss empleando Newton  
    
    % Se emplea la función lonlic para linealizar numéricamente al sistema no
    % lineal alrededor del punto de operación/equilibrio
    [A,B,~,~] = loclin_best(f, h, xss, uss);
%     [A,B,~,~] = loclin_fast(f, h, xss, uss);
    
    % Campo vectorial del sistema linealizado
    df = @(z,v) A*z + B*v;
    
    %% Inicialización y condiciones iniciales
    % Sistema no lineal
    x0 = xss + dxss; % condición inicial
    x = x0; % vector de estado
    u0 = uss + delta; % entrada inicial 
    u = u0; % entrada de control
    % Array para almacenar las trayectorias de las variables de estado
    X = zeros(numel(x0), K+1); X(:,1) = x;
    % Array para almacenar la evolución de las entradas 
    U = zeros(numel(u0), K+1); U(:,1) = u;
    
    % Sistema linealizado
    z0 = dxss; % desviación inicial con respecto a xss
    z = z0; % vector de desviaciones
    v0 = u0 - uss; % perturbación inicial
    v = v0; % vector de perturbaciones de entrada
    % Array para almacenar las trayectorias de las desviaciones
    Z = zeros(numel(z0), K+1); Z(:,1) = z;
    % Array para almacenar la evolución de las perturbaciones
    V = zeros(numel(v0), K+1); V(:,1) = v;
    
    
    %% Solución recursiva del sistema dinámico
    for k = 1:K
        % Torque de entrada
        u = uss;
        v = u - uss; % perturbación de entrada
        
        % Método RK4 para la aproximación numérica de la solución del sistema
        % no lineal
        k1 = f(x, u);
        k2 = f(x+(dt/2)*k1, u);
        k3 = f(x+(dt/2)*k2, u);
        k4 = f(x+dt*k3, u);
        x = x + (dt/6)*(k1+2*k2+2*k3+k4);
        
        % Método RK4 para la aproximación numérica de la solución del sistema
        % linealizado
        dk1 = df(z, v);
        dk2 = df(z+(dt/2)*dk1, v);
        dk3 = df(z+(dt/2)*dk2, v);
        dk4 = df(z+dt*dk3, v);
        z = z + (dt/6)*(dk1+2*dk2+2*dk3+dk4);
        
        % Se guardan las trayectorias de los vectores de estado, entrada,
        % desviaciones y perturbaciones
        X(:, k+1) = x;
        U(:, k+1) = u;
        Z(:, k+1) = z;
        V(:, k+1) = v;
    end
         
    
    
    %% Animación y generación de figuras (NO modificar)
    t = t0:dt:tf; % vector de tiempo
    % Gráficas de comparación entre la solución del sistema original y la
    % linealización
    fig1 = figure;
    % Trayectorias de las variables de estado y las entradas del sistema no
    % lineal
    subplot(2,2,1);
    plot(t, X', 'LineWidth', 1);
    xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
    ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
    l = legend('$\theta(t)$', '$\dot{\theta}(t)$', 'Location', ...
        'northeast', 'Orientation', 'vertical');
    set(l, 'Interpreter', 'latex', 'FontSize', 12);
    
    subplot(2,2,3);
    plot(t, U', 'LineWidth', 1);
    xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
    ylabel('$\mathbf{u}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
    l = legend('$\tau(t)$', 'Location', 'northeast', 'Orientation', 'vertical');
    set(l, 'Interpreter', 'latex', 'FontSize', 12);
    
    % Aproximación del comportamiento del sistema basada en la linealización
    % local
    subplot(2,2,2);
    plot(t, repmat(xss,1,K+1)' + Z', 'LineWidth', 1);
    xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
    ylabel('$\mathbf{x}_\mathrm{ss}+\mathbf{z}(t)$', 'Interpreter', ...
        'latex', 'Fontsize', 16);
    l = legend('$\theta_\mathrm{ss}+\delta\theta(t)$', ...
        '$\dot{\theta}_\mathrm{ss}+\delta\dot{\theta}(t)$', 'Location', ...
        'northeast', 'Orientation', 'vertical');
    set(l, 'Interpreter', 'latex', 'FontSize', 12);
    
    subplot(2,2,4);
    plot(t, repmat(uss,1,K+1)' + V', 'LineWidth', 1);
    xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
    ylabel('$\mathbf{u}_\mathrm{ss}+\mathbf{v}(t)$', 'Interpreter', ...
        'latex', 'Fontsize', 16);
    l = legend('$\tau_\mathrm{ss}+\delta\tau(t)$', 'Location', 'northeast', ...
        'Orientation', 'vertical');
    set(l, 'Interpreter', 'latex', 'FontSize', 12);
    
    % Animación del péndulo y de las trayectorias de los sistemas en el espacio
    % de estados
    fig2 = figure;
    fig2.WindowState = 'maximized';
    % Animación péndulo
    subplot(2,2,[1,3]);
    
    pendsize = 0.1;
    xlim(ell*[-1.5, 1.5]);
    ylim(ell*[-1.5, 1.5]);
    grid off;
    hold on;
    
    % Función para calcular la posición del péndulo en función de las
    % coordenadas generalizadas
    pendpos = @(q) ell*[sin(q); -cos(q)];
    
    q = X(1,1);
    r = pendpos(q); x = r(1); y = r(2);
    pendrod = plot([0,x], [0,y], 'Color', [0.5, 0.5, 0.5], 'LineWidth', 3);
    pendmass = circle(x, y, pendsize);
    
    % Animación de la trayectoria en el espacio de estados del sistema no
    % lineal
    subplot(2,2,2);
    meshres = 0.1;
    if(delta <=2)
        lims = 5;
    else
        lims = 10;
    end
    
    xlim([xss(1)-lims, xss(1)+lims]);
    ylim([xss(2)-lims, xss(2)+lims]);
    % grid minor;
    
    % Diagrama de fase del sistema no lineal
    [mX1, mX2] = meshgrid(xss(1)-lims:meshres:xss(1)+lims, ...
        xss(2)-lims:meshres:xss(2)+lims);
    [mDX1, mDX2] = phaseportrait2d(f, mX1, mX2, numel(u));
    phasep_nonlin = streamslice(mX1, mX2, mDX1, mDX2);
    set(phasep_nonlin, 'Color', [0.5, 0.5, 0.5]);
    hold on;
    
    % Diagrama de fase de la aproximación lineal
    [mZ1, mZ2] = meshgrid(-lims:meshres:lims, -lims:meshres:lims);
    [mDZ1, mDZ2] = phaseportrait2d(df, mZ1, mZ2, numel(v));
    phasep_lin = streamslice(mZ1+xss(1), mZ2+xss(2), mDZ1, mDZ2);
    set(phasep_lin, 'Color', [0.3010,0.7450,0.9330]);
    
    % Trayectoria del sistema no lineal
    flowp_nonlin = plot(X(1,1), X(2,1), 'k', 'LineWidth', 1);
    
    % Trayectoria del sistema lineal
    flowp_lin = plot(xss(1)+Z(1,1), xss(2)+Z(2,1), 'Color', ...
        [0.2422,0.1504,0.6603], 'LineWidth', 1);
    
    % Animación de la trayectoria del sistema linealizado en sus coordenadas
    % locales
    subplot(2,2,4);
    xlim([-lims, lims]);
    ylim([-lims, lims]);
    % grid minor;
    
    % Diagrama de fase
    phasep_lin2 = streamslice(mZ1, mZ2, mDZ1, mDZ2);
    set(phasep_lin2, 'Color', [0.3010,0.7450,0.9330]);
    hold on;
    % Trayectoria
    flowp_lin2 = plot(Z(1,1), Z(2,1), 'Color', [0.2422,0.1504,0.6603], ...
        'LineWidth', 1);
    
    % Se actualizan las gráficas y se pausa el programa para dar la ilusión de
    % animación
    for k = 2:K+1
        q = X(1,k);
        r = pendpos(q); x = r(1); y = r(2);
    
        flowp_nonlin.XData = [flowp_nonlin.XData, X(1,k)];
        flowp_nonlin.YData = [flowp_nonlin.YData, X(2,k)];
        flowp_lin.XData = [flowp_lin.XData, xss(1)+Z(1,k)];
        flowp_lin.YData = [flowp_lin.YData, xss(2)+Z(2,k)];
        
        flowp_lin2.XData = [flowp_lin2.XData, Z(1,k)];
        flowp_lin2.YData = [flowp_lin2.YData, Z(2,k)];
    
        pendrod.XData = [0, x];
        pendrod.YData = [0, y];
        pendmass.Position(1:2) = [x-pendsize, y-pendsize];
        pause(dt);
    end
end

