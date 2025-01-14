clc;clear;

% parallel
timestamp = datetime('now', 'TimeZone', 'UTC') - datetime('1970-01-01 00:00:00', 'TimeZone', 'UTC');
timestamp = seconds(timestamp);
% 将时间戳转换为日期时间对象
dt = datetime(timestamp, 'ConvertFrom', 'posixtime');
% 格式化日期时间为所需字符串格式
timestamp = sprintf('%04d%02d%02d%02d%02d', ...
    year(dt), month(dt), day(dt), hour(dt), minute(dt));

% 构建完整路径
if ~exist(timestamp, 'dir')
    mkdir(timestamp);
    disp(['Folder created: ', timestamp]);
else
    disp(['Folder already exists: ', timestamp]);
end

% 设置运行模式
runmodel = 'once';
switch runmodel
    case 'once'
        start(1, timestamp);
    case 'para'
        parfor i=1:8
            tic;start(i, timestamp);toc;
            disp(['运行时间: ',num2str(toc)]);
        end
end
% 得到运行结果后进行比较并保存

% 对结果进行绘图并保存数据
% 保存的数据范围包括

% functions
function start(i, timestamp)
mapWidth = 100;     % 地图的宽，即x轴长度
mapHeight = 100;    % 地图的高，即y轴长度
numPoints = 100;    % 传感器生成的点数
radius = 5;         % 六边形栅格的边长

x = mapWidth * rand(numPoints, 1);  % 1 行 numPoints 列
y = mapHeight * rand(numPoints, 1); % 1 行 numPoints 列
points = [x, y];

disp(num2str(i)+" number generate done");
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
            % 如果当前六边形中有点，则将六边形中心添加到 hexCenters 中 并将当前六边形的点添加到 hexPoints
            planCenters = [planCenters; cx, cy];
            planPoints = [planPoints; currentHexPoints];
        end
    end
end
disp(num2str(i)+" hexagon grid generate done");

% 该程序段需要的参数包括：
% 参与排序的列表： hexCenter
% 地图的尺寸
NP=50;             % 种群数目
SAVE=20;           % 免疫种群数目
G=1000;            % 最大免疫代数

Cell = planCenters;
[N, ~] = size(planCenters);
Num=size(Cell,1);                     %TSP问题的规模,即城市数目
Distance=zeros(Num);                  %任意两个城市距离间隔矩阵
% 增加到起止两点的距离
spec=zeros(Num,2);
% 求任意两个城市距离间隔矩阵
for i=1:Num
    for j=1:Num
        Distance(i,j)=((Cell(i,1)-Cell(j,1))^2+(Cell(i,2)-Cell(j,2))^2)^0.5;
    end
    spec(i,1)=(Cell(i,1)^2+Cell(i,2)^2)^0.5;
    spec(i,2)=((Cell(i,1)-100)^2+(Cell(i,2)-100)^2)^0.5;
end

pop=zeros(NP,Num);                    %用于存储种群
poptemp = [];                        %种群更新中间存储
for i=1:NP
    pop(i,:)=randperm(Num);           %随机生成初始种群
end

len=zeros(NP,1);                  %存储路径长度

% 计算路径长度
for i=1:NP
    len(i,1)=spec(pop(i,1),1)+spec(pop(i,N),2);
    for j=1:(N-1)
        len(i,1)=len(i,1)+Distance(pop(i,j),pop(i,j+1));
    end
end

% 选择操作
[~, sortedIndices] = sort(len, 'descend');     % 对路径长度进行排序，并获取排序后的索引
poptemp = pop(sortedIndices, :);    % 使用排序后的索引来重新排列原始的二维数组
poptemp = poptemp(1:SAVE, :);

% 最优结果存储
bestpop = pop(1,:);
bestlen = [G, 1];

% 遗传算法循环
gen = 0;
while gen<G
    % rank the length fix advancelen
    len=zeros(NP,1);                  %存储路径长度

    % 计算路径长度
    for i=1:NP
        len(i,1)=spec(pop(i,1),1)+spec(pop(i,N),2);
        for j=1:(N-1)
            len(i,1)=len(i,1)+Distance(pop(i,j),pop(i,j+1));
        end
    end

    % 选择操作
    [~, sortedIndices] = sort(len, 'descend');     % 对路径长度进行排序，并获取排序后的索引
    poptemp = pop(sortedIndices, :);    % 使用排序后的索引来重新排列原始的二维数组
    poptemp = poptemp(1:SAVE, :);
    nn = size(poptemp, 1);

    %变异选择操作
    aa = size(poptemp,1);
    while aa<NP
        nnper = randperm(nn);
        A = poptemp(nnper(1),:);
        B = poptemp(nnper(2),:);

        % 交叉操作
        W = ceil(Num/10);     % 交叉点个数
        p = unidrnd(Num-W+1);   % 随机选择交叉范围，从p到p+W
        for i =1:W
            x = find(A==B(p+i-1));
            y = find(B==A(p+i-1));
            swap(A(p+i-1), B(p+i-1));
            swap(A(x), B(y));
        end

        % 变异操作
        p1 = floor(1+Num*rand());
        p2 = floor(1+Num*rand());
        while p1==p2
            p1 = floor(1+Num*rand());
            p2 = floor(1+Num*rand());
        end
        swap(A(p1), A(p2));
        swap(B(p1), B(p2));
        poptemp = [poptemp;A;B];
        aa = size(poptemp, 1);
    end
    if aa>NP
        poptemp = poptemp(1:NP,:);        % 保持种群规模为NP
    end
    pop = poptemp;                    % 更新种群
    pop(1,:) = bestpop;               % 保留每代最优个体
    clear poptemp;
    gen = gen+1;
    bestlen(gen) = minlen;
end

path = bestpop;

% 创建第一个图形窗口
figure;
for i = 1:Num-1
    plot([Cell(bestpop(i),1), Cell(bestpop(i+1),1)], [Cell(bestpop(i),2), Cell(bestpop(i+1),2)], 'bo-');
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
plot(bestlen);
xlabel('迭代次数');
ylabel('目标函数值');
title('适应度进化曲线');

% 为第二张图生成文件名并保存
filename2 = sprintf('Fitness_NP%d_G%d_Iter%d.png', NP, G, i);
filePath2 = fullfile(timestamp, filename2);
saveas(gcf, filePath2);  % 或者使用 print(gcf, '-dpng', filename2);

disp(num2str(i)+" path generate done");
% draw(hexCenters, planCenters, points, planPoints, path);
end

function [A, B] = swap(A, B)
temp = A;
A = B;
B = temp;
end

