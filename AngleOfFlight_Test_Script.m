
%{

Author: Tim Hills, 9-2-2016

Top level test script for calculating the angle of flight of a flock of
geese

%}

%if there is a flock that is flying in a straight line, choose the middle
%goose to be the lead goose and the geese at the front and the back the
%rear geese

clear; close all; clc

%set 'Current Folder'
cd(fullfile('C:\Users\Astex\Documents\MATLAB\Geese Analysis\Centroid Geese Data with RG and LG Data'));

MyAngle = AngleOfFlight('Centroid Geese Data 2');
FileObj = dir('*.fig')';
for i = 1:length(FileObj)
    DynamicFile = FileObj(i);
    openfig(DynamicFile.name,'invisible');
    
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
        %writes an Excel spreadsheet of the angles of flight to the current folder
        xlswrite('Angle Of Flight',MyAngle.Angle,'Sheet1',sprintf('B%d',i))
        xlswrite('Angle Of Flight',{DynamicFile.name},'Sheet1',sprintf('A%d',i))
    else
    end
end

clc

disp('Angle of Fligh analysis complete')
%%
h = histogram(AngleOfFlight,'Normalization','probability','BinWidth',10);
histogram(AngleOfFlight,'Normalization','probability','BinWidth',10,'Values',h.Values*100);
xlabel(sprintf('Angle of Flight [%c]', char(176)))
ylabel('Probability [%]')