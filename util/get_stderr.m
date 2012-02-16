function stderror = get_stderr(d,dh,mode)
    if     mode == 1
        stderror = ste( filterOutliers(d) / mean(filterOutliers(dh)) );
    elseif mode == 2
        stderror = ste( filterOutliers(d) - mean(filterOutliers(dh)) );
    elseif mode == 3
        df = filterOutliers(d);
        dhf = filterOutliers(dh);
        stderror = sqrt( var(df)/length(df) + var(dhf)/length(dhf));
    elseif mode == 4
        df = filterOutliers(d);
        dhf = filterOutliers(dh);
        Xtrans = df/mean(dhf) / sqrt( var(df)/length(df)+var(dhf)/length(dhf) );
        %stderror = sqrt( var(df)/length(df) + var(dhf)/length(dhf));
        stderror = ste(Xtrans);
    end
end