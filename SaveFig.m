function SaveFig(FilePath,FileName)
    NewFileName = strcat('\',FileName);
    savefig(strcat(FilePath,NewFileName));
end