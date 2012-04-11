function [p, q, Lf, Rf] = get_locking_ratio(LPxx,RPxx,freqs,peak_delta)
    if nargin<4, peak_delta=1; end
    Lf=freqs(find(LPxx==max(LPxx)));
    Rf=freqs(find(RPxx==max(RPxx)));
    [p,q]=rat(Lf/Rf);
end

%old shit!!
    %Discover the peaks and obtain a ratio of two natural numbers
    %[Lmax, ~] = peakdet(LPxx,peak_delta);
    %[Rmax, ~] = peakdet(RPxx,peak_delta);
    %if isempty(Lmax) || isempty(Rmax) 
        %%figure; hold on
        %%plot(freqs,LPxx,'r');
        %%plot(freqs,RPxx,'g');
        %%xlim([0,10]);
        %%hold off;
        %p=1.1;q=1.1;
        %Lf=0;Rf=0;
    %else
        %Lf=freqs(Lmax(1));
        %Rf=freqs(Rmax(1));
        %[p,q]=rat(freqs(Lmax(1))/freqs(Rmax(1)));
    %end
