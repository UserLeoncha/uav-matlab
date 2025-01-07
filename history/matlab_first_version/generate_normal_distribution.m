% 设置二维平面的尺寸
x_max = 100;
y_max = 100;

% 设置正态分布的中心点和标准差
x0 = 50; % 中心点的 x 坐标
y0 = 50; % 中心点的 y 坐标
sigma_x = 10; % x 方向的标准差
sigma_y = 15; % y 方向的标准差

% 生成 n 个随机点
n = 100; % 生成的点的数量
x = normrnd(x0, sigma_x, [n, 1]); % 生成 x 方向的正态分布点
y = normrnd(y0, sigma_y, [n, 1]); % 生成 y 方向的正态分布点

% 可视化生成的点
figure;
scatter(x, y, 'filled');
xlim([0, x_max]);
ylim([0, y_max]);
title('二维平面上的正态分布');
xlabel('X');
ylabel('Y');
axis equal;
