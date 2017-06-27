classdef CSVFile < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        FileID
        FileName
        PermissionType
        HeaderCells
        FirstColumn
        DataColumn
        CurrentDataRow
        
    end
    
    methods
        
        function obj = CSVFile(Path,Name,Permission)
            % Instantiate CSVFile class 
            obj.FileName = strcat(Path,'/',Name,'.csv');
            obj.PermissionType = Permission;
            edit(strcat(Name,'.csv'))
            obj.FileID = fopen(obj.FileName,Permission);
            
        end
        
        function WriteLine(obj,CurrentData)
            % Write a line of data to the .csv file
            CurrentData = sprintf('%s,',num2str(CurrentData));
            obj.CurrentDataRow = CurrentData(1:end-1);
            fprintf(obj.FileID,obj.CurrentDataRow);
            
        end
        
        function OpenFile(obj,Permission)
            % Open the .csv file with a different permission that what the
            % object was originally instantiated with
            obj.PermissionType = Permission;
            obj.FileID = fopen(obj.FileName,Permission);
            
        end
        
        function CloseFile()
            % Close all currently open file
            fclose('all');
            
        end
        
    end
    
end

