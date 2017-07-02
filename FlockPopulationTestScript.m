% Flock Population (FP) Script
% Author: Tim Hills
% Made: 6-17-2017

clear; close all; clc;

% user selects which dir the geese figures are in
FigDir = uigetdir('C:\Users\Timothy\Dropbox\Research\', ...
    'Choose the directory in which the geese centroid figures are.');

% user selects which dir to save data
SaveDir = uigetdir('C:\Users\Timothy\Dropbox\Research',...
    'Choose the directoy you would like to save FP data.');

% included in name of generated .xlsx file
AnalysisDate = datestr(now,'mm_dd_yyyy');

% set cd to get data from .fig files
cd(FigDir);

FileObj = dir('*.fig')';

% set file name
FileName = strcat('Flock_Population_',AnalysisDate,'_',num2str(length(FileObj)),...
    '_','Photos');

% Instantiate csv obj
CSVData = CSVFile(SaveDir,FileName,'w');

DataArray = [];
HeaderArray = {};

% set cd to get data from .fig files
cd(FigDir);

for i = 1:length(FileObj) 
    
    DynamicFile = FileObj(i);
    MyFP = FlockPop(AnalysisDate);
    openfig(DynamicFile.name,'invisible');
    
    % count number of geese in a flock
    MyFP.CountGeese();
    
    DataArray = [DataArray,MyFP.FlockPopulation];
    
    HeaderArray{i} = {DynamicFile.name};
    
    CSVData.InsertHeader(HeaderArray{i});
    
end

cd(SaveDir);

CSVData.StartNewLine;
CSVData.WriteDataLine(DataArray);
CSVData.CloseFile;
FPData = csvread(strcat(FileName,'.csv'),1);

% Plot data in probability histogram
PlotFreqHistogram(FPData,3,'Flock Population');

% save histogram
SaveFig(SaveDir,FileName);

disp('Flock Population analysis complete!')
