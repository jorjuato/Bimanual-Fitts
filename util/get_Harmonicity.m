function [H,badguys] = get_Harmonicity(x,a,idx)
    [maxP, minP] = peakdet(a(idx),0.1);
    badguys={};
    %Border cases, typical of fully harmonic movement (only one acc peak)
    if isempty(minP) || isempty(maxP)            
        H=1;
        badguys{end+1}=[idx(1),idx(end)];
    elseif size(minP,1)==1 && (minP(1,1)==1  || minP(1,1)==length(idx))
        H=1;
        badguys{end+1}=[idx(1),idx(end)];
    elseif size(maxP,1)==1 && (maxP(1,1)==1  || maxP(1,1)==length(idx))
        H=1;
        badguys{end+1}=[idx(1),idx(end)];
    else
        minP=abs(min(min(minP(:,2))));
        maxP=abs(max(max(maxP(:,2))));
        if mean(x(idx))<0
            H=minP/maxP;
        else
            H=maxP/minP;
        end
   end
end