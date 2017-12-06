function [numberOfGse,x,y,z] = GetGraphData1(graph)
    graph;
    get(gca);
    axesObjs = get(gca, 'Children');
    dataObjs = get(axesObjs, 'Children');
    
    
    % obsolete in MATLAB 2017
    numberOfGse = length(dataObjs);

    %get raw data from graph
    %x = cell(1,numberOfGse);
    %y = cell(1,numberOfGse);
    %z = cell(1,numberOfGse);
    %{
    for j = 1:numberOfGse
        x(j) = axesObjs(j).XData;
        y(j) = axesObjs(j).YData;
        z(j) = axesObjs(j).ZData;
        avX{j} = mean(axesObjs(j).XData);
        avY{j} = mean(axesObjs(j).YData);
        avZ{j} = mean(axesObjs(j).ZData);
    end
    %flock = cell2mat([x;y]);
    %}
    
    % updated to be compatible with MATLAB 2017
    x = axesObjs(1).XData;
    y = axesObjs(1).YData;
    z = axesObjs(1).ZData;
    numberOfGse = length(x);
    
    %[Y, I] = sort(flock(2,:));
    %flock = flock(:,I);
end
