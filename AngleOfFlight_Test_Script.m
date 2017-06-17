
%{

Author: Tim Hills, 9-2-2016

Top level test script for calculating the angle of flight of a flock of
geese

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

% set file name
FileName = strcat('Angle_Of_Flight_',AnalysisDate);

% set cd to get data from .fig files
cd(FigDir);

MyAngle = AngleOfFlight(AnalysisDate);
FileObj = dir('*.fig')';
for i = 1:length(FileObj)
    
    % set cd to get data from .fig files
    cd(FigDir);
    
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
        cd(SaveDir);
        
        %writes an Excel spreadsheet of the angles of flight to the current folder
        xlswrite(FileName,MyAngle.Angle,'Sheet1',sprintf('B%d',i))
        xlswrite(FileName,{DynamicFile.name},'Sheet1',sprintf('A%d',i))
        
    else
        
    end
    
end

clc

disp('Angle of Flight analysis complete')

AOFData = xlsread(strcat(FileName,'.xls'));

figure;
h = histogram(AOFData,'Normalization','probability','BinWidth',10);
ax = gca;
ax.YGrid = 'on';
ax.FontName = 'Times New Roman';
xlabel(sprintf('Angle of Flight [%c]', char(176)),'FontName','Times New Roman')
ylabel('Probability','FontName','Times New Roman')