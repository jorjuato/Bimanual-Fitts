function concatenate(ts1,ts2)
    idx=ts1.idx;
    ts1.Lxraw =  [ ts1.Lxraw(idx) ; ts2.Lxraw(ts2.idx) ];
    ts1.Lvraw =  [ ts1.Lvraw(idx) ; ts2.Lvraw(ts2.idx) ];
    ts1.Laraw =  [ ts1.Laraw(idx) ; ts2.Laraw(ts2.idx) ];

    ts1.Rxraw =  [ ts1.Rxraw(idx) ; ts2.Rxraw(ts2.idx) ];
    ts1.Rvraw =  [ ts1.Rvraw(idx) ; ts2.Rvraw(ts2.idx) ];
    ts1.Raraw =  [ ts1.Raraw(idx) ; ts2.Raraw(ts2.idx) ];    

    ts1.compute_idx();
    ts1.compute_fourier();