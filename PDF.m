classdef PDF < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        LeadGoose;
        RearGooseOne;
        RearGooseTwo;
        PDDistanceOne;
        PDDistanceTwo;
        FigureAnalyzed;
        AnalysisDate;
        GeesePositionArray;
        NumOfGeese;
        
    end
    
    methods
        
        function obj = PDF(Date,FileName)
            % Initialize the PDF object
            obj.AnalysisDate = Date;
            obj.FigureAnalyzed = FileName;
            
        end
        
        function ExtractData(obj)
            % Extract centroid data of a flock      
            [Population,X,Y,Z] = GetGraphData1(obj.FigureAnalyzed);
            obj.GeesePositionArray = [X;Y;Z];
            obj.NumOfGeese = Population;
            
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
        
        function CalculatePairDistributionDistance(obj)
            % Calculate the distance between the distance between the two
            % rear geese and the lead goose
            obj.PDDistanceOne = sqrt((obj.RearGooseOne - obj.LeadGoose).^2);
            obj.PDDistanceTwo = sqrt((obj.RearGooseTwo - obj.LeadGoose).^2);
            
        end
        
    end
    
end

