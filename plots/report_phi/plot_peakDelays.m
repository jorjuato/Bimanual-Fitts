function plot_peakDelays(xp)
    if nargin==0, xp=Experiment(); end
    
    for p=1:10
        pp=xp(p);
        for s=1:3
            figure;
            cnt=0;
            for l=1:2
                for r=1:3
                    d=[];
                    for rep=1:3
                        tr=pp(s).bimanual{l,r,rep};
                        pks=tr.oscR.minPeakDistance/1000;
                        if length(tr.oscR.MT) == length(pks)
                            d=[d;pks./tr.oscR.MT];
                        else
                            d=[d;pks./tr.oscL.MT];
                        end
                    end
                    cnt=cnt+1;
                    subplot(2,3,cnt);
                    hist(d,15); 
                    title(sprintf('IDL=%1d,IDR=%1d',l,r))
                    xlim([-1, 1])
                end
            end
        end
    end
end