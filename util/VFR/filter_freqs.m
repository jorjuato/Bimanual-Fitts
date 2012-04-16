function xf = filter_freqs(x,F1,F2,SampleNumber, plotGraphs)
% filter_freqs: Band pass filter funtion
% INPUT
%  x            - time series
%  F1           - Lower bound frequency
%  F2           - Upper bound frequency
%  SampleRate   - Data sampling rate, higher than Nyquist freq
%  plotGraphs   - Boolean, enables plotting of filter and signals
%
% OUTPUT
%  xf           - filtered time serie

if plotGraphs; close all; end

% Define properties of filter (FA1,FA2)
N1     = F1/(SampleNumber/2);
N2     = F2/(SampleNumber/2);

%Build filter window and filter
b=fir1(length(x)-1,[N1,N2]);

%Plot filter freq response
if plotGraphs; figure();freqz(b,1,512); end

%Generate filter freq space 
H=abs(fft(b));
HH=real(ifft(H));

%Convolve filter with signal
xf=real(ifft(fft(x).*H'));

%plot signals time series and spectrum
if plotGraphs
    figure()
    subplot(3,1,1); hold on; plot(x, 'r'); plot(xf, 'b');
    subplot(3,1,2); hold on; plot(fft(x).*conj(fft(x)), 'r'); %plot(fft(xf).*conj(fft(xf)), 'b');
    subplot(3,1,3); hold on; plot(diff(x),'r'); plot(diff(xf),'b');
end

