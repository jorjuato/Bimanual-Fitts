function get_trial_vf(obj,ts)
    if obj.conf.use_norm == false
        %Compute bin centers
        Xo = obj.get_bincenters(ts,dim); %WON'T WORKKKKK!!!
        %Compute input vector Y = [x,v]
        if isa(ts,'TimeSeriesUnimanual')
            Y = [ts.x,ts.v];
        elseif strcmp(obj.conf.hand,'L')
            Y = [ts.Lx,ts.Lv];
        elseif strcmp(obj.conf.hand,'R')
            Y = [ts.Rx,ts.Rv];
        else
            return
        end
    else
        %Compute bin centers
        Xo = obj.get_bincenters_normalized();
        %Compute input vector Y = [x,v]
        if isa(ts,'TimeSeriesUnimanual')
            Y = [ts.xnorm,ts.vnorm];
        elseif strcmp(obj.conf.hand,'L')
            Y = [ts.Lxnorm,ts.Lvnorm];
        elseif strcmp(obj.conf.hand,'R')
            Y = [ts.Rxnorm,ts.Rvnorm];
        else
            return
        end
    end
    [~, obj.xo, obj.pc]=obj.prob_2D(Y,Xo,obj.conf.step,obj.conf.minValsToComputeCondProb);
    %[obj.vectors_unfiltered, xo, ~]=obj.KMcoef_2D(obj.xo,obj.pc,1/obj.conf.fs,[1,2]);
    %obj.vectors_unfiltered{end+1} = xo;
    %obj.vectors{1}=KM_Fit(obj.xo,obj.vectors_unfiltered,1);      
    %obj.vectors{2}=KM_Fit(obj.xo,obj.vectors_unfiltered,2); 
end
