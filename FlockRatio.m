classdef FlockRatio < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        LeadGoose;
        EndGooseOne;
        EndGooseTwo;
        Ratio;
        AnalysisData;
        AnalyzedFigure;
        SeperationVector;
        GeesePositionArray;
        NumOfGeese;
        DistanceFromGooseToSepVector;
        NumofLeftGeese;
        NumofRightGeese;
        
    end
    
    methods
        
        function obj = FlockRatio(Date,FigName)
            % Set analysis date and .fig name
            obj.AnalysisData = Date;
            obj.AnalyzedFigure = FigName;
            obj.DistanceFromGooseToSepVector = [];
            obj.NumofLeftGeese = 0;
            obj.NumofRightGeese = 0;
            
        end
        
        function FindLeadGoose(obj)
            % lead goose has a special LineWidth property
            FindObj1 = findobj(gca,'LineWidth',5);
            obj.LeadGoose = [FindObj1.XData;FindObj1.YData;FindObj1.ZData];
            
        end
        
        function FindEndGeese(obj)
            % End geese goose has a special LineWidth property
            FindObj1 = findobj(gca,'LineWidth',4);
            FindObj2 = findobj(gca,'LineWidth',3);
            
            obj.EndGooseOne = [FindObj1.XData FindObj1.YData FindObj1.ZData];
            obj.EndGooseTwo = [FindObj2.XData FindObj2.YData FindObj2.ZData];
            
        end
        
        function CalculateDistanceFromPtToLine(obj)
            % Calculate the distance from a goose' centroid to the
            % seperation vector. Exclude the lead goose from the
            % calculation
            for i = 1:obj.NumOfGeese
                
                GooseToLGVector = obj.GeesePositionArray(:,i) - obj.LeadGoose;

                obj.DistanceFromGooseToSepVector = [obj.DistanceFromGooseToSepVector,...
                    norm(cross(obj.SeperationVector,GooseToLGVector))/norm(obj.SeperationVector)];
                
            end
            
        end
        
        function RemoveLeadGoose(obj)
            % Remove the lead goose position from the flock array
            [~,TempSize] = size(obj.GeesePositionArray);
            
            i = 1;
            
            while obj.NumOfGeese == TempSize
                
                if obj.GeesePositionArray(:,i) == obj.LeadGoose
                    
                    obj.GeesePositionArray(:,i) = [];
                    
                    % Redefine obj.NumofGeese
                    [~,obj.NumOfGeese] = size(obj.GeesePositionArray);
                    
                end
                
                i = i + 1;
                
            end
            
        end
        
        function CalculateFlockRatio(obj)
            % Calculate the ratio of left geese to right geese, or left to
            % right (whatever produces a ratio greater than or equal to 1)
            if obj.NumofLeftGeese/obj.NumofRightGeese >= 1
                
                obj.Ratio = obj.NumofLeftGeese/obj.NumofRightGeese;
                
            else
                
                obj.Ratio = obj.NumofRightGeese/obj.NumofLeftGeese;
                
            end
            
        end
        
        function OrganizeFlock(obj)
            % Seperate geese to the left or right leg of the flock
            % according to how far they are away from the seperation vector
            for i = 1:obj.NumOfGeese
               
                if obj.DistanceFromGooseToSepVector(i) <= 1
                   
                    obj.NumofRightGeese = obj.NumofRightGeese + 1;
                    
                else
                    obj.NumofLeftGeese = obj.NumofLeftGeese + 1;
                    
                end
                
            end
            
        end
        
        function CalculateSepVector(obj)
            % Calculate the equation for the vector drawn between a rear
            % goose and the lead goose (vector == seperation vector)
            obj.SeperationVector = obj.EndGooseOne'-obj.LeadGoose;
            
        end
        
        function ExtractData(obj)
            % Extract centroid data of a flock
            [Population,X,Y,Z] = GetGraphData1(obj.AnalyzedFigure);
            obj.GeesePositionArray = [X;Y;Z];
            obj.NumOfGeese = Population;
            
        end
        
    end
    
end

