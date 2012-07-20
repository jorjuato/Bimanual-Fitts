function plot_block_peakDelays(blk)
    for l=1:2
        for r=1:3
            d=[];
            for s=1:3
                tr=blk{l,r,s};
                pks=tr.oscR.minPeakDistance/1000;
                if length(tr.oscR.MT) == length(pks)
                    d=[d;pks./tr.oscR.MT];
                else
                    d=[d;pks./tr.oscL.MT];
                end
            end
            figure;
            hist(d,15); 
            title(sprintf('IDL=%1d,IDR=%1d',l,r))
            xlim([-1, 1])
        end
    end
end