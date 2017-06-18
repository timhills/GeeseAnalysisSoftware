classdef FlockPop < handle
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        FileName;
        FlockPopulation;
    
    end
    
    methods
        
        function obj = FlockPop(FileName)
            
            obj.FileName = FileName;
            
        end
        
        function CountGeese(obj)
            
            [obj.FlockPopulation,~,~,~] = GetGraphData1(obj.FileName);
            
        end
        
    end
    
end

