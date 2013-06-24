function runby_IC(mdl,ph0in)
    %Run model with varying initial conditions
    %Each trajectory obtained is stored in
    %Model.pset cell array
    %
    % Input:
    %   ph0: Array of initial condition with
    %        different size depending on model
    %        dimensions: [ICno, dim]

    %Get trayectories for this systems.
    if mdl.stype<2
        if size(ph0in,1)==1
            ph0set=ph0in';
        elseif size(ph0in,2)==1
            ph0set=ph0in;
        else
            error('Wrong dimensions for IC array: [IC_len, Model_dims]')
        end
    else
        if size(ph0in,1)==2 && size(ph0in,2)==2
            ph0set=ph0in;
        elseif size(ph0in,1)==2
            ph0set=ph0in';
        elseif size(ph0in,2)==2
            ph0set=ph0in;
        else
            error('Wrong dimensions for IC array: [IC_len, Model_dims]')
        end
    end

    icres=cell(length(ph0set),1);

    %Set options
    tspan_status=mdl.tspan;
    plt_status=mdl.conf.plot;
    %stoch_status=mdl.conf.stoch;
    mdl.conf.plot=0;
    %mdl.conf.stoch=0;
    %mdl.ode=mdl.conf.ode;
    mdl.options=mdl.conf.options;
    mdl.tspan=[0,4*pi];

    %Run simulations
    for i=1:length(ph0set)
        mdl.IC=ph0set(i,:);
        mdl.run();
        icres{i}=struct( 't',     mdl.t,...
                         'ph',    mdl.ph,...
                         'ph0',   mdl.IC);
    end

    %Store simulations
    mdl.icset{end+1}={ph0set,mdl.params,icres};

    %Restore options state
    mdl.conf.plot=plt_status;
    %mdl.conf.stoch=stoch_status;
    mdl.tspan=tspan_status;
    %mdl.ode=mdl.conf.ode;
    mdl.options=mdl.conf.options;
    if mdl.conf.plot==1
        mdl.plot_IC()
    end
end