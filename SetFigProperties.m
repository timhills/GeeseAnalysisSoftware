function SetFigProperties(XLabel,YLabel,XGridState,YGridState,LabelFont)
% Set properties for a genertic .fig file

    ax = gca;
    ax.YGrid = YGridState;
    ax.XGrid = XGridState;
    ax.FontName = LabelFont;
    xlabel(XLabel)
    ylabel(YLabel)

end