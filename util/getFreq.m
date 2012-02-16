function [freq, intensity] = getFreq(x)
%Get spectrum (frequency domain) of signal x
    Fs = 1000;                    % Sampling frequency
    L = length(x);                % Length of signal
    NFFT = 2^nextpow2(L);         % Next power of 2 from length of x
    X = fft(x,NFFT)/L;
    freq = Fs/2*linspace(0,1,NFFT/2+1);
    intensity = 2*abs(X(1:NFFT/2+1));
end