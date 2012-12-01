function d = get_hook_distances(tr,hand,interval)
    if nargin<3, interval=5; end
    if nargin<2, hand=''; end

    if strcmp(hand,'R')
        peaks=tr.ts.Rpeaks;
        a=tr.ts.Ranorm;
    elseif strcmp(hand,'L')
        peaks=tr.ts.Lpeaks;
        a=tr.ts.Lanorm;
    else
        peaks=tr.ts.peaks;
        a=tr.ts.anorm;
    end
    d=zeros(size(peaks)-1);
    for i=1:length(peaks)-1
        d(i,1)=mean(abs(a(peaks(i)-interval:peaks(i)+interval)));
    end
end

