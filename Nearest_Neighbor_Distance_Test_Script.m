
%NND test script 
%Author: Tim Hills, 9-20-2016
% Edited: 6-17-2017

clear; close all; clc

% user selects which dir the geese figures are in
FigDir = uigetdir('C:\Users\Timothy\Dropbox\Research\', ...
    'Choose the directory in which the geese centroid figures are.');

% user selects which dir to save data
SaveDir = uigetdir('C:\Users\Timothy\Dropbox\Research',...
    'Choose the directoy you would like to save NND data.');

% included in name of generated .xlsx file
AnalysisDate = datestr(now,'mm_dd_yyyy');

% set cd to get data from .fig files
cd(FigDir);

MyNND = NND(AnalysisDate);
FileObj = dir('*.fig')';

% set file name
FileName = strcat('Nearest_Neighbor_Distance_',AnalysisDate,'_',num2str(length(FileObj)),...
    '_','Photos');

for i = 1:length(FileObj)
    
    % set cd to get data from .fig files
    cd(FigDir);
    
    DynamicFile = FileObj(i);
    openfig(DynamicFile.name,'invisible');
    MyNND.CalculateNND(DynamicFile.name);
    
    % cd to save data
    cd(SaveDir);
    
    %writes an Excel spreadsheet of the nnd to the current folder
    xlswrite(FileName,MyNND.NNDArray,'Sheet1',sprintf('B%d',i))
    xlswrite(FileName,{DynamicFile.name},'Sheet1',sprintf('A%d',i))
    
end

NNDData = xlsread(strcat(FileName,'.xls'));

NNDData(find(isnan(NNDData))) = [];

% Plot data in probability histogram
PlotFreqHistogram(NNDData,0.2,'Nearest Neighbor Distance [m]')

% save histogram
SaveFig(SaveDir,FileName);

disp('NND analysis complete')
