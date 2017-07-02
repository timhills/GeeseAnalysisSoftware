%{

Author: Tim Hills, 7-1-2016

Get the data from a centroid representation of a flock and push it into a
.csv file

%}

clear all; close all; clc

% user selects which dir the geese figures are in
FigDir = uigetdir('C:\Users\Timothy\Dropbox\Research\', ...
    'Choose the directory in which the geese centroid figures are.');

% user selects which dir to save data
SaveDir = uigetdir('C:\Users\Timothy\Dropbox\Research',...
    'Choose the directoy you would like to save centroid position data.');

% included in name of generated .xlsx file
AnalysisDate = datestr(now,'mm_dd_yyyy');

% set cd to get data from .fig files
cd(FigDir);

TheData = CentroidDataToCSV(AnalysisDate);
FileObj = dir('*.fig')';

for i = 1:length(FileObj)
    
    % set cd to get data from .fig files
    cd(FigDir);

    %HeaderArray = {};
    
    DynamicFile = FileObj(i);
    openfig(DynamicFile.name,'invisible');
    
    % cd to save data
    cd(SaveDir);

    % Instantiate csv obj
    CSVData = CSVFile(SaveDir,strrep(DynamicFile.name,'.fig',''),'w');
    
    LeadGooseData = TheData.FindLeadGoose;
    RearGeeseData = TheData.FindEndGeese;
    RemainingGeeseData = TheData.GetRemainingGeese;
    
    FlockDataArray = [LeadGooseData,RearGeeseData,RemainingGeeseData];
    
    XData = FlockDataArray(1,:);
    YData = FlockDataArray(2,:);
    ZData = FlockDataArray(3,:);
    
    [NumofRows,NumofCol] = size(FlockDataArray);
    
    ReaderGooseInd = 0;

    for j = 1:NumofCol
        if j == 1
            Header = {' ,LeadGoose'};
        elseif j == 2 || j == 3
            Header = {sprintf('RearGoose%d',ReaderGooseInd+1)};
            ReaderGooseInd = ReaderGooseInd+1;
        else
            Header = {sprintf('Goose%d',j)};
            ReaderGooseInd = ReaderGooseInd+1;
        end
        
        CSVData.InsertHeader(Header);
        
    end
        
        CSVData.StartNewLine;
        CSVData.WriteRowDescription({'XData,'});
        CSVData.WriteDataLine(XData);
        
        CSVData.StartNewLine;
        CSVData.WriteRowDescription({'YData,'});
        CSVData.WriteDataLine(YData);
        
        CSVData.StartNewLine;
        CSVData.WriteRowDescription({'ZData,'});
        CSVData.WriteDataLine(ZData);
        
        CSVData.StartNewLine;
        
end

clc

CSVData.CloseFile;

disp('Data storage complete!')