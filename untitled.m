
mapWidth = 100;     % 地图的宽，即x轴长度
mapHeight = 100;    % 地图的高，即y轴长度
numPoints = 100;    % 传感器生成的点数

x = mapWidth * rand(numPoints, 1);  % 1 行 numPoints 列
y = mapHeight * rand(numPoints, 1); % 1 行 numPoints 列
points = [x, y];