clear; clc;

% 参数配置
mapWidth = 100;
mapHeight = 100;

numPoints = 100;

radius = 5;

communicationRadius = 10;
speed = 1;
iterations = 100;
distributionType = 'uniform';

% 结果保存
distances = zeros(iterations, 1);
times = zeros(iterations, 1);

numbertype = ["uniform","clustered"];

for number = numbertype
for i = 1:iterations
    % 生成随机点
    points = random_point_generator(mapWidth, mapHeight, numPoints, distributionType);
    
    % 生成六边形网格
    hexCenters = hexagon_grid_generator(points, radius, mapWidth, mapHeight);
    
    % 规划无人机路径
    [optimalPath, totalDistance, totalTime] = drone_path_planning(hexCenters, [0, 0], [100, 100], communicationRadius, speed);
    
    % 保存结果
    distances(i) = totalDistance;
    times(i) = totalTime;
end
end

% 可视化运行的结果
visualize(hexCenters, points, optimalPath, totalDistance, totalTime);

hold off;
plot(distances,times,".");
title("sum");

% 打印平均结果
fprintf('平均总路程：%.2f\n', mean(distances));
fprintf('平均耗时时间：%.2f\n', mean(times));
