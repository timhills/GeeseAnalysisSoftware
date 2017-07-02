
%{

Author: Tim Hills, 9-2-2016

Top level test script for calculating the angle of flight of a flock of
geese

Edited: 6-17-2017

%}

%if there is a flock that is flying in a straight line, choose the middle
%goose to be the lead goose and the geese at the front and the back the
%rear geese

clear all; close all; clc

% user selects which dir the geese figures are in
FigDir = uigetdir('C:\Users\Timothy\Dropbox\Research\', ...
    'Choose the directory in which the geese centroid figures are.');

% user selects which dir to save data
SaveDir = uigetdir('C:\Users\Timothy\Dropbox\Research',...
    'Choose the directoy you would like to save AOF data.');

% included in name of generated .xlsx file
AnalysisDate = datestr(now,'mm_dd_yyyy');

% set cd to get data from .fig files
cd(FigDir);

MyAngle = AngleOfFlight(AnalysisDate);
FileObj = dir('*.fig')';

% set file name
FileName = strcat('Angle_Of_Flight_',AnalysisDate,'_',num2str(length(FileObj)),...
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
    
    % check to see if .fig file has x, y and z axis data
    axesObjs = get(gcf, 'Children');  %axes handles
    dataObjs = get(axesObjs, 'Children');
    XLocation = dataObjs.XData;
    YLocation = dataObjs.YData;
    ZLocation = dataObjs.ZData;
    FindObj1 = findobj(gca,'LineWidth',5);
    FindObj2 = findobj(gca,'LineWidth',4);
    FindObj3 = findobj(gca,'LineWidth',3);
    
    if ~isempty(FindObj1) ||  ~isempty(FindObj2) || ~isempty(FindObj3)
        
        LeadGoose = [FindObj1.XData FindObj1.YData FindObj1.ZData];
        RearGoose1 = [FindObj2.XData FindObj2.YData FindObj2.ZData];
        RearGoose2 = [FindObj3.XData FindObj3.YData FindObj3.ZData];
        MyAngle.GetFigureData(DynamicFile.name, LeadGoose, RearGoose1, RearGoose2);
        
        % cd to save data
        %cd(SaveDir);
        
        DataArray = [DataArray,MyAngle.Angle];

        HeaderArray{i} = {DynamicFile.name};

        CSVData.InsertHeader(HeaderArray{i});
        
    else
        
    end
    
end

clc

% cd to save data
cd(SaveDir);

CSVData.StartNewLine;
CSVData.WriteDataLine(DataArray);
CSVData.CloseFile;
AOFData = csvread(strcat(FileName,'.csv'),1);

% Plot data in probability histogram
PlotFreqHistogram(AOFData,10,sprintf('Angle of Flight [%c]', char(176)))

% save histogram
SaveFig(SaveDir,FileName);

disp('Angle of Flight analysis complete')