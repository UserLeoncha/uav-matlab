function hexCenters = hexagon_grid_generator(points, radius, mapWidth, mapHeight)
    % 生成六边形网格并返回含有点的六边形中心列表
    hexHeight = sqrt(3) * radius;
    hexWidth = 2 * radius;
    
    gridRows = ceil(mapHeight / hexHeight);
    gridCols = ceil(mapWidth / (1.5 * radius));
    
    hexCenters = [];
    
    for row = 0:gridRows
        for col = 0:gridCols
            cx = col * 1.5 * radius;
            if mod(col, 2) == 0
                cy = row * hexHeight;
            else
                cy = row * hexHeight + hexHeight / 2;
            end
            
            for i = 1:size(points, 1)
                dx = abs(points(i,1) - cx);
                dy = abs(points(i,2) - cy);
                if (dx^2 + dy^2) <= radius^2
                    hexCenters = [hexCenters; cx, cy];
                    break;
                end
            end
        end
    end
end
