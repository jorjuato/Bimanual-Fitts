function [Pxx, f] = get_welch_periodogram(x,fs)
    if nargin<2,fs=1000;end
    
    %Use welch method to compute PSD    
    factor=floor(length(x)/1050);
    %factor=1;
    nfft=1024*factor;
    noverlap=nfft/2;
    Hs = [];
    [Pxx,f] = pwelch(x,Hs,noverlap,nfft,fs);
end