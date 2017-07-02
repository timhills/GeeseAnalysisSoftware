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

% Instantiate csv obj
CSVData = CSVFile(SaveDir,FileName,'w');

DataArray = [];
HeaderArray = {};

% set cd to get data from .fig files
cd(FigDir);

for i = 1:length(FileObj)
    
    DynamicFile = FileObj(i);
    openfig(DynamicFile.name,'invisible');
    MyPackFrac.CalculatePackingFraction(DynamicFile.name);
    
    DataArray = [DataArray,MyPackFrac.PackingFraction];

    HeaderArray{i} = {DynamicFile.name};

    CSVData.InsertHeader(HeaderArray{i});
    
end

clc

% cd to save data
cd(SaveDir);

CSVData.StartNewLine;
CSVData.WriteDataLine(DataArray);
CSVData.CloseFile;
PFData = csvread(strcat(FileName,'.csv'),1);

% Plot data in probability histogram
PlotFreqHistogram(PFData,0.00045,'Packing Factor')

% save histogram
SaveFig(SaveDir,FileName);

disp('Packing Factor analysis complete!')