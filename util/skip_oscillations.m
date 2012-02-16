function idx = skip_oscillations(x,skiposc)
    [maxPeaks, ~] = peakdet(x, 0.00005);
    idx = maxPeaks(skiposc,1):maxPeaks(end,1);
end