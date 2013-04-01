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
    
    if obj.conf.use_pc==1
        %Get Conditional Probability Matrices
        [~, obj.xo, obj.pc]=obj.prob_2D(Y,obj.conf.bins,obj.conf.step,obj.conf.minValsToComputeCondProb);
    else
        %Get Conditional Probability Matrices
        [~, obj.xo, pc]=obj.prob_2D(Y,obj.conf.bins,obj.conf.step,obj.conf.minValsToComputeCondProb);
        %Get Unfiltered vectors
        [obj.vectors_unfiltered_, xo, ~]=obj.KMcoef_2D(obj.xo,pc,1/obj.conf.fs,[1,2]);
        obj.vectors_unfiltered_{end+1} = xo;
        %Fit vector field to polinomial functions
        if obj.conf.fitorder>0       
            obj.vectors_{1}=obj.KM_Fit(obj.xo,obj.vectors_unfiltered_,1);      
            obj.vectors_{2}=obj.KM_Fit(obj.xo,obj.vectors_unfiltered_,2);
        end
        %Get  vector angles
        absAngles = atan2(obj.vectors{1},obj.vectors{2});
        angDiff = obj.eval_neighbours(absAngles, obj.conf.neighbourhood, @obj.get_maxAngle);
        obj.angles_ = {absAngles, angDiff};
    end
end
