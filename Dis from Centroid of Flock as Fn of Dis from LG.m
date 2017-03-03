%%
clear all
%data for ideal flock
[num,~,x1,y1,~] = GetGraphData1(openfig('IdealFlock15-18.fig'));
%initialize and declare an empty array "numberOfGeese = []" in the command
%window
%if num <= 20 && num >= 15 
%    numberOfGeese(end + 1) = num;
%end
xI = cell2mat(x1);
yI = cell2mat(y1);
flockI = [xI;yI];
clc
close all
%%
%using curve fitting tool for ideal data 
for i = 1:length(xI)
    dcI(i) = sqrt((xI(i) - mean(xI)).^2 + (yI(i) - mean(yI)).^2);   
    dlI(i) = sqrt((xI(i) - xI(length(flockI))).^2 + (yI(i) - yI(length(flockI))).^2);
end
close all
D1 = [dlI;dcI];
[Y, I] = sort(D1(1,:));
D1 = D1(:,I);
%createFit(dlI,dcI);
clc
%%
%data for actual flock
[num,~,x2,y2,z2] = GetGraphData1(openfig('686_Av.fig'));
%initialize and declare an empty array "numberOfGeese = []" in the command
%window
clc
if num <= 18 && num >= 15 
    numberOfGeese(end + 1) = num;
    x = cell2mat(x2);
    y = cell2mat(y2);
    z = cell2mat(z2);
    flock = [x;y;z];
    open('flock')
else
    fprintf('Next Flock')
end
close all
%%
%distance data for actual flock.  
for i = 1:length(x)
    dc(i) = sqrt((x(i) - mean(x)).^2 + (y(i) - mean(y)).^2 + (z(i) - mean(z)).^2); 
    dl(i) = sqrt((x(i) - x(11)).^2 + (y(i) - y(11)).^2 + (z(i) - z(11)).^2);
end
%createFit(dl,dc);
D2 = [dl;dc];
[Y, I] = sort(D2(1,:));
D2 = D2(:,I);
clc
close all
%regular plotting, superimposing actual data over ideal data
figure
plot(D2(1,1:length(flock)),D2(2,1:length(flock)),'ko-','LineWidth',2);
hold on
plot(D1(1,1:length(flockI)),D1(2,1:length(flockI)),'ro-','LineWidth',2)
%L = D(2,1:length(flock)) - dcI;
%errorbar(D(1,1:length(flock)),D(2,1:length(flock)),L,L,'LineStyle','none');
xlabel('Distance from Lead Goose [m]')
ylabel('Distance from the Centeroid [m]')
legend('Actual Flock','Ideal Flock','Location','northwest')