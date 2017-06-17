classdef AngleOfFlight < handle
    %{
    
    Author: Tim Hills, 9-2-2016
    
    This class calculate the average angle of flight of a flock of geese. Make
    sure that the "Current Folder" is Centroid Geese Data in the test
    
    %}
    
    properties
        Folder
        FigureAnalyzed
        Angle
        AngleArray
        NumberOfGeese
        GeesePositionArray
        LeadGoose
        RearGoose1
        RearGoose2
    end
    
    methods (Access = public)
        function obj = AngleOfFlight(Date)
            obj.Folder = Date;
        end
        
        %figure data
        function GetFigureData(obj,Figure,LeadGooseCent,RearGoose1Cent,RearGoose2Cent)
            obj.FigureAnalyzed = Figure;
            obj.LeadGoose = LeadGooseCent;
            obj.RearGoose1 = RearGoose1Cent;
            obj.RearGoose2 = RearGoose2Cent;          
            [Population,X,Y,Z] = GetGraphData1(obj.FigureAnalyzed);
            PositionArray = [X;Y;Z];
            obj.GeesePositionArray = PositionArray;
            obj.NumberOfGeese = Population;
            obj.CalculateAngle(obj.LeadGoose, obj.RearGoose1, obj.RearGoose2);
        end

        function [LeadGoose, RearGoose1, RearGoose2] = VertexGeese(LeadGooseObj,RearGoose1Obj,RearGoose2Obj)
            LeadGoose = getfield(LeadGooseObj,'Position');
            RearGoose1 = getfield(RearGoose1Obj,'Position');
            RearGoose2 = getfield(RearGoose2Obj,'Position');
        end
        
        function CalculateAngle(obj,LeadGoose,RearGoose1, RearGoose2)
            rtXArray = [];
            rtYArray = [];
            rtZArray = [];
            lftXArray = [];
            lftYArray = [];
            lftZArray = [];
            Vector1 = [(RearGoose1(1) - LeadGoose(1)) ...
                (RearGoose1(2) - LeadGoose(2)) (RearGoose1(3) - LeadGoose(3))]; 
            Vector2 = [(RearGoose2(1) - LeadGoose(1)) ...
                (RearGoose2(2) - LeadGoose(2)) (RearGoose2(3) - LeadGoose(3))]; 
            
            for i = 1:length(obj.GeesePositionArray)
                xP(i) = obj.GeesePositionArray(1,i) - LeadGoose(1);
                yP(i) = obj.GeesePositionArray(2,i) - LeadGoose(2);
                zP(i) = obj.GeesePositionArray(3,i) - LeadGoose(3);
                b = [xP(i) yP(i) zP(i)];
                d(i) = norm(cross(Vector1,b))/norm(Vector1);
                if d(i) <= 1
                    rtXArray(end + 1) = obj.GeesePositionArray(1,i);
                    rtYArray(end + 1) = obj.GeesePositionArray(2,i);
                    rtZArray(end + 1) = obj.GeesePositionArray(3,i);
                else
                    lftXArray(end + 1) = obj.GeesePositionArray(1,i);
                    lftYArray(end + 1) = obj.GeesePositionArray(2,i);
                    lftZArray(end + 1) = obj.GeesePositionArray(3,i);
                end
            end
            
            RightGeeseArray = [rtXArray; rtYArray; rtZArray];
            LeftGeeseArray = [lftXArray; lftYArray; lftZArray];
            assignin('base','RightGeeseArray', RightGeeseArray);
            assignin('base','LeftGeeseArray', LeftGeeseArray);
            %the slope is the slope from a goose's centroid from one side of the
            %V-formation to another goose's centroid on the other side of the
            %V-formation looking at the top view of the flock
            slope = (RearGoose1(2)-RearGoose2(2))/(RearGoose1(1)-RearGoose2(1));

            SizeOfLeftGeeseArray = size(LeftGeeseArray);
            SizeOfRightGeeseArray = size(RightGeeseArray);
            
            if (SizeOfRightGeeseArray(:,2) >= SizeOfLeftGeeseArray(:,2))
                for i = 1:SizeOfRightGeeseArray(:,2)
                    minVal = 10e+05;
                    sl = zeros(1,SizeOfLeftGeeseArray(:,2));
                    for j = 1:SizeOfLeftGeeseArray(:,2)
                        sl(j) = ((obj.GeesePositionArray(2,i) - obj.GeesePositionArray(2,j))/...
                            (obj.GeesePositionArray(1,i) - obj.GeesePositionArray(1,j))) - slope;
                        if sl(j) ~= 0 && sl(j) < minVal
                            minVal = sl(j);
                            k = j;
                        end
                    end
                    
                    if j == 1
                        k = 1;
                    end
                    
                    Vector1 = [(RightGeeseArray(1,i) - LeadGoose(1)) ...
                        (RightGeeseArray(2,i) - LeadGoose(2)) (RightGeeseArray(3,i) - LeadGoose(3))]; 
                    Vector2 = [(LeftGeeseArray(1,k) - LeadGoose(1)) ...
                        (LeftGeeseArray(2,k) - LeadGoose(2)) (LeftGeeseArray(3,k) - LeadGoose(3))];
                    %theta(i) = atan2(norm(cross(Vector1,Vector2)),dot(Vector1,Vector2))*180/pi;
                    theta(i) = acos(dot(Vector1,Vector2)/(norm(Vector1)*norm(Vector2)))*180/pi;
                end

            else %(SizeOfLeftGeeseArray(:,2) > SizeOfRightGeeseArray(:,2));
                for i = 1:SizeOfLeftGeeseArray(:,2) 
                    minVal = 10e+05;
                    sl = zeros(1,SizeOfRightGeeseArray(:,2));
                    for j = 1:SizeOfRightGeeseArray(:,2)
                        sl(j) = ((obj.GeesePositionArray(2,i) - obj.GeesePositionArray(2,j))/...
                            (obj.GeesePositionArray(1,i) - obj.GeesePositionArray(1,j))) - slope;
                        if sl(j) ~= 0 && sl(j) < minVal
                            minVal = sl(j);
                            k = j;
                        end
                    end
                    
                    if j == 1
                        k = 1;
                    end
                    
                    Vector1 = [(RightGeeseArray(1,k) - LeadGoose(1)) ...
                         (RightGeeseArray(2,k) - LeadGoose(2)) (RightGeeseArray(3,k) - LeadGoose(3))]; 
                    Vector2 = [(LeftGeeseArray(1,i) - LeadGoose(1)) ...
                        (LeftGeeseArray(2,i) - LeadGoose(2)) (LeftGeeseArray(3,i) - LeadGoose(3))];
                    %theta(i) = atan2(norm(cross(Vector1,Vector2)),dot(Vector1,Vector2))*180/pi;
                    theta(i) = acos(dot(Vector1,Vector2)/(norm(Vector1)*norm(Vector2)))*180/pi;
                end
            end
            IndexToRemove = find(isnan(theta));
            theta(IndexToRemove) = [];
            angle = theta(theta > std(theta));%remove errors
            obj.Angle = mean(angle);
            obj.AngleArray = [obj.AngleArray obj.Angle];
            clc
        end
    end
end

