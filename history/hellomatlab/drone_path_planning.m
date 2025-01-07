function [path, totalDistance, totalTime] = drone_path_planning(hexCenters, startPoint, endPoint, communicationRadius, speed)
    n = size(hexCenters, 1);
    visited = false(n, 1);
    path = zeros(n + 2, 2); % 路径
    path(1,:) = startPoint; % 起点
    totalDistance = 0;
    
    currentIdx = -1;
    for i = 2:n+1
        minDist = inf;
        nextIdx = -1;
        for j = 1:n
            if ~visited(j)
                if currentIdx == -1
                    dist = norm(startPoint - hexCenters(j,:));
                else
                    dist = norm(hexCenters(currentIdx,:) - hexCenters(j,:));
                end
                if dist < minDist
                    minDist = dist;
                    nextIdx = j;
                end
            end
        end
        currentIdx = nextIdx;
        path(i,:) = hexCenters(currentIdx,:);
        visited(currentIdx) = true;
        totalDistance = totalDistance + minDist;
    end
    totalDistance = totalDistance + norm(endPoint - path(n+1,:));
    path(n+2,:) = endPoint;
    
    % 计算总时间
    totalTime = totalDistance / speed;
end
