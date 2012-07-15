function Hi = harmonicity_index(tr,hand)
if nargin==1, hand='uni';end

if isa(tr,'Trial')
    ts=tr.ts;
else %it's a TimeSeriesXXXXX Object
    ts=tr;
end
if strcmp(hand,'uni')
    x=ts.xnorm;
    a=ts.anorm;
elseif strcmp(hand,'L')
    x=ts.Lxnorm;
    a=ts.Lanorm;
elseif strcmp(hand,'R')
    x=ts.Rxnorm;
    a=ts.Ranorm;
end

xc=crossings(x);
Hi=zeros(0,length(xc)-1);
for i=1:length(xc)-1
    idx=xc(i):xc(i+1);
    [maxP, minP] = peakdet(a(idx),0.2);
    %Border cases, typical of fully harmonic movement (only one acc peak)
    if isempty(minP) || isempty(maxP) || ...
       minP(1,1)==1  || minP(1,1)==length(idx) || ...
       maxP(1,1)==1  || maxP(1,1)==length(idx)
            Hi(i)=1;
            continue
    end
    minP=min(minP(:,2));
    maxP=max(maxP(:,2));
    if mean(x(idx))<0
        Hi(i)=minP/maxP;
    else
        Hi(i)=maxP/minP;
    end
    
end
Hi(Hi<0)=0;
Hi=Hi';
