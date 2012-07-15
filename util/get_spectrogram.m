function [S,F,T,P] = get_spectrogram(x,windowsize,overlap,do_plot,filename)
    if nargin<5, filename=''; end
    if nargin<4, do_plot=1; end
    if nargin<3, overlap=3/4; end
    if nargin<2, windowsize=1E3*3; end
    
    F = 0:0.01:3.5;
    fs = 1E3;
    %w=round(1/avg*fs*2)
    %w=hamming(round(length(x)/slices));
    w=hamming(windowsize);
    overlap=floor(windowsize*overlap);
    [S,F,T,P] = spectrogram(x,w,overlap,F,fs,'yaxis');
    
    if do_plot==1
        figure;
        surf(T,F,10*log10(abs(P)),'edgecolor','none');
        axis tight;
        view(0,90);
        %Save to disk if filename provided
        if ~isempty(filename)
            saveas(gcf,filename,'png');
        end
    end
end