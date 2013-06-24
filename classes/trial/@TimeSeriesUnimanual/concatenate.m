function concatenate(ts1,ts2)
    idx=ts1.idx;
    if abs(ts1.ph(end)-ts2.ph(1))>pi/4
        %if ts1 ended in near target, pick previous oscillation
        d=diff(ts1.peaks(end-1:end));
        idx=idx(1:end-d);
    end
    ts1.xraw =  [ ts1.xraw(idx) ; ts2.xraw(ts2.idx) ];
    ts1.vraw =  [ ts1.vraw(idx) ; ts2.vraw(ts2.idx) ];
    ts1.araw =  [ ts1.araw(idx) ; ts2.araw(ts2.idx) ];
    
    ts1.compute_idx();
    ts1.compute_fourier();