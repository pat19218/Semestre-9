%% Diseño e Innovación de Ingeniería 1
%  Luis Alberto Rivera
%  Ejemplos del uso de función para detección de Zero-Crossings

%%
N = 10000;
sigma = 0.05;
t = linspace(0,1,N)';
f = 10;
y = sin(2*pi*f*t + pi/6) + sigma*randn(N,1);

figure(1); clf;
plot(t,y);
hold on;
plot([0,1], [0, 0], 'k');
grid on

%%
u0 = 0; u1 = sigma; u2 = 0.2; u3 = 1.4;
zc0 = ZC_v2(y, u0);
zc1 = ZC_v2(y, u1);
zc2 = ZC_v2(y, u2);
zc3 = ZC_v2(y, u3);

figure(2); clf;
plot(t, y);
hold on;
plot([0,1], [u0, u0], 'k');
plot([0,1], [u1, -u1; u1, -u1], 'r');
plot([0,1], [u2, -u2; u2, -u2], 'g');
plot([0,1], [u3, -u3; u3, -u3], 'm');
grid on
xlabel('t');
ylabel('y');
title(sprintf('zc0: %d,  zc1: %d,  zc2: %d,  zc3: %d', zc0, zc1, zc2, zc3));
legend('y', 'u0', '', 'u1', '', 'u2', '', 'u3', 'Location', 'northeastoutside');

