% Flock Ratio (FR) Analysis Script
% Author: Tim Hills
% Made: 6-18-2017

clear; close all; clc

% user selects which dir the geese figures are in
FigDir = uigetdir('C:\Users\Timothy\Dropbox\Research\', ...
    'Choose the directory in which the geese centroid figures are.');

% user selects which dir to save data
SaveDir = uigetdir('C:\Users\Timothy\Dropbox\Research',...
    'Choose the directoy you would like to save FR data.');

% included in name of generated .xlsx file
AnalysisDate = datestr(now,'mm_dd_yyyy');

% set cd to get data from .fig files
cd(FigDir);

FileObj = dir('*.fig')';

% set file name
FileName = strcat('Flock_Ratio_',AnalysisDate,'_',num2str(length(FileObj)),...
    '_','Photos');

% Instantiate csv obj
CSVData = CSVFile(SaveDir,FileName,'w');

DataArray = [];
HeaderArray = {};

% set cd to get data from .fig files
cd(FigDir);

for i = 1:length(FileObj)
    
    DynamicFile = FileObj(i);
    openfig(DynamicFile.name,'invisible');
   
    MyFlockRatio = FlockRatio(AnalysisDate,DynamicFile.name);
    
    % Get .fig data
    MyFlockRatio.ExtractData();
    
    % Find the lead goose
    MyFlockRatio.FindLeadGoose();
    
    % Find the two rear geese
    MyFlockRatio.FindEndGeese();
    
    % Calculate the vector drawn between the lead goose and a rear goose
    MyFlockRatio.CalculateSepVector();
    
    % Remove the lead goose position from the flock data array since this
    % analysis is meant to check the ratio of geese on one side of the
    % flock to the other side
    MyFlockRatio.RemoveLeadGoose();
    
    % Calculate the distance from a goose' centroid to the seperation
    % vector
    MyFlockRatio.CalculateDistanceFromPtToLine();
    
    % Seperate the flock according to what side each member is on
    MyFlockRatio.OrganizeFlock();
    
    % Calculate the flock ratio
    MyFlockRatio.CalculateFlockRatio();
    
    DataArray = [DataArray,MyFlockRatio.Ratio];

    HeaderArray{i} = {DynamicFile.name};

    CSVData.InsertHeader(HeaderArray{i});
    
end

clc

% cd to save data
cd(SaveDir);

CSVData.StartNewLine;
CSVData.WriteDataLine(DataArray);
CSVData.CloseFile;
Ratios = csvread(strcat(FileName,'.csv'),1);

% Plot data in probability histogram
PlotFreqHistogram(Ratios,0.5,'Flock Ratio');

% save histogram
SaveFig(SaveDir,FileName);

disp('Flock Ratio analysis complete!')
