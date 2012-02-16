function [Pxx, f] = get_welch_periodogram(x)
    %Use welch method to compute PSD
    fs=1000;
    factor=floor(length(x)/1050);
    nfft=1024*factor;
    noverlap=nfft/2;
    Hs = [];
    [Pxx,f] = pwelch(x,Hs,noverlap,nfft,fs);
end