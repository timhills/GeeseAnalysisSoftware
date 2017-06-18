function SetFigName(FigName)
% This function must be called before data is plotted on a .fig file.
    figure('Visible','off','Name',FigName,'NumberTitle','off');
end