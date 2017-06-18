classdef CtVSLg < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        DistanceFromCentroidArray;
        DistanceFromLeadGooseArray;
        FigureAnalyzed;
        AnalysisDate;
        LeadGoose;
        Centroid;
        GeesePositionArray;
        NumOfGeese;
    end
    
    methods
        
        function obj = CtVSLg(Date,FileName)
            obj.AnalysisDate = Date;
            obj.FigureAnalyzed = FileName;
            obj.DistanceFromCentroidArray = [];
            obj.DistanceFromLeadGooseArray = [];
        end
        
        function ExtractData(obj)
            % Extract centroid data of a flock
            obj.FindLeadGoose();       
            [Population,X,Y,Z] = GetGraphData1(obj.FigureAnalyzed);
            obj.GeesePositionArray = [X;Y;Z];
            obj.NumOfGeese = Population;
            
        end
        
        function FindLeadGoose(obj)
            % lead goose has a special LineWidth property
            FindObj1 = findobj(gca,'LineWidth',5);
            obj.LeadGoose = [FindObj1.XData;FindObj1.YData;FindObj1.ZData];
            
        end
        
        function CalculateCentroid(obj)
            % arithmetic mean of position data
            XCentroid = mean(obj.GeesePositionArray(1,:));
            YCentroid = mean(obj.GeesePositionArray(2,:));
            ZCentroid = mean(obj.GeesePositionArray(3,:));
            obj.Centroid = [XCentroid;YCentroid;ZCentroid];
            
        end
        
        function CalculateDistanceFromCentroid(obj)
            % Populate the data array that contains each flock member's
            % distance away from the flock's centroid
            for i = 1:obj.NumOfGeese
               CtDistance = sqrt(sum((obj.GeesePositionArray(:,i) - obj.Centroid).^2));
               obj.DistanceFromCentroidArray = [obj.DistanceFromCentroidArray,...
                   CtDistance];
            end
            
        end
        
        function CalculateDistanceFromLeadGoose(obj)
            % Populate the data array that contains each flock member's
            % distance away from the flock's centroid
            for i = 1:obj.NumOfGeese
               CtDistance = sqrt(sum((obj.GeesePositionArray(:,i) - obj.LeadGoose).^2));
               obj.DistanceFromLeadGooseArray = [obj.DistanceFromLeadGooseArray,...
                   CtDistance];
            end
            
        end
        
        function SortData(obj)
            % Sort obj.DistanceFromLeadGooseArray from smallest value to
            % its largest value and organize it's corresponding
            % obj.DistanceFromCentroidArray value according to the same
            % index.
            [obj.DistanceFromLeadGooseArray,OrganizedIndexArray] = sort(obj.DistanceFromLeadGooseArray);
            
            % Reorganize obj.DistanceFromCentroidArray
            TempCentroidDistanceArray = [];
            
            for DataPosition = 1:obj.NumOfGeese 
                
                TempCentroidDistanceArray = [TempCentroidDistanceArray,...
                    obj.DistanceFromCentroidArray(OrganizedIndexArray(DataPosition))];
                
            end
            
            % Reset obj.DistanceFromCentroidArray
            obj.DistanceFromCentroidArray = TempCentroidDistanceArray;
            
        end
        
        function GenerateFigure(obj)
            % Plot each flock member's distance from the flock's centroid
            % as a function of that same member's distance from the lead
            % goose
            figure('Visible','off');
            plot(obj.DistanceFromLeadGooseArray,obj.DistanceFromCentroidArray,...
                '-ob','LineWidth',2);
            
        end
        
    end
    
end

