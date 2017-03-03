
%NND test script 
%Author: Tim Hills, 9-20-2016

clear; close all; clc

%set 'Current Folder'
cd(fullfile('C:\Users\Astex\Documents\MATLAB\Geese Analysis\Centroid Geese Data'));

MyNND = NND('Centroid Geese Data 2');
FileObj = dir('*.fig')';
for i = 1:length(FileObj)
    DynamicFile = FileObj(i);
    MyNND.CalculateNND(DynamicFile.name);
    %writes an Excel spreadsheet of the nnd to the current folder
    xlswrite('Nearest Neighbor Distance',MyNND.NNDArray,'Sheet1',sprintf('B%d',i))
    xlswrite('Nearest Neighbor Distance',{DynamicFile.name},'Sheet1',sprintf('A%d',i))
end

clc

disp('NND analysis complete!')
%%

%this is to be ran after the user has created a numeric matrix of the
%values generated in the NND analysis. This puts all of the values from the
%excel spreadsheet into a 1xn dimensional array and then clears out all of
%the NaN values

NNDArray = [];
NNDSize = size(NearestNeighborDistance);
NNDRows = NNDSize(1);
NNDColumns = NNDSize(2);
for i = 1:NNDRows
    for j = 1:length(NearestNeighborDistance(i,:))
        NNDArray = [NNDArray NearestNeighborDistance(i,j)];
    end
end

IndexToRemove = find(isnan(NNDArray));
NNDArray(IndexToRemove) = [];
h = histogram(NNDArray,'Normalization','probability','BinWidth',0.2);
histogram(NNDArray,'Normalization','probability','BinWidth',0.2,'Values',h.Values*100);
xlabel('Nearest Neighbor Distance [m]')
ylabel('Probability [%]')
