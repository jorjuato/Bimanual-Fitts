function IDef = get_ID_effective(x,peaks,A)
    size(peaks);
    size(x);
    endpts = abs(x(peaks));
    Wef = std(endpts)*4.133; %Formula from McKenzie 1992
    IDef = log2(2*A/Wef);
end