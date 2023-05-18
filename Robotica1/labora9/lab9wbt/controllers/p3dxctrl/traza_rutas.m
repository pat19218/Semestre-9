%% Cargar archivos
load('lab9map.mat');
map = double(map);


start = [0,-4];

goal1 = [-4; 0];
goal2 = [3; -4];
goal3 = [1; 4];
goal4 = [3; 4];
goal_points = [goal1, goal2, goal3, goal4];


inflar = 21;


figure(1);
goald = [250+goal4*(500/10)];
start1 = 250+start*(500/10);
map1 = flip(map);
ds = Dstar(map1, 'inflate', inflar);
ds.plan(goald);
ds.plot();
trayectoria1 = ds.query(start1, 'animate');

%%
figure(2)
goalp = [250+goal2*(500/10)];
start2 = 250+start*(500/10);
map2 = flip(map);
prm = PRM(map2, 'inflate', inflar-5);
prm.plan()
trayectoria2 = prm.query(start2, goalp);
prm.plot()
%plot(a(:,1)',a(:,2)')
save('trayectorias.mat','trayectoria1','trayectoria2')