clear; clc;

% ---------------------
% 配置参数
% ---------------------
N = 100; % 随机点数量
radius = 5; % 六边形半径
x_max = 100; % x 轴最大值
y_max = 100; % y 轴最大值
startPoint = [0, 0]; % 起点
endPoint = [100, 100]; % 终点

% ---------------------
% 生成随机点
% ---------------------
points = generate_random_points(N, x_max, y_max);

% ---------------------
% 六边形网格参数
% ---------------------
hexHeight = sqrt(3) * radius; % 六边形高度
hexWidth = 2 * radius;        % 六边形宽度

% 计算网格行列数
gridRows = ceil(y_max / hexHeight);
gridCols = ceil(x_max / (1.5 * radius));

% 初始化保存含有点的六边形中心的列表
hexCenters = [];

% 绘制图形
figure;
hold on;

% 定义绘制六边形的函数，增加透明度参数
drawHexagon = @(cx, cy, r, color, alphaVal) fill(cx + r * cos(0:pi/3:2*pi), cy + r * sin(0:pi/3:2*pi), color, 'EdgeColor', 'black', 'FaceAlpha', alphaVal);

% 遍历六边形网格，绘制六边形
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
        alphaVal = 0.3; % 六边形透明度

        % 判断哪些点在六边形内
        for i = 1:N
            % 计算点到六边形中心的距离
            dx = abs(points(i,1) - cx);
            dy = abs(points(i,2) - cy);
            % 判断点是否在六边形的外接圆内
            if (dx^2 + dy^2) <= radius^2
                % 含有点的六边形设为红色
                color = 'r';
                alphaVal = 0.7; % 含有点的六边形透明度较低
                hexCenters = [hexCenters; cx, cy]; % 保存六边形中心点
                break;
            end
        end
        
        % 绘制六边形
        drawHexagon(cx, cy, radius, color, alphaVal);
    end
end

% 绘制二维随机点，使用浅蓝色
scatter(points(:,1), points(:,2), 40, [0.7, 0.7, 1], 'filled');

% 设置图的标题、标签和轴
title('随机点与六边形网格');
xlabel('X');
ylabel('Y');
axis equal;

% ---------------------
% 旅行商问题求解算法
% ---------------------

% 改进的贪心算法：选择经过含有点的六边形中心，而非具体点
function path = greedyTSP_hex(hexCenters, startPoint, endPoint)
    n = size(hexCenters, 1);
    visited = false(n, 1);
    path = zeros(n + 2, 2); % 用于保存路径，包含起点和终点
    path(1,:) = startPoint; % 初始化起点
    currentIdx = -1; % 当前点为起点
    
    % 最近邻排序六边形中心点
    for i = 2:n+1
        % 寻找离当前点最近的未访问六边形中心
        minDist = inf;
        nextIdx = -1;
        for j = 1:n
            if ~visited(j)
                if currentIdx == -1
                    dist = norm(startPoint - hexCenters(j,:)); % 起点到六边形中心的距离
                else
                    dist = norm(hexCenters(currentIdx,:) - hexCenters(j,:)); % 当前点到其他六边形中心的距离
                end
                if dist < minDist
                    minDist = dist;
                    nextIdx = j;
                end
            end
        end
        % 更新路径和状态
        currentIdx = nextIdx;
        path(i,:) = hexCenters(currentIdx,:);
        visited(currentIdx) = true;
    end
    
    % 最后到达终点
    path(n+2,:) = endPoint;
end

% 运行改进的贪心算法，求解最短路径
optimalPath = greedyTSP_hex(hexCenters, startPoint, endPoint);

% 绘制最短路径
plot(optimalPath(:,1), optimalPath(:,2), 'g-', 'LineWidth', 2);
scatter(optimalPath(:,1), optimalPath(:,2), 80, 'g', 'filled'); % 标记路径点

% 打印含有点的六边形中心点
disp('含有点的六边形中心点:');
disp(hexCenters);

% 完成绘制，关闭 hold
hold off;
