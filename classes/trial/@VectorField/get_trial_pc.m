function get_trial_pc(obj,ts)

    f = obj.conf.fs / obj.conf.samplerate;
    [BF,AF] = butter(4,12/(obj.conf.samplerate/2),'low');
    
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

    %Get Conditional Probability Matrices
    [~, obj.xo, obj.pc]=obj.prob_2D(Y,obj.conf.bins,obj.conf.step,obj.conf.minValsToComputeCondProb);
    
    %Get Vector fields
    if obj.conf.store_vf==1        
        obj.get_trial_vf();
    end
end
