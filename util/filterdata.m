function xf = filterdata(x,cutoff,nyqfreq)
    %Raoul's version
    if nargin<3, nyqfreq = 500; end
    if nargin<2, cutoff  = 12 ; end
    
    %4th order Butter low-pass filter
    [b,a]=butter(4,cutoff/nyqfreq,'low');
    xf = filtfilt(b,a,x);
end