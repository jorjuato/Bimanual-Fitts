function catPath = joinpath(dir1,dir2)
    if ispc
        sep='\';
    else
        sep='/';
    end
    catPath = strcat(dir1,sep,dir2);