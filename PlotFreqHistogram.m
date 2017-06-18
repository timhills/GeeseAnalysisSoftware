function PlotFreqHistogram(Data,BinWidth,XLabel)
% Set properties for a probability histogram
    figure;
    h = histogram(Data,'Normalization','probability','BinWidth',BinWidth);
    ax = gca;
    ax.YGrid = 'on';
    ax.FontName = 'Times New Roman';
    xlabel(XLabel,'FontName','Times New Roman')
    ylabel('Probability','FontName','Times New Roman')

end