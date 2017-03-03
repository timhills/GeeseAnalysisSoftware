%{

Author: Tim Hills, 9-2-2016

%Top level test script for calculating the packing fraction of a flock of
%geese

%edited 10-24 to receive number of geese per flock and not save the PF
figures to a folder

%}

%clear all; close all; clc

%set 'Current Folder'
cd(fullfile('C:\Users\Astex\Documents\MATLAB\Geese Analysis\Centroid Geese Data with RG and LG Data'));

MyPackFrac = DelTri('Centroid Geese Data 2');
FileObj = dir('*.fig')';
for i = 1:length(FileObj)
    DynamicFile = FileObj(i);
    MyPackFrac.CalculatePackingFraction(DynamicFile.name);
    %writes an Excel spreadsheet of the packing factors to the current folder
    xlswrite('Packing Fraction',MyPackFrac.PackingFraction,'Sheet1',sprintf('B%d',i))
    xlswrite('Packing Fraction',{DynamicFile.name},'Sheet1',sprintf('A%d',i))
    xlswrite('Packing Fraction',MyPackFrac.NumberOfGeese,'Sheet1',sprintf('C%d',i))
end

clc

disp('Packing Factor analysis complete!')
%%
MyPackFrac = DelTri('Centroid Geese Data');
MyPackFrac.CalculatePackingFraction('45 12-05-2015(21-86)');
%%
h = histogram(PFArray,'Normalization','probability','BinWidth',0.003);
histogram(PFArray,'Normalization','probability','BinWidth',0.003,'Values',h.Values*100);
xlabel('Packing Factor')
ylabel('Probability [%]')