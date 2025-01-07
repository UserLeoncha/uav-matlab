function points = generate_uniform_points(mapWidth, mapHeight, numPoints)
%GENERATE_UNIFORM_POINTS 均匀分布
% 生成均匀分布的随机点，返回值为
    x = mapWidth * rand(1, numPoints);  % 1 行 numPoints 列
    y = mapHeight * rand(1, numPoints); % 1 行 numPoints 列
    points = [x; y];  % 两行多列
end
