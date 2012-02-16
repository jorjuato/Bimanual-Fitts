function mu = get_mean(d,dh,mode)
    if     mode == 1
        mu = mean( filterOutliers(d) / mean(filterOutliers(dh)) );
    elseif mode == 2
        mu = mean( filterOutliers(d) - mean(filterOutliers(dh)) );
    elseif mode == 3
        df = filterOutliers(d);
        dhf = filterOutliers(dh);
        mu = (mean(df)-mean(dhf)) / sqrt( var(df)/length(df) + var(dhf)/length(dhf));
    elseif mode == 4
        df = filterOutliers(d);
        dhf = filterOutliers(dh);
        mu = mean(df/mean(dhf)/ sqrt( var(df)/length(df) + var(dhf)/length(dhf)));
    end
end