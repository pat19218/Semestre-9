%% IE3038 - Diseño e Innovación en Ingeniería 1
%  Ejemplo de clclustering usando k-means
%  Luis Alberto Rivera

%% ejemplo clase
% load ej_k_means.mat
% 
% figure(1); clf;
% scatter(X(:,1), X(:,2));
% grid on
% 
% m = 1;  % Probar con 1, 2, 3, 4
% [etiq_km, centros_km] = k_means(X, m, 2);

%% ejercicio

load k_means_datos.mat

m = 7;  % Probar con 1, 2, 3, 4
%[etiq_km1, centros_km1] = k_means(X, m, 2);
[etiq_km2, centros_km2] = k_means(X_out, m, 2);
