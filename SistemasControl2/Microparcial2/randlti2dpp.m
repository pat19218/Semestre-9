function randlti2dpp()
%RANDLTI2DPP Plots the phase portrait of a random second order homogeneous
%state space LTI system.
    A = 10 * randn(2, 2) - 5
    dx = @(x, v) A*x;
    
    [mX1, mX2] = meshgrid(-5:0.1:5, -5:0.1:5);
    [mDX1, mDX2] = phaseportrait2d(dx, mX1, mX2, 0);
    figure;
    phasep_lin = streamslice(mX1, mX2, mDX1, mDX2);
    set(phasep_lin, 'Color', [0.5, 0.5, 0.5]);
    xlabel('$x_1$', 'FontSize', 18, 'Interpreter','latex');
    ylabel('$x_2$', 'FontSize', 18, 'Interpreter','latex');
end