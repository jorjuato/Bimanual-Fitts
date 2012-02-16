function out = get_spectrogram(x,avg)
    F = 0:0.01:3.5;
    fs = 1E3;
    w=round(1/avg*fs*2);
    overlap=w-round(w/5);
    [S,F,T,P] = spectrogram(x,w,overlap,F,fs,'yaxis');    
    out = {S,F,T,P};
end