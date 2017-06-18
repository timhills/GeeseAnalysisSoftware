%{

Author: Tim Hills, 9-2-2016

%Top level test script for calculating the packing fraction of a flock of
%geese

%edited 10-24 to receive number of geese per flock and not save the PF
figures to a folder

Edited: 6-17-2017

%}

clear all; close all; clc

% user selects which dir the geese figures are in
FigDir = uigetdir('C:\Users\Timothy\Dropbox\Research\', ...
    'Choose the directory in which the geese centroid figures are.');

% user selects which dir to save data
SaveDir = uigetdir('C:\Users\Timothy\Dropbox\Research',...
    'Choose the directoy you would like to save PF data.');

% included in name of generated .xlsx file
AnalysisDate = datestr(now,'mm_dd_yyyy');

% set cd to get data from .fig files
cd(FigDir);

MyPackFrac = DelTri(AnalysisDate);
FileObj = dir('*.fig')';

% set file name
FileName = strcat('Packing_Factor_',AnalysisDate,'_',num2str(length(FileObj)),...
    '_','Photos');


for i = 1:length(FileObj)
    
    % set cd to get data from .fig files
    cd(FigDir);
    
    DynamicFile = FileObj(i);
    openfig(DynamicFile.name,'invisible');
    MyPackFrac.CalculatePackingFraction(DynamicFile.name);

    % cd to save data
    cd(SaveDir);

    %writes an Excel spreadsheet of the packing factors to the current folder
    xlswrite(FileName,MyPackFrac.PackingFraction,'Sheet1',sprintf('B%d',i))
    xlswrite(FileName,{DynamicFile.name},'Sheet1',sprintf('A%d',i))
    %xlswrite(FileName,MyPackFrac.NumberOfGeese,'Sheet1',sprintf('C%d',i))
    
end

clc

PFData = xlsread(strcat(FileName,'.xls'));

% Plot data in probability histogram
PlotFreqHistogram(PFData,0.00045,'Packing Factor')

% save histogram
SaveFig(SaveDir,FileName);

disp('Packing Factor analysis complete!')