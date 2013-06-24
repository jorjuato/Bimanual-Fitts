function tshist = get_ts_histogram(ts,peaks,bins,iscircular)
    if nargin<4, iscircular=0; end
    if nargin<3, bins=0;end
    
    %Prepare algorithm's parameters    
    peaks=peaks(3:2:length(peaks));
    pL=length(peaks)-1;
    oscL=diff(peaks);
    maxL=max(oscL)+1;
    meanL=mean(oscL);
    stdL=std(oscL);
    %tsc=zeros(pL,maxL)*NaN;
    tsc=zeros(pL,bins)*NaN;
    tshist=zeros(bins,1);
    for p=1:pL
        x=ts(peaks(p):peaks(p+1));
        xL=length(x);
        if xL<meanL-2*stdL, continue; end
        t=linspace(1,xL,bins);
        tsc(p,:)=interp1(1:xL,x,t);
    end
    
    if iscircular    
        for l=1:bins            
            tshist(l)=nancircstat(tsc(:,l));
        end
    else
        tshist=nanmean(tsc,1)';
    end
end