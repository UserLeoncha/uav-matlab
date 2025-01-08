clc;clear;
%% write here
% 遗传算法
% 遗传算法存在若干要素与步骤，比如
%

%% parallel
timestamp = timestamp_generate();

% 构建完整路径
if ~exist(timestamp, 'dir')
    mkdir(timestamp);
    disp(['Folder created: ', timestamp]);
else
    disp(['Folder already exists: ', timestamp]);
end

%start(1, timestamp);

parfor i=1:24
   tic;start(i, timestamp);toc;
   disp(['运行时间: ',num2str(toc)]);
end


%% functions
function start(i, timestamp)

Gpoints = 'uniform';  % 节点生成方式 clustered uniform

mapWidth = 100;     % 地图的宽，即x轴长度
mapHeight = 100;    % 地图的高，即y轴长度
numPoints = 100;    % 传感器生成的点数
radius = 5;         % 六边形栅格的边长
% speed = 1;        % 无人机运行的速度

% generate data
% 2 row 100 column
switch Gpoints
    case 'clustered'
        points = generate_clustered_points(mapWidth, mapHeight, numPoints);
    case 'uniform'
        points = generate_uniform_points(mapWidth, mapHeight, numPoints);
end
disp(num2str(i)+" number generate done");

% generate hexagon
[hexCenters, planCenters, planPoints] = hexagon_grid_generator(points, radius, mapWidth, mapHeight);
disp(num2str(i)+" hexagon grid generate done");

%path = gpuga(planCenters, timestamp);
path = advancega(planCenters, timestamp);

disp(num2str(i)+" path generate done");
% draw(hexCenters, planCenters, points, planPoints, path);
end

% advancedga
function path = advancega(planCenters, timestamp)
NP=500;             % 免疫个体数目
G=1000000;           % 最大免疫代数
randnum = 0.7;
    C = planCenters;
    N=size(C,1);                     %TSP问题的规模,即城市数目
    D=zeros(N);                      %任意两个城市距离间隔矩阵
    % 增加到起止两点的距离
    spec=zeros(N,2);
    % 求任意两个城市距离间隔矩阵
    for i=1:N
        for j=1:N
            D(i,j)=((C(i,1)-C(j,1))^2+(C(i,2)-C(j,2))^2)^0.5;
        end
        spec(i,1)=(C(i,1)^2+C(i,2)^2)^0.5;
        spec(i,2)=((C(i,1)-100)^2+(C(i,2)-100)^2)^0.5;
    end
    
    f=zeros(NP,N);                    %用于存储种群
    F = [];                           %种群更新中间存储
    for i=1:NP
        f(i,:)=randperm(N);           %随机生成初始种群
    end
    R = f(1,:);                       %存储最优种群
    
    fitness = zeros(NP,1);            %存储归一化适应度值
    gen = 0;
 
    % 遗传算法循环
    while gen<G
        % advancelen
        len = advleng(NP,D,spec,N,f);
        maxlen = max(len); 
        minlen = min(len);
        
        % 更新最短路径
        rr = find(len==minlen);
        R = f(rr(1,1),:);
    
        % 计算归一化适应度
        for i =1:length(len)
            fitness(i,1) = (1-((len(i,1)-minlen)/(maxlen-minlen+0.001)));
        end
        
        % 选择操作
        nn = 0;
        for i=1:NP
            if fitness(i,1)>=randnum
                nn = nn+1;
                F(nn,:)=f(i,:);
            end
        end
        [aa,bb] = size(F);
       
        while aa<NP
            nnper = randperm(nn);
            A = F(nnper(1),:);
            B = F(nnper(2),:);
        
            % 交叉操作
            W = ceil(N/10);     % 交叉点个数
            p = unidrnd(N-W+1);   % 随机选择交叉范围，从p到p+W
            for i =1:W
                x = find(A==B(p+i-1));
                y = find(B==A(p+i-1));
                temp = A(p+i-1);
                A(p+i-1) =B(p+i-1);
                B(p+i-1) = temp;
                temp = A(x);
                A(x) = B(y);
                B(y) = temp;
            end
        
            % 变异操作
            p1 = floor(1+N*rand());
            p2 = floor(1+N*rand());
            while p1==p2
               p1 = floor(1+N*rand());
               p2 = floor(1+N*rand());
            end
            tmp = A(p1);
            A(p1) = A(p2);
            A(p2) = tmp;
            tmp = B(p1);
            B(p1) = B(p2);
            B(p2) = tmp;
            F = [F;A;B];
            [aa,bb] = size(F);
        end
        if aa>NP
            F = F(1:NP,:);        % 保持种群规模为NP
        end
    f = F;                    % 更新种群
    f(1,:) = R;               % 保留每代最优个体
    clear F;
    gen = gen+1;
    Rlength(gen) = minlen;
    end
path = R;

% 创建第一个图形窗口
figure;
for i = 1:N-1
    plot([C(R(i),1), C(R(i+1),1)], [C(R(i),2), C(R(i+1),2)], 'bo-');
    hold on;
end

title(['优化最短距离：', num2str(minlen)]);
hold off;

% 为第一张图生成文件名并保存
filename1 = sprintf('Path_NP%d_G%d_Iter%d.png', NP, G, i);
filePath1 = fullfile(timestamp, filename1);
saveas(gcf, filePath1);  % 或者使用 print(gcf, '-dpng', filename1);

% 创建第二个图形窗口
figure;
plot(Rlength);
xlabel('迭代次数');
ylabel('目标函数值');
title('适应度进化曲线');

% 为第二张图生成文件名并保存
filename2 = sprintf('Fitness_NP%d_G%d_Iter%d.png', NP, G, i);
filePath2 = fullfile(timestamp, filename2);
saveas(gcf, filePath2);  % 或者使用 print(gcf, '-dpng', filename2);

end

% advance path length function
% calculute the path length
function len = advleng(NP,D,spec,N,f)
    len=zeros(NP,1);                  %存储路径长度
    
    % 计算路径长度
    for i=1:NP
        len(i,1)=spec(f(i,1),1)+spec(f(i,N),2);
        for j=1:(N-1)
            len(i,1)=len(i,1)+D(f(i,j),f(i,j+1));
        end
    end
end

% draw the points and hexagons
function draw(hexCenters, planCenters, points, planPoints, path)
    % use the plot function to draw the image, need use different color to 
    % draw the hexagon girds and the points on the grid
    
    % draw all the points
    plot(points, 'r+', 'MarkerSize', 10);
    
    % draw the grid points
    plot(planCenters);
    
    % draw all the grids
    for i = 1:size(hexCenters, 1)
        fill(hexCenters(i,1) + cos(0:pi/3:2*pi), hexCenters(i,2) + sin(0:pi/3:2*pi), 'w', 'EdgeColor', 'black');
    end
    
    % draw the plan grids
    for i = 1:size(planPoints, 1)
        scatter(planPoints(i,1), planPoints(i,2), 'r', 'filled');
    end
    
    print("-dpng", "myPlot.png");
end

% draw path image
function show_path_map(hexCenters, points, optimalPath, totalDistance, totalTime)
    figure;
    hold on;
    
    % 绘制六边形网格
    for i = 1:size(hexCenters, 1)
        fill(hexCenters(i,1) + cos(0:pi/3:2*pi), hexCenters(i,2) + sin(0:pi/3:2*pi), 'w', 'EdgeColor', 'black');
    end
    
    % 绘制含有传感器的六边形
    for i = 1:size(points, 1)
        scatter(points(i,1), points(i,2), 'r', 'filled');
    end
    
    % 绘制无人机路径
    plot(optimalPath(:,1), optimalPath(:,2), 'g-', 'LineWidth', 2);
    print('myPlot', '-dpng');  % 保存为PNG图像
    scatter(optimalPath(:,1), optimalPath(:,2), 80, 'g', 'filled');
    
    % 显示总路程和时间
    text(50, -10, sprintf('Total Distance: %.2f, Total Time: %.2f', totalDistance, totalTime), 'FontSize', 12, 'Color', 'black', 'FontWeight', 'bold');
    
    hold off;
end

% generate hexagon gird
function [hexCenters, planCenters, planPoints] = hexagon_grid_generator(points, radius, mapWidth, mapHeight)
    % 生成六边形网格并返回含有点的六边形中心列表及其对应的点列表
    hexHeight = sqrt(3) * radius;
    hexWidth = 2 * radius;
    
    % get hexagon row and column
    gridRows = ceil(mapHeight / hexHeight);
    gridCols = ceil(mapWidth / (1.5 * radius));
    
    % 0 row 2 column 0 matrix
    planCenters = zeros(0, 2);

    planPoints = {};
    hexCenters = zeros(0, 2);
    
    for row = 0:gridRows
        for col = 0:gridCols
            cx = col * 1.5 * radius;
            if mod(col, 2) == 0
                cy = row * hexHeight;
            else
                cy = row * hexHeight + hexHeight / 2;
            end
            
            % 存储当前六边形内的点
            currentHexPoints = [];
            
            % 检查是否有点位于六边形内
            for i = 1:size(points, 1)
                dx = points(i,1) - cx;
                dy = points(i,2) - cy;
                % 使用六边形的几何特性来检查点是否在六边形内
                if abs(dy) <= hexHeight/2 && abs(dx) <= radius && (abs(dy) + abs(sqrt(3)*dx)) <= hexHeight
                    currentHexPoints = [currentHexPoints; points(i,1), points(i, 2)];
                end
            end
            % each hexagon center
            hexCenters = [hexCenters; cx, cy];

            if ~isempty(currentHexPoints)
                % 如果当前六边形中有点，则将六边形中心添加到 hexCenters 中
                % 并将当前六边形的点添加到 hexPoints
                planCenters = [planCenters; cx, cy];
                planPoints = [planPoints; currentHexPoints];
            end
         end
    end
end

% generate clustered points
function points = generate_clustered_points(mapWidth, mapHeight, numPoints)
%GENERATE_CLUSTERED_POINTS 聚类分布
% 生成聚类分布的随机点，返回值为多行两列的矩阵
    numClusters = randi([2, 5]);  % 随机生成 2-5 个聚类
    clusterStdX = mapWidth / 10;  % 聚类的标准差（控制聚类点的分布范围）
    clusterStdY = mapHeight / 10;
    
    points = [];
    remainingPoints = numPoints;
    for i = 1:numClusters
        clusterCenterX = mapWidth * rand;
        clusterCenterY = mapHeight * rand;
        
        if i == numClusters
            % 确保最后一个聚类填满所有剩余点
            clusterSize = remainingPoints;
        else
            % 随机分配每个聚类的大小
            clusterSize = randi([1, remainingPoints - (numClusters - i)]);
        end
        
        remainingPoints = remainingPoints - clusterSize;
        
        % 生成聚类内的点
        x = clusterCenterX + randn(1, clusterSize) * clusterStdX;  % 1 行 clusterSize 列
        y = clusterCenterY + randn(1, clusterSize) * clusterStdY;  % 1 行 clusterSize 列
        points = [points; [x', y']];  % 按行追加点，最终为多行两列
    end
end

% generate uniform points
function points = generate_uniform_points(mapWidth, mapHeight, numPoints)
% GENERATE_UNIFORM_POINTS 
% return 100 row 2 column
    x = mapWidth * rand(1, numPoints);  % 1 行 numPoints 列
    y = mapHeight * rand(1, numPoints); % 1 行 numPoints 列
    points = [x', y'];
end

function formattedString = timestamp_generate()
%TIMSTAMP_GENERATE 此处显示有关此函数的摘要
%   此处显示详细说明
% 设置输出格式
timestamp = datetime('now', 'TimeZone', 'UTC') - datetime('1970-01-01 00:00:00', 'TimeZone', 'UTC');
timestamp = seconds(timestamp);
% 将时间戳转换为日期时间对象
dt = datetime(timestamp, 'ConvertFrom', 'posixtime');
% 格式化日期时间为所需字符串格式
formattedString = sprintf('%04d%02d%02d%02d%02d', ...
    year(dt), month(dt), day(dt), hour(dt), minute(dt));
end

