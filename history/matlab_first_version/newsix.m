clear; clc;
N = 100; % 随机点的数量
radius = 5; % 六边形的半径

% 生成二维随机点，起点 (0,0)，终点 (100,100)
x = (100-0)*rand(N,1);
y = (100-0)*rand(N,1);
points = [x, y]; % 仅生成中间的随机点

startPoint = [0, 0]; % 起点
endPoint = [100, 100]; % 终点

% 六边形网格参数
hexHeight = sqrt(3) * radius; % 六边形的高度
hexWidth = 2 * radius;        % 六边形的宽度

% 计算网格的行列数
gridRows = ceil(100 / hexHeight);
gridCols = ceil(100 / (1.5 * radius));

% 初始化保存包含点的六边形中心的列表
hexCenters = [];

% 绘制图形
figure;
hold on;

% 定义一个绘制六边形的函数，增加透明度参数
drawHexagon = @(cx, cy, r, color, alphaVal) fill(cx + r * cos(0:pi/3:2*pi), cy + r * sin(0:pi/3:2*pi), color, 'EdgeColor', 'black', 'FaceAlpha', alphaVal);

% 遍历六边形网格，先绘制六边形
for row = 0:gridRows
    for col = 0:gridCols
        % 计算每个六边形的中心位置
        cx = col * 1.5 * radius;
        if mod(col, 2) == 0
            cy = row * hexHeight;
        else
            cy = row * hexHeight + hexHeight / 2;
        end
        
        % 初始化六边形颜色为白色，透明度较高
        color = 'w';
        alphaVal = 0.3; % 设置六边形的透明度
        
        % 判断哪些点在该六边形内
        for i = 1:N
            % 计算点到六边形中心的距离
            dx = abs(points(i,1) - cx);
            dy = abs(points(i,2) - cy);
            % 判断点是否在六边形的外接圆内（半径为5）
            if (dx^2 + dy^2) <= radius^2
                % 如果有点在六边形内，保存该六边形的中心并设为红色
                color = 'r';
                alphaVal = 0.7; % 含有点的六边形透明度较低
                hexCenters = [hexCenters; cx, cy]; % 保存六边形中心点
                break; % 一旦发现点，停止检查其余点
            end
        end
        
        % 绘制六边形，透明度根据是否含有点变化
        drawHexagon(cx, cy, radius, color, alphaVal);
    end
end

% 绘制二维随机点，使用浅蓝色绘制并保证在六边形上方
scatter(points(:,1), points(:,2), 40, [0.7, 0.7, 1], 'filled');

% 设置图的标题、标签和轴
title('随机点与六边形网格');
xlabel('X');
ylabel('Y');
axis equal;

% ---------------------
% 旅行商问题求解算法
% ---------------------

% 贪心算法，但不对起点和终点排序
function path = greedyTSP(points, startPoint, endPoint)
    n = size(points, 1);
    visited = false(n, 1);
    path = zeros(n + 2, 2); % 用于保存路径，包含起点和终点
    path(1,:) = startPoint; % 初始化起点
    currentIdx = -1; % 当前点为起点
    
    % 最近邻排序中间点
    for i = 2:n+1
        % 寻找离当前点最近的未访问点
        minDist = inf;
        nextIdx = -1;
        for j = 1:n
            if ~visited(j)
                if currentIdx == -1
                    dist = norm(startPoint - points(j,:)); % 起点到点的距离
                else
                    dist = norm(points(currentIdx,:) - points(j,:)); % 当前点到其他点的距离
                end
                if dist < minDist
                    minDist = dist;
                    nextIdx = j;
                end
            end
        end
        % 更新路径和状态
        currentIdx = nextIdx;
        path(i,:) = points(currentIdx,:);
        visited(currentIdx) = true;
    end
    
    % 最后到达终点
    path(n+2,:) = endPoint;
end

% 运行贪心算法，求解最短路径
optimalPath = greedyTSP(points, startPoint, endPoint);

% 绘制最短路径
plot(optimalPath(:,1), optimalPath(:,2), 'g-', 'LineWidth', 2);
scatter(optimalPath(:,1), optimalPath(:,2), 80, 'g', 'filled'); % 标记路径点

% 打印包含点的六边形中心点
disp('包含点的六边形中心点:');
disp(hexCenters);

% 完成绘制，关闭 hold
hold off;
