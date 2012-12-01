function get_trial_vf(obj,ts)

    f= obj.conf.fs / obj.conf.samplerate;
    [BF,AF]=butter(4,12/(obj.conf.samplerate/2),'low');
    
    %Compute input vector Y = [x,v]
    if isa(ts,'TimeSeriesUnimanual')
        nsz = fix(length(ts.xnorm)/f);
        Y = [filtfilt(BF,AF,upsample2(ts.xnorm,nsz)),filtfilt(BF,AF,upsample2(ts.vnorm,nsz))];
    elseif strcmp(obj.conf.hand,'L')
        nsz = fix(length(ts.Lxnorm)/f);
        Y = [filtfilt(BF,AF,upsample2(ts.Lxnorm,nsz)),filtfilt(BF,AF,upsample2(ts.Lvnorm,nsz))  ];
    elseif strcmp(obj.conf.hand,'R')
        nsz = fix(length(ts.Rxnorm)/f);
        Y = [filtfilt(BF,AF,upsample2(ts.Rxnorm,nsz)),filtfilt(BF,AF,upsample2(ts.Rvnorm,nsz))];
    else
        return
    end
    
    [~, obj.xo, obj.pc]=obj.prob_2D(Y,obj.conf.bins,obj.conf.step,obj.conf.minValsToComputeCondProb);
    %[obj.vectors_unfiltered, xo, ~]=obj.KMcoef_2D(obj.xo,obj.pc,1/obj.conf.fs,[1,2]);
    %obj.vectors_unfiltered{end+1} = xo;
    %obj.vectors{1}=KM_Fit(obj.xo,obj.vectors_unfiltered,1);      
    %obj.vectors{2}=KM_Fit(obj.xo,obj.vectors_unfiltered,2); 
end
