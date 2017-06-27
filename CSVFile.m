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
        Header
        
    end
    
    methods(Static)

        function CloseFile()
            % Close all currently open file
            fclose('all');

        end

    end
    
    methods
        
        function obj = CSVFile(Path,Name,Permission)
            % Instantiate CSVFile class 
            obj.FileName = strcat(Path,'/',Name,'.csv');
            obj.PermissionType = Permission;
            edit(strcat(Name,'.csv'))
            obj.FileID = fopen(obj.FileName,Permission);
            
        end
        
        function InsertHeader(obj,HeaderData)
            % Insert the titles of each column
            obj.Header = HeaderData;
            for i = 1:length(obj.Header)
                fprintf(obj.FileID,'%s,',num2str(cell2mat(obj.Header(i))));
            end
            
        end
        
        function WriteRowDescription(obj,RowDes)
            % Right a description of the row being enters. Arguments are
            % cell arrays for the name of the row
            fprintf(obj.FileID,'%s',num2str(cell2mat(RowDes)));
            
        end
        
        function WriteDataLine(obj,CurrentData)
            % Write a line of data to the .csv file
            CurrentData = sprintf('%0.2f,',CurrentData);
            obj.CurrentDataRow = CurrentData(1:end-1);
            fprintf(obj.FileID,obj.CurrentDataRow);
            
        end
        
        function StartNewLine(obj)
            % Start writing data on next line
            fprintf(obj.FileID,'\n');
            
        end
        
        function OpenFile(obj,Permission)
            % Open the .csv file with a different permission that what the
            % object was originally instantiated with
            obj.PermissionType = Permission;
            obj.FileID = fopen(obj.FileName,Permission);
            
        end
        
    end
    
end

