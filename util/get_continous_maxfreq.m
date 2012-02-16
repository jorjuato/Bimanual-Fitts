function maxF = get_continous_maxfreq(x, avgFreq,fs)
    if nargin<3, fs=1E3; end
    %Estimates the instaneous frequency of movement in the input time series 
    %'x' perfoming a spectogram with a frequency range 'F' and haning
    %window length proportional to the average frequency of the whole time series.
    %For each time point in the spectogram, maxF contains the frequency
    %with the higgest power.
    
    F=avgFreq*1/2:avgFreq/100:avgFreq*3/2;    
    w=round(1/avgFreq*fs*2);
    overlap=w-10;    
    d=w-overlap;
    
    %Perform spectrogram with specified parameters
    [~,f,~,p] = spectrogram(x,w,overlap,F,fs,'yaxis');
    
    %Select maximum potency spectrum
    [~, idx] = max(p);
    maxFsort = f(idx);
    
    %Store values in chunk of 'd' size
    maxF=zeros(size(x));
    for i=0:length(maxFsort)-1
        maxF(d*i+1:d*i+d+1)=maxFsort(i+1);
    end
    
    %To keep sizes equal, the remaining values in maxF are
    %filled with the last value 
    if length(maxFsort)*d<length(x)
        maxF(length(maxFsort)*d:end) = maxFsort(end);
    end    
end