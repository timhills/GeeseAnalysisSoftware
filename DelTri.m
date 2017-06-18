 classdef DelTri < handle
	%{
    
    Author: Tim Hills, 9-2-2016
     
    This class calculates the packing fraction of a flock of geese. Make
    sure that the "Current Folder" is Centroid Geese Data in the test
    script.
     
    %}
    properties
        Folder;
        FigureAnalyzed;
        GeesePositionArray;
        NumberOfGeese;
        DTColumnVectors;
        GlobalVolume;
        CollectiveVolume;
        ConvexHullVertices;
        PackingFraction;
        CellPositionArrayX;
        CellPositionArrayY;
        CellPositionArrayZ;
    end
    
    methods
        function obj = DelTri(Date)
            obj.Folder = Date;
        end
        
        function CalculatePackingFraction(obj,FigureName)
            %radius of sphere occupied by average sized goose
            rhs = 0.1625;
            %diameter of sphere occupied by average sized goose
            rhscor = 0.325;
            obj.FigureAnalyzed = FigureName;
            obj.GetFigureData();
            [x, y, z] = obj.DelaunayTriangulation(rhscor);
            obj.ConvexHull();
            obj.PackFrac();
            obj.GraphDT(x,y,z,rhs);
        end
        
        %figure data
        function GetFigureData(obj)
            [Population,X,Y,Z] = GetGraphData1(obj.FigureAnalyzed);
            %Data returned in MATLAB 2017 are doubles
            %{
            %X = cell2mat(avX);
            %Y = cell2mat(avY);
            %Z = cell2mat(avZ);
            %}
            PositionArray = [X;Y;Z];
            obj.GeesePositionArray = PositionArray;
            obj.CellPositionArrayX = num2cell(X);
            obj.CellPositionArrayY = num2cell(Y);
            obj.CellPositionArrayZ = num2cell(Z);
            obj.NumberOfGeese = Population;
        end
        
        %returns the 3-D delaunay triangulation. Each row is a triangle or
        %tetrahedron. Each element is a vertex.
        function [x, y, z] = DelaunayTriangulation(obj, rhscor)
            x = transpose([obj.GeesePositionArray(1,:) ...
                obj.GeesePositionArray(1,:) (obj.GeesePositionArray(1,:) + rhscor) ...
                (obj.GeesePositionArray(1,:) - rhscor) (obj.GeesePositionArray(1,:)) ...
                (obj.GeesePositionArray(1,:))]);

            y = transpose([obj.GeesePositionArray(2,:) ...
                obj.GeesePositionArray(2,:) obj.GeesePositionArray(2,:)...
                obj.GeesePositionArray(2,:) (obj.GeesePositionArray(2,:) + rhscor)...
                (obj.GeesePositionArray(2,:) - rhscor)]);

            z = transpose([(obj.GeesePositionArray(3,:) + rhscor) ...
                (obj.GeesePositionArray(3,:) - rhscor) ...
                (obj.GeesePositionArray(3,:)) (obj.GeesePositionArray(3,:))...
                (obj.GeesePositionArray(3,:)) (obj.GeesePositionArray(3,:))]);

            obj.DTColumnVectors = delaunayTriangulation([x,y,z]); 
        end
        
        function ConvexHull(obj)
           [ConvexHull, Volume] = convexHull(obj.DTColumnVectors);
           obj.ConvexHullVertices = ConvexHull;
           obj.GlobalVolume = Volume;
        end
        
        function GraphDT(obj,x,y,z,rhs)
            close all
            figure
            trisurf(obj.ConvexHullVertices,x,y,z,'FaceAlpha',0.2)
            hold on
            grid on
            axis equal
            j = zeros(1,obj.NumberOfGeese);
            for i = 1:obj.NumberOfGeese    
               scatter3(obj.CellPositionArrayX{i}, obj.CellPositionArrayY{i}, ...
                   obj.CellPositionArrayZ{i});
               [x1, y1, z1] = sphere(50); %coordinates for a 50 by 50 sphere
               j(i) = surfl(rhs * x1 + obj.GeesePositionArray(1,(i)), ...
                   rhs * y1 + obj.GeesePositionArray(2,(i)), rhs ... 
               * z1 + obj.GeesePositionArray(3,(i)));
               set(j(i), 'FaceAlpha', 0.4);
            end
            title([obj.FigureAnalyzed ',' obj.Folder]);
            dim = [.2 .5 .3 .3];
            annotation('textbox',dim,'String',['Packing Fraction: ', num2str(obj.PackingFraction)]...
                ,'FitBoxToText','on');
            xlabel('X-Location [m]');
            ylabel('Y-Location[m]');
            zlabel('Z-Location[m]');
            
            %gcf: get handle on current figure and save figure
            %FolderPath = 'C:\Users\Astex\Documents\MATLAB\Geese Analysis\Packing Fraction\Packing Factor Figures';
            %saveas(gcf, fullfile(FolderPath, obj.FigureAnalyzed), 'fig');
            close all;
        end
        
        function PackFrac(obj)
            obj.CollectiveVolume = 0.02182150603 * obj.NumberOfGeese;
            obj.PackingFraction = obj.CollectiveVolume/obj.GlobalVolume;
        end
        
    end
    
end

