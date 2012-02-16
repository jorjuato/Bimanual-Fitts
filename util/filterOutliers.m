function filtered = filterOutliers(data)
    data = data(isfinite(data));
    filtered = data-mean(data);
    filtered = data(abs(filtered)<2*std(data));
    %filtered= data;
end