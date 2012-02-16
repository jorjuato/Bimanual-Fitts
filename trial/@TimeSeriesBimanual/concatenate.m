function concatenate(obj,obj2)    
    %Now, ugly cat, needs cat close to peaks and
    %smoothing around cat-points pka(1)
    obj.Lxraw =  [ obj.Lxraw ; obj2.Lxraw ];
    obj.Lvraw =  [ obj.Lvraw ; obj2.Lvraw ];
    obj.Laraw =  [ obj.Laraw ; obj2.Laraw ];

    obj.Rxraw =  [ obj.Rxraw ; obj2.Rxraw ];
    obj.Rvraw =  [ obj.Rvraw ; obj2.Rvraw ];
    obj.Raraw =  [ obj.Raraw ; obj2.Raraw ];
    
    %He borrado lo de los picos que hacía antes...
%     %Get total peaks
%     [tr.ts.maxPeaksL, tr.ts.minPeaksL] = peakdet(tr.ts.Lx, thr);
%     [tr.ts.maxPeaksR, tr.ts.minPeaksR] = peakdet(tr.ts.Rx, thr);
%     tr.ts.peaksL = sort([tr.ts.maxPeaksL(:,1);tr.ts.minPeaksL(:,1)]);
%     tr.ts.peaksR = sort([tr.ts.maxPeaksR(:,1);tr.ts.minPeaksR(:,1)]);
%     %Get effective ID
%     tr.ts.IDefL = get_ID_effective(tr.ts.Lx,tr.ts.peaksL,tr.ts.ALeft);
%     tr.ts.IDefR = get_ID_effective(tr.ts.Rx,tr.ts.peaksR,tr.ts.ARight);
