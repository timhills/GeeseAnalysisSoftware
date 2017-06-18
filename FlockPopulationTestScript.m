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

for i = 1:length(FileObj) 
    
    % set cd to get data from .fig files
    cd(FigDir);
    
    DynamicFile = FileObj(i);
    MyFP = FlockPop(AnalysisDate);
    openfig(DynamicFile.name,'invisible');
    
    % count number of geese in a flock
    MyFP.CountGeese();
    
    % cd to save data
    cd(SaveDir);
    
    %writes an Excel spreadsheet of the angles of flight to the current folder
    xlswrite(FileName,{DynamicFile.name},'Sheet1',sprintf('A%d',i))
    xlswrite(FileName,MyFP.FlockPopulation,'Sheet1',sprintf('B%d',i))
    
end

FPData = xlsread(strcat(FileName,'.xls'));

% Plot data in probability histogram
PlotFreqHistogram(FPData,3,'Flock Population');

% save histogram
SaveFig(SaveDir,FileName);

disp('Flock Population analysis complete!')
