function [AveragePositionArray] = PlotAveragePosition(graph)
    openfig(graph,'invisible');
    %gca: get current handle on axis 
    get(gca);
    axesObjs = get(gca, 'Children');
    dataObjs = get(axesObjs, 'Children');
    numberOfGse = length(dataObjs);

    %get raw data from graph
    for j = 1:numberOfGse
        avX{j} = mean(axesObjs(j).XData);
        avY{j} = mean(axesObjs(j).YData);
        avZ{j} = mean(axesObjs(j).ZData);
    end
    close all
    AveragePositionArray = cell2mat([avX;avY;avZ]);
    figure
    plot3(AveragePositionArray(1,:),AveragePositionArray(2,:),AveragePositionArray(3,:),'o')
    grid on
    axis equal
    xlim([(min(AveragePositionArray(1,:)) - 1) (max(AveragePositionArray(1,:)) + 1)])
    ylim([(min(AveragePositionArray(2,:)) - 1) (max(AveragePositionArray(2,:)) + 1)])
    zlim([(min(AveragePositionArray(3,:)) - 1) (max(AveragePositionArray(3,:)) + 1)])
    xlabel('X-Location [m]');
    ylabel('Y-Location [m]');
    zlabel('Z-Location [m]');
    
    %gcf: get handle on current figure and save figure
    FolderPath = 'C:\Users\Astex\Documents\MATLAB\Geese Analysis\Centroid Geese Data';
    saveas(gcf, fullfile(FolderPath, graph), 'fig');
    close all
end
