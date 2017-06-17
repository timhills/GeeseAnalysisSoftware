%script to graph centroid of every goose within a flock
clear; close all; clc

%set 'Current Folder'
cd(fullfile('C:\Users\Astex\Documents\MATLAB\Geese Analysis\Raw Geese Data'));

FileObj = dir('*.fig')';
for i = 1:length(FileObj)
    DynamicFile = FileObj(i);
    PlotAveragePosition(DynamicFile.name);
end