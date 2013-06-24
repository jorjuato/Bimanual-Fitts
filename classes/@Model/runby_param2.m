function runby_param2(mdl,pnames,pranges)
    if ~any(strcmp(pnames{1},mdl.parnames)) 
        error(['Parameter ' pnames{1} ' does not exist for current model type: ', num2str(mdl.stype)])
    elseif ~any(strcmp(pnames{2},mdl.parnames))
        error(['Parameter ' pnames{2} ' does not exist for current model type: ', num2str(mdl.stype)])
    end
    %Prepare model and ranges
    pres=cell(length(pranges{1}),length(pranges{1}),1);
    prange1=sort(pranges{1});
    prange2=sort(pranges{2});

    %Set options for parametrization
    tspanstatus=mdl.tspan;
    p0=mdl.params;
    pltstatus=mdl.conf.plot;
    %mdl.conf.plot=0;
    mdl.ode=mdl.conf.ode;
    mdl.options=mdl.conf.options;
    mdl.tspan=[0,10*pi];
    mdl.load_param(p0);    
    %Fetch data
    for i=1:length(prange1)
        for j=1:length(prange2)
            mdl.subs_param(pnames{1},prange1(i));
            mdl.subs_param(pnames{2},prange2(j));
            mdl.run();
            pres{i,j}=struct( 't',     mdl.t,     'ph',       mdl.ph,...                              
                              'p1',    prange1(i),'p2',       prange2(j));
        end
    end
    %Store simulations
    mdl.ppset{end+1}={pnames,pranges,p0,pres};

    %Restore options state
    mdl.load_param(p0);
    mdl.conf.plot=pltstatus;
    mdl.ode=mdl.conf.ode;
    mdl.options=mdl.conf.options;
    mdl.tspan=tspanstatus;
    if mdl.conf.plot==1
        mdl.plot_param()
    end
end