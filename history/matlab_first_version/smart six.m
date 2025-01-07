clear; clc;
N = 100; % 随机点的数量
radius = 5; % 六边形的半径

% 生成二维随机点
x = (100-0)*rand(N,1);
y = (100-0)*rand(N,1);

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
            dx = abs(x(i) - cx);
            dy = abs(y(i) - cy);
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
scatter(x, y, 40, [0.7, 0.7, 1], 'filled');

% 设置图的标题、标签和轴
title('随机点与六边形网格');
xlabel('X');
ylabel('Y');
axis equal;

% 打印包含点的六边形中心点
disp('包含点的六边形中心点:');
disp(hexCenters);

% 完成绘制，关闭 hold
hold off;
