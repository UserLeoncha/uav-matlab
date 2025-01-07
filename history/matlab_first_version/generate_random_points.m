function points = generate_random_points(N, x_max, y_max)
    % 生成二维随机点
    % 输入:
    %   N: 生成点的数量
    %   x_max: x 轴的最大值
    %   y_max: y 轴的最大值
    % 输出:
    %   points: [N x 2] 的随机点矩阵

    x = (x_max - 0) * rand(N, 1);
    y = (y_max - 0) * rand(N, 1);
    points = [x, y]; % 将 x 和 y 组合成二维点的矩阵
end

function points = generate_normal_distribution(N,x_max,y_max)
    x = normrnd(x0, sigma_x, [n, 1]); % 生成 x 方向的正态分布点
    y = normrnd(y0, sigma_y, [n, 1]); % 生成 y 方向的正态分布点
    points = [x,y];
end