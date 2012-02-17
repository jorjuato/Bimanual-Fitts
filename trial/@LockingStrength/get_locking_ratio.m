function [p, q, Lf, Rf] = get_locking_ratio(LPxx,RPxx,freqs,peak_delta)
    if nargin<4, peak_delta=1; end
    %Discover the peaks and obtain a ratio of two natural numbers
    [Lmax, ~] = peakdet(LPxx,peak_delta);
    [Rmax, ~] = peakdet(RPxx,peak_delta);
    if isempty(Lmax) || isempty(Rmax) 
        %figure; hold on
        %plot(freqs,LPxx,'r');
        %plot(freqs,RPxx,'g');
        %xlim([0,10]);
        %hold off;
        p=1;q=1;
        Lf=1;Rf=1;
    else
        Lf=Lmax(2);
        Rf=Rmax(2);
        [p,q]=rat(freqs(Lmax(1))/freqs(Rmax(1)));
    end
end