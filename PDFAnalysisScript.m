% Pair Distribution Function Analysis Script
% 
% This script analyzes the pair distribution of flocks with 13 to 15 flock
% members. The pair distribution function is the quantification of the
% distances between special pairs of flock members with respect to a focal
% animal. This script will analyze the distances between the two rear geese
% with respect to the lead goose and plot that distance as a function of
% the number of flock members
%
% EDITS TO MAKE: Try plotting pair distribution distance as a function of
% the number of flock members, but only with flocks that have a flock
% ratio of 1 to 1.5
% 
% Author: Tim Hills
%
% Made: 6-19-2017

clear all; close all; clc

% user selects which dir the geese figures are in
FigDir = uigetdir('C:\Users\Timothy\Dropbox\Research\', ...
    'Choose the directory in which the geese centroid figures are.');

% user selects which dir to save data
SaveDir = uigetdir('C:\Users\Timothy\Dropbox\Research',...
    'Choose the directoy you would like to save Pair Distribution Function data.');

% included in name of generated .xlsx file
AnalysisDate = datestr(now,'mm_dd_yyyy');

% set cd to get data from .fig files
cd(FigDir);

FileObj = dir('*.fig')';

% set file name
FileName = strcat('Pair_Distribution_Function_',AnalysisDate);

for i = 1:length(FileObj)
    
    % set cd to get data from .fig files
    cd(FigDir);
    
    DynamicFile = FileObj(i);
   
    MyPDF = PDF(AnalysisDate,DynamicFile);
    
    openfig(DynamicFile.name,'invisible');
    
    % Extract data from centroid figure
    MyPDF.ExtractData();

    % Find lead goose of flock
    MyPDF.FindLeadGoose();

    % Find rear geese of flock
    MyPDF.FindRearGeese();

    % Calculate pair distribution distance
    MyPDF.CalculatePairDistributionDistance();

    % Close original figure
    close all

    % cd to save data
    cd(SaveDir);

    %writes an Excel spreadsheet of the pair distribution to the current folder
    xlswrite(FileName,{DynamicFile.name},'Sheet1',sprintf('A%d',i))
    xlswrite(FileName,MyPDF.PDDistanceOne,'Sheet1',sprintf('B%d',i))
    xlswrite(FileName,MyPDF.PDDistanceTwo,'Sheet1',sprintf('C%d',i))
    xlswrite(FileName,MyPDF.NumOfGeese,'Sheet1',sprintf('D%d',i))
    
end

clc

PDFData = xlsread(strcat(FileName,'.xls'));

% Plot data in probability histogram
PlotFreqHistogram(PDFData,0.5,'Pair Distribution Distance [m]');

% save histogram
SaveFig(SaveDir,FileName);

disp('Pair Distribution Function analysis complete')
