function points = generate_clustered_points(mapWidth, mapHeight, numPoints)
%GENERATE_CLUSTERED_POINTS 聚类分布
% 生成聚类分布的随机点，返回值为
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
        points = [points, [x; y]];  % 按列追加点，最终为 2 行多列
    end
end

