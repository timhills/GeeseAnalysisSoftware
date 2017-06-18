classdef NND < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Folder;
        FigureAnalyzed;
        GeesePositionArray;
        NumberOfGeese;
        CellPositionArrayX;
        CellPositionArrayY;
        CellPositionArrayZ;
        NNDArray;
    end
    
    methods
        function obj = NND(FolderName)
            obj.Folder = FolderName;
        end
        function CalculateNND(obj,FigureName)
            obj.FigureAnalyzed = FigureName;
            obj.GetFigureData();
            obj.NearestNeighborDistance(obj.GeesePositionArray, obj.NumberOfGeese);
        end
        function GetFigureData(obj)         
            [Population,X,Y,Z] = GetGraphData1(obj.FigureAnalyzed);
            % Values returned from figure in MATLAB 2017 are doubles
            %{
            X = cell2mat(avX);
            Y = cell2mat(avY);
            Z = cell2mat(avZ);
            %}
            obj.CellPositionArrayX = num2cell(X);
            obj.CellPositionArrayY = num2cell(Y);
            obj.CellPositionArrayZ = num2cell(Z);
            PositionArray = [X;Y;Z];
            obj.GeesePositionArray = PositionArray;
            obj.NumberOfGeese = Population;
        end
        function NearestNeighborDistance(obj, Flock, NumberOfGeese)
            %retrieve nearest neighbor distance of each goose with respect to its
            %neighbor
            nnd = zeros(1,NumberOfGeese);
            diffX = zeros(1,NumberOfGeese);
            diffY = zeros(1,NumberOfGeese);
            diffZ = zeros(1,NumberOfGeese);
            %figure; %used for visualization of NND
            for k = 1:NumberOfGeese

                for i = 1:NumberOfGeese
                    diffX(i) = Flock(1,k) - Flock(1,i);
                    diffY(i) = Flock(2,k) - Flock(2,i);
                    diffZ(i) = Flock(3,k) - Flock(3,i);
                end

                val = [diffX; diffY; diffZ];
                nn = zeros(1,length(val));
                minValue = 10e+07;
                for i = 1:length(val)
                    nn(i) = sum(abs(val(:,i)));
                    if (nn(i) ~= 0) && nn(i) < minValue
                        minValue = nn(i);
                        j = i;
                    end
                end
                nnd(k) = sqrt(sum((Flock(:,k) - Flock(:,j)).^2));
                %{
                %the following code is used to visually demonstrate what
                %the NND for a flock is
                X = [Flock(1,k),Flock(1,j)];
                Y = [Flock(2,k),Flock(2,j)];
                Z = [Flock(3,k),Flock(3,j)];
                plot3(X,Y,Z,'-o');
                hold on;
                %}
            end
            obj.NNDArray = nnd;
        end
    end
    
end

