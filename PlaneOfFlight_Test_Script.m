
%{

Author: Tim Hills, 10-Dec-2017

Top level test script for visualizing the plane of flight for a
V-formation.

Edited: NA

%}

clear all; close all; clc

% user selects which dir the geese figures are in
FigDir = uigetdir('C:\Users\Timothy\Dropbox\Research\', ...
    'Choose the directory in which the geese centroid figures are.');

% included in name of generated .xlsx file
AnalysisDate = datestr(now,'mm_dd_yyyy');

% set cd to get data from .fig files
cd(FigDir);

FileObj = dir('*.fig')';

DataArray = [];
HeaderArray = {};

% set cd to get data from .fig files
cd(FigDir);

for NumOfFigures = 1:length(FileObj)
   
    DynamicFile = FileObj(NumOfFigures);
   
    MyPlane = PlaneOfFlight(AnalysisDate,DynamicFile);
    
    openfig(DynamicFile.name);
    
    % Extract data from centroid figure
    MyPlane.ExtractData();

    % Find lead goose of flock
    MyPlane.FindLeadGoose();

    % Find rear geese of flock
    MyPlane.FindRearGeese();
    
    % Create a visulazation of the plane of flight for every figure in
    % directory.
    MyPlane.VisPlane();
    
end

disp('Angle of Flight analysis complete')