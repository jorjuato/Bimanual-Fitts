function runby_param(mdl,pname,prange)
    if ~any(strcmp(pname,mdl.parnames))
        error(['Parameter ' pname ' does not exist for current model type: ', num2str(mdl.stype)])
    end
    pres=cell(length(prange),1);
    prange=sort(prange);

    %Set options for parametrization
    tspanstatus=mdl.tspan;
    p0=mdl.params;
    pltstatus=mdl.conf.plot;
    mdl.conf.plot=0;
    mdl.ode=mdl.conf.ode;
    mdl.options=mdl.conf.options;
    mdl.tspan=[0,4*pi];

    %Recursive run simulations
    for i=1:length(prange)
        mdl.subs_param(pname,prange(i));
        mdl.run();
        pres{i}=struct( 't',     mdl.t,    'ph',    mdl.ph,...
                        'p',     prange(i));
    end
    %Store simulations
    mdl.pset{end+1}={pname,prange,p0,pres};

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