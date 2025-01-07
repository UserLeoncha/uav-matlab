function visualize(hexCenters, points, optimalPath, totalDistance, totalTime)
    figure;
    hold on;
    
    % 绘制六边形网格
    for i = 1:size(hexCenters, 1)
        fill(hexCenters(i,1) + cos(0:pi/3:2*pi), hexCenters(i,2) + sin(0:pi/3:2*pi), 'w', 'EdgeColor', 'black');
    end
    
    % 绘制含有传感器的六边形
    for i = 1:size(points, 1)
        scatter(points(i,1), points(i,2), 'r', 'filled');
    end
    
    % 绘制无人机路径
    plot(optimalPath(:,1), optimalPath(:,2), 'g-', 'LineWidth', 2);
    print('myPlot', '-dpng');  % 保存为PNG图像
    scatter(optimalPath(:,1), optimalPath(:,2), 80, 'g', 'filled');
    
    % 显示总路程和时间
    text(50, -10, sprintf('Total Distance: %.2f, Total Time: %.2f', totalDistance, totalTime), 'FontSize', 12, 'Color', 'black', 'FontWeight', 'bold');
    
    hold off;
end
