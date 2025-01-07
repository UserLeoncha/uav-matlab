% 前言

% 这是注释，阐述整个算法结构。
% 整个算法解耦为了三个部分，第一个部分负责数据集生成，第二个部分负责进行算法规划，第三个部分负责evaluate
% 最终对得到的结果进行调用，这是第二个工程，包括对上述两个部分的单次调用与可视化部分。
% 先前我已经积累了一定数量的代码，现在需要进行提炼, 并且进行评估和可视化

% 关于六边形栅格地图的划分与建系，六边形地图有两种划分方法，六边形有六个角和六条边，使角或者边对准y轴。
% 在完成图形划分后需要对每个栅格分配坐标，这与六边形的中心点有关
% 换言之，每个六边形的栅格中心点是一个结构体，含有该点的(x,y)坐标与栅格内点
% 每个六边形均拥有六个邻居，在边对准y轴，以右邻边为x轴的情况下，六边形(0,0)的邻居包括(1,0),(0,1),(-1,1),(-1,0),(0,-1),(1,-1)
% 这里有一个问题，对于一个六边形的邻居们，该怎样确定它们的位置？

% 使用python实现版本单开一个文件
% 本文件夹仅包含matlab算法以及历史版本

% 第一部分 算法规划工程
% generate_database     DIR                             生成数据集函数簇
%                       generate_clustered_points       生成聚类数据集
%                       generate_uniform_points         生成均匀分布数据集
% hexagon_grid.m                                        生成六边形栅格地图，并对每个栅格进行编号(x,y)
% trajectory_planning   DIR                             负责进行路径规划，此时得到的路径应当是一个六边形地图划分算法与对应的顺序列表
%                       TSP_planning                    进行TSP路径规划（可重复，所以不完全是TSP）                                  
% evaluate.m                                            负责对算法进行评估

% 第二部分 可视化与测试评估工程 暂时弃用 
% visualize             DIR
%                       show_once_database.m function   在生成数据集后在一个二维平面上展示出来
%                       show_hexagon_grid.m function    展示栅格绘制结果
%                       show_trajectory.m function      显示路径规划结果
%                       show_evalueate.m function       显示评估结果

% 第三部分 存储曾经的运行结果，并且编号保存
% result                DIR                             按照运行时时间编号进行存储，内容包括两个部分
%                       timestamp_generate              用于生成文件夹名称
%                       202411272004        DIR         使用UTC时间戳作为一次运行的结果存储文件
%                                           picture     十次数据集生成抽样调查结果
%                                           evaluate    各种评估指标可视化图片

% 第四部分 存储先前工程代码
% history               DIR                             存放先前各种功能算法
%                       hellomatlab                     实现了各模块的解耦
%                       matlab_first_version            编写了多个可以运行的脚本

% 第五部分 存储已经生成的数据集
% database              DIR                             存储一些已经生成的csv文件，每两行为一套数据集
%                       two_type_database               200套数据，每两行为一套数据

% 这是两个工程的交汇处，用于调用第一部分的函数，并将返回值作为第二部分函数的输入，展示运算结果
clear; clc;

% 对于整个工程的参数以及说明
mapWidth = 100;     % 地图的宽，即x轴长度
mapHeight = 100;    % 地图的高，即y轴长度
numPoints = 100;    % 传感器生成的点数
radius = 5;         % 六边形栅格的边长
speed = 1;          % 无人机运行的速度


% 将工程中其他文件夹下的函数加入搜索路径
% 假设 'myfunctions' 文件夹与当前工作目录在同一级别
addpath(genpath('generate_database'));
addpath(genpath('trajectory_planning'));
addpath(genpath('visualize'));
addpath(genpath('result'));
addpath(genpath('database'));

% 第一步，生成数据集，分别调用每一种函数100次，本模块用于实现最外层的函数调用，因此需要将后续步骤也纳入考虑范围之内。
% 为了保留数据生成痕迹，需要在result文件夹中新建用于存放本次运行结果的文件夹。提供了一个全局的路径参数 fullPath

% 测试一 测试二       测试文件夹命名情况    打印出文件夹创建情况（可优化为：若文件夹存在，删除后创建）
timestamp = timestamp_generate();
% 构建完整路径
fullPath = fullfile('result', timestamp);

if ~exist(fullPath, 'dir')
    mkdir(fullPath);
    disp(['Folder created: ', fullPath]);
else
    disp(['Folder already exists: ', fullPath]);
end

% 在数据集被生成后应当存储到一个文件中，随后再进行调用，现在内存储备充足
% 对生成的点集进行抽样率为1/10的抽样调查，均匀分布与聚类分布各抽取10张
% 对生成结果可视化后生成jpg图像，存入result文件夹中。


% 测试三 在独立的函数中生成数据并存储到指定文件夹中，生成的数据文件需要同时存储到database与本次运行存储文件夹中
outputDir = 'database';
filePath = fullfile(outputDir, 'two_type.csv');
all_points = zeros(400, 100);
% 生成100次均匀分布的点
for i = 1:100
    points = generate_uniform_points(mapWidth, mapHeight, numPoints);
    all_points(2*i-1, :) = points(1, :);
    all_points(2*i, :) = points(2, :);
end
% 生成100次聚类分布的点
for i = 101:200
    points = generate_clustered_points(mapWidth, mapHeight, numPoints);
    all_points(2*i-1, :) = points(1, :);
    all_points(2*i, :) = points(2, :);
end
% 将所有点写入CSV文件

outputDir = fullfile('result', timestamp, 'two_type.csv');
writematrix(all_points, outputDir, 'Delimiter', ',');

% 测试四 从database文件夹中读取数据并存储到内存中。（可选）


% 测试五 对生成的数据进行抽检率为1/10的抽检，即为生成jpg文件
% 内存中的点集矩阵为all_points
points_A= randperm(100, 10);
points_B = randperm(100, 10) + 100;

outputDir = fullfile('result', timestamp,'/');

for num = points_A
    scatter(all_points(2*num-1, :),all_points(2*num, :), 20, [0.7, 0.7, 1], 'filled');

    filename = strcat(outputDir, num2str(num), '_scatter_plot.png');
    saveas(gcf, filename); % 使用gcf获取当前图形对象并保存
end

for num = points_B
    scatter(all_points(2*num-1, :),all_points(2*num, :), 20, [0.7, 0.7, 1], 'filled');
    
    filename = strcat(outputDir, num2str(num), '_scatter_plot.png');
    saveas(gcf, filename); % 使用gcf获取当前图形对象并保存
end

% 第二步，进行六边形栅格划分
% 第一步已经完成了测试准备以及数据准备，数据可以是立即生成的也可以是历史数据
% 使用六边形栅格坐标转换坐标系，并将转换结果以图的形式表现出来

% 测试六，分配栅格中心点位置，分配节点到栅格中，在二维图像中展示节点和栅格
% 根据一定规则划分六边形栅格

% 第三步 进行算法分析（排序或者路径规划），这一步包含多种规划算法，需要对算法进行。
% 得到栅格划分后






% 第四步 进行评估并计算指标

