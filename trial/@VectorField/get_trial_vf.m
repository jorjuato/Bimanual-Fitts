function get_trial_vf(obj,ts)
    if obj.use_norm == false
        %Compute bin centers
        Xo = obj.get_bincenters(ts,dim); %WON'T WORKKKKK!!!
        %Compute input vector Y = [x,v]
        if isa(ts,'TimeSeriesUnimanual')
            Y = [ts.x,ts.v];
        elseif strcmp(obj.hand,'L')
            Y = [ts.Lx,ts.Lv];
        elseif strcmp(obj.hand,'R')
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
        elseif strcmp(obj.hand,'L')
            Y = [ts.Lxnorm,ts.Lvnorm];
        elseif strcmp(obj.hand,'R')
            Y = [ts.Rxnorm,ts.Rvnorm];
        else
            return
        end
    end
    [~, obj.xo, obj.pc]=obj.prob_2D(Y,Xo,obj.step,obj.minValsToComputeCondProb);
end