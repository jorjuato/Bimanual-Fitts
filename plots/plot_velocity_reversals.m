function tsc = plot_velocity_reversals(ts,peaks,bins)
    if nargin<3, bins=50;end

    tsc=zeros(length(peaks)-2,bins);
    for p=2:length(peaks)-1
        x=ts(peaks(p):peaks(p+1));
        if mod(p,2)~=0
            x=-x;
        end
        sz=round(length(x)/bins)-1;
        for b=1:bins
            idx=1+sz*(b-1):sz*b-1;
            tsc(p,b)=mean(x(idx));
        end
    end
    tsc=mean(tsc,1);
end