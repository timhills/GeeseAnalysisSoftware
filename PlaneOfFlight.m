classdef PlaneOfFlight < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        AnalysisDate
        Folder
        FigureAnalyzed
        PlaneArea
        NumberOfGeese
        GeesePositionArray
        LeadGoose
        RearGooseOne
        RearGooseTwo
        
    end
    
    methods (Access = public)
        
        function obj = PlaneOfFlight(Date, FileName)
            % Initialize the PDF object
            obj.AnalysisDate = Date;
            obj.FigureAnalyzed = FileName;
        end
        
        %figure data
        function ExtractData(obj)
            % Extract centroid data of a flock      
            [Population,X,Y,Z] = GetGraphData1(obj.FigureAnalyzed);
            obj.GeesePositionArray = [X;Y;Z];
            obj.NumberOfGeese = Population;
            
        end
        
        function FindLeadGoose(obj)
            % lead goose has a special LineWidth property
            FindObj1 = findobj(gca,'LineWidth',5);
            obj.LeadGoose = [FindObj1.XData;FindObj1.YData;FindObj1.ZData];
            
        end
        
        function FindRearGeese(obj)
            % rear geese have special LineWidth properties
            FindObj2 = findobj(gca,'LineWidth',4);
            FindObj3 = findobj(gca,'LineWidth',3);
            obj.RearGooseOne = [FindObj2.XData;FindObj2.YData;FindObj2.ZData];
            obj.RearGooseTwo = [FindObj3.XData;FindObj3.YData;FindObj3.ZData];
            
        end
        
        % Calculate the area of the plane formed by the V-formation.
        function PlaneArea = CalcPlaneArea()
            
        end
        
        % Draw the plane formed by the V-formation.
        function VisPlane(obj)
            CurrentFigureHand = gcf;
            X_Vertex_Geese = [obj.LeadGoose(1),obj.RearGooseOne(1),obj.RearGooseTwo(1)];
            Y_Vertex_Geese = [obj.LeadGoose(2),obj.RearGooseOne(2),obj.RearGooseTwo(2)];
            Z_Vertex_Geese = [obj.LeadGoose(3),obj.RearGooseOne(3),obj.RearGooseTwo(3)];
            plot3(X_Vertex_Geese, Y_Vertex_Geese, Z_Vertex_Geese,'ob','MarkerFaceColor','Blue')
            hold on
            XPositionData = obj.GeesePositionArray(1,:);
            YPositionData = obj.GeesePositionArray(2,:);
            ZPositionData = obj.GeesePositionArray(3,:);
            plot3(XPositionData, YPositionData, ZPositionData,'ob','MarkerFaceColor','Blue')
            fill3(X_Vertex_Geese, Y_Vertex_Geese, Z_Vertex_Geese,'r')
            grid on
            axis equal
            alpha(0.3)
            
            FolderPath = 'C:\Users\Tim\Dropbox\Research\The Auk Ornithological Advances17_18\Plane of Flight Figures';
            saveas(gcf, fullfile(FolderPath, obj.FigureAnalyzed.name), 'fig');
            close all;
            
        end
        
    end
    
end

