function [d,s]=get_minpeak_distance(obj,i,j)
    if isa(obj,'Trial')
        [d,s]=get_trial_minpeak_distance(obj);
    elseif isa(obj,'Block')
        [~,~,rep]=size(obj.data_set);
        d=[];s=[];
        for r=1:rep-1
            [dtmp,stmp]=get_trial_minpeak_distance(obj{i,j,r});
            d=[d;dtmp];
            s=[s;stmp];
        end
    end
end

function [d,s]=get_trial_minpeak_distance(tr)
    Rlen = length(tr.ts.Rpeaks);
    Llen = length(tr.ts.Lpeaks);
    if Llen<Rlen
        d=zeros(Llen,1);
        s=zeros(Llen,1);
        for i=1:Llen
            [d(i),j]=min(abs(tr.ts.Lpeaks(i)-tr.ts.Rpeaks));
            s(i)=sign(tr.ts.Lpeaks(i)-tr.ts.Rpeaks(j));
        end
    else
        d=zeros(Rlen,1);
        s=zeros(Rlen,1);
        for i=1:Rlen
            [d(i),j]=min(abs(tr.ts.Rpeaks(i)-tr.ts.Lpeaks));
            s(i)=sign(tr.ts.Lpeaks(j)-tr.ts.Rpeaks(i));
        end
    end
end