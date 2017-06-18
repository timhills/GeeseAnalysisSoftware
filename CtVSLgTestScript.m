% Distance from Centroid vs distance from lead goose functional
% Author: Tim Hills
% Made: 6-17-2017

clear all; close all; clc

% user selects which dir the geese figures are in
FigDir = uigetdir('C:\Users\Timothy\Dropbox\Research\', ...
    'Choose the directory in which the geese centroid figures are.');

% user selects which dir to save data
SaveDir = uigetdir('C:\Users\Timothy\Dropbox\Research',...
    'Choose the directoy you would like to save CtVSLg data.');

% included in name of generated .xlsx file
AnalysisDate = datestr(now,'mm_dd_yyyy');

% set cd to get data from .fig files
cd(FigDir);

FileObj = dir('*.fig')';

for i = 1:length(FileObj)
    
    % set cd to get data from .fig files
    cd(FigDir);
    
    DynamicFile = FileObj(i);
    MyCtVSLg = CtVSLg(AnalysisDate,DynamicFile);
    openfig(DynamicFile.name,'invisible');
    
    % Extract data from centroid figure
    MyCtVSLg.ExtractData();
    
    % Find the lead good of the flock
    MyCtVSLg.FindLeadGoose();
    
    % Derive the arithmetic mean of a flock based of it's members centroid
    % position
    MyCtVSLg.CalculateCentroid();
    
    % Calculate the distance of each flock member's distance from centroid
    % as well as that same member's distance from the lead goose
    MyCtVSLg.CalculateDistanceFromCentroid();
    MyCtVSLg.CalculateDistanceFromLeadGoose();
    
    % Organize data
    MyCtVSLg.SortData();
    
    % Set each data array to more managable variable names
    Ct = MyCtVSLg.DistanceFromCentroidArray;
    Lg = MyCtVSLg.DistanceFromLeadGooseArray;
    
    % Close original figure
    close all

    % cd to save data
    cd(SaveDir);
    
    % Set .fig name
    SetFigName(DynamicFile.name);
    
    % Plot Ct as a function of Lg
    MyCtVSLg.GenerateFigure();
    
    % Set .fig properties
    SetFigProperties('Distance from the lead goose [m]',...
        'Distance from the centroid [m]','on','on','Times New Roman');
    
    % Get a handle on the current figure
    CurrentFigObj = get(gcf);
    
    % save figure
    SaveFig(SaveDir,DynamicFile.name);
    
    %writes an Excel spreadsheet of the packing factors to the current folder
    xlswrite(strrep(DynamicFile.name,'.fig',''),{'Distance_from_centroid'},...
            sprintf('Sheet%s',num2str(i)),sprintf('A%d',1));
        
    xlswrite(strrep(DynamicFile.name,'.fig',''),{'Distance_from_lead_goose'},...
        sprintf('Sheet%s',num2str(i)),sprintf('B%d',1));
    
    for j = 1:length(Ct)
        
        xlswrite(strrep(DynamicFile.name,'.fig',''),Ct(j),...
            sprintf('Sheet%s',num2str(i)),sprintf('A%d',j+1));
        
        xlswrite(strrep(DynamicFile.name,'.fig',''),Lg(j),...
            sprintf('Sheet%s',num2str(i)),sprintf('B%d',j+1));
        
    end
    
    % Close unique figure
    close all
    
end
