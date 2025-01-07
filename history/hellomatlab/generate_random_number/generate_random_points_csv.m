% 生成50次均匀分布和50次聚类分布的随机点，并写入CSV文件
% 直接运行此脚本即可生成所需的CSV文件
mapWidth = 100;
mapHeight = 100;
numPoints = 100;  % 每次生成的点数


% 生成50次均匀分布的点
for i = 1:50
    points = random_point_generator(mapWidth, mapHeight, numPoints, 'uniform');
    points = points';
    writematrix(points,'random_points');
end

% 生成50次聚类分布的点
for i = 51:100
    points = random_point_generator(mapWidth, mapHeight, numPoints, 'clustered');
    points = points';
    writematrix(points,'random_points');
end

disp('随机点已生成并写入到 random_points.csv 文件');
