function tshist = get_ph_histogram(ts,peaks,bins,iscircular)
    if nargin<4, iscircular=0; end
    if nargin<3, bins=1;end
    
    %Prepare algorithm's parameters    
    peaks=peaks(2:end);   
    pL=length(peaks)-1;
    oscL=diff(peaks);
    maxL=max(oscL)+1;
    meanL=mean(oscL);
    stdL=std(oscL);
    tsc=zeros(pL,bins)*NaN;
    tshist=zeros(bins,1);
    %tsc=zeros(pL,maxL)*NaN;
    %tshist=zeros(maxL,1);
    %Generate a matrix of ( peaks, ts length)
    for p=1:pL
        x=ts(peaks(p):peaks(p+1));
        xL=length(x);
        if xL<meanL-2*stdL, continue; end %too sort, something is wrong, discard
        t=linspace(1,xL,bins);
        tsc(p,:)=interp1(1:xL,x,t);
    end        
    %Average over complete cycles
    %for l=1:maxL
    for l=1:bins
        d=~isnan(tsc(:,l));
        if iscircular
            tshist(l)=circstat(tsc(d,l));
        else
            tshist(l)=mean(tsc(d,l));
        end
    end
    %Solve a boundary problem if variable is circular
    if iscircular
        tshist(end)=-pi;
    end
end