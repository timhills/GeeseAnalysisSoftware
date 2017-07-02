classdef CentroidDataToCSV < handle
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        LeadGoose
        EndGooseOne
        EndGooseTwo
        RemainingGeese
        AnalysisDate
        
    end
    
    methods
        
        function obj = CentroidDataToCSV(Date)
            obj.AnalysisDate = Date;
            
        end

        function LeadGoose = FindLeadGoose(obj)
            % lead goose has a special LineWidth property
            FindObj1 = findobj(gca,'LineWidth',5);
            obj.LeadGoose = [FindObj1.XData;FindObj1.YData;FindObj1.ZData];
            LeadGoose = obj.LeadGoose;
            
        end
        
        function RearGeese = FindEndGeese(obj)
            % End geese goose has a special LineWidth property
            FindObj1 = findobj(gca,'LineWidth',4);
            FindObj2 = findobj(gca,'LineWidth',3);
            
            obj.EndGooseOne = [FindObj1.XData;FindObj1.YData;FindObj1.ZData];
            obj.EndGooseTwo = [FindObj2.XData;FindObj2.YData;FindObj2.ZData];
            
            RearGeese = [obj.EndGooseOne,obj.EndGooseTwo];
            
        end
        
        function RemainingGeese = GetRemainingGeese(obj)
            % Get x, y and z data from flock members that are not the lead
            % or rear geese
            FindObj = findobj(gca,'LineWidth',0.5);
            obj.RemainingGeese = [FindObj(2).XData;FindObj(2).YData;FindObj(2).ZData];
            RemainingGeese = obj.RemainingGeese;
            
        end
        
    end
    
end

