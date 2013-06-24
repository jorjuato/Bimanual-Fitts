function setup(mdl)
    %First, set per-model configurations
    if mdl.stype == 0
        mdl.eq=mdl.conf.ode1Da;
        mdl.vf_=mdl.conf.vf1Da;
        mdl.params=mdl.conf.params1Da;
        mdl.parnames=mdl.conf.parnames1Da;
        mdl.IC=mdl.conf.IC1D;
        mdl.vfrange=mdl.conf.vfrange1D;
        mdl.potencial_=mdl.conf.potencial1D;
    elseif mdl.stype == 0.5
        mdl.eq=mdl.conf.ode1Db;
        mdl.vf_=mdl.conf.vf1Db;
        mdl.params=mdl.conf.params1Db;
        mdl.parnames=mdl.conf.parnames1Db;
        mdl.IC=mdl.conf.IC1D;
        mdl.vfrange=mdl.conf.vfrange1D;
        mdl.potencial_=mdl.conf.potencial1D;
    elseif mdl.stype == 1
        mdl.eq=mdl.conf.ode1D;
        mdl.vf_=mdl.conf.vf1D;
        mdl.params=mdl.conf.params1D;
        mdl.parnames=mdl.conf.parnames1D;
        mdl.IC=mdl.conf.IC1D;
        mdl.vfrange=mdl.conf.vfrange1D;
        mdl.potencial_=mdl.conf.potencial1D;
    elseif mdl.stype == 1.1
        mdl.eq=mdl.conf.ode11D;
        mdl.vf_=mdl.conf.vf11D;
        mdl.params=mdl.conf.params11D;
        mdl.parnames=mdl.conf.parnames1D;
        mdl.IC=mdl.conf.IC1D;
        mdl.vfrange=mdl.conf.vfrange1D;
        mdl.potencial_=mdl.conf.potencial11D;
    elseif mdl.stype == 1.2
        mdl.eq=mdl.conf.ode12D;
        mdl.vf_=mdl.conf.vf12D;
        mdl.params=mdl.conf.params12D;
        mdl.parnames=mdl.conf.parnames1D;
        mdl.IC=mdl.conf.IC1D;
        mdl.vfrange=mdl.conf.vfrange1D;
        mdl.potencial_=mdl.conf.potencial12D;         
    elseif mdl.stype == 1.3
        mdl.eq=mdl.conf.ode13D;
        mdl.vf_=mdl.conf.vf13D;
        mdl.params=mdl.conf.params13D;
        mdl.parnames=mdl.conf.parnames1D;
        mdl.IC=mdl.conf.IC1D;
        mdl.vfrange=mdl.conf.vfrange1D;
        mdl.potencial_=mdl.conf.potencial13D;        
    elseif mdl.stype == 1.4
        mdl.eq=mdl.conf.ode14D;
        mdl.vf_=mdl.conf.vf14D;
        mdl.params=mdl.conf.params14D;
        mdl.parnames=mdl.conf.parnames1D;
        mdl.IC=mdl.conf.IC1D;
        mdl.vfrange=mdl.conf.vfrange1D;
        mdl.potencial_=mdl.conf.potencial14D;             
    elseif mdl.stype == 1.5
        mdl.eq=mdl.conf.ode15D;
        mdl.vf_=mdl.conf.vf15D;
        mdl.params=mdl.conf.params15D;
        mdl.parnames=mdl.conf.parnames15D;
        mdl.IC=mdl.conf.IC1D;
        mdl.vfrange=mdl.conf.vfrange1D;
        mdl.potencial_=mdl.conf.potencial15D;  
    elseif mdl.stype == 1.6
        mdl.eq=mdl.conf.ode16D;
        mdl.vf_=mdl.conf.vf16D;
        mdl.params=mdl.conf.params16D;
        mdl.parnames=mdl.conf.parnames16D;
        mdl.IC=mdl.conf.IC1D;
        mdl.vfrange=mdl.conf.vfrange1D;
        mdl.potencial_=mdl.conf.potencial16D;
    elseif mdl.stype == 1.7
        mdl.eq=mdl.conf.ode17D;
        mdl.vf_=mdl.conf.vf17D;
        mdl.params=mdl.conf.params17D;
        mdl.parnames=mdl.conf.parnames17D;
        mdl.IC=mdl.conf.IC1D;
        mdl.vfrange=mdl.conf.vfrange1D;
        mdl.potencial_=mdl.conf.potencial17D;                
    elseif mdl.stype == 2
        mdl.eq=mdl.conf.ode2D;
        mdl.vf_=mdl.conf.vf2D;
        mdl.params=mdl.conf.params2D;
        mdl.parnames=mdl.conf.parnames2D;
        mdl.IC=mdl.conf.IC2D;
        mdl.vfrange=mdl.conf.vfrange2D;
        mdl.nc1=mdl.conf.nc1;
        mdl.nc2=mdl.conf.nc2;
    elseif mdl.stype == 2.5
        mdl.eq=mdl.conf.ode25D;
        mdl.vf_=mdl.conf.vf25D;
        mdl.params=mdl.conf.params25D;
        mdl.parnames=mdl.conf.parnames25D;
        mdl.IC=mdl.conf.IC2D;
        mdl.vfrange=mdl.conf.vfrange2D;        
        mdl.nc1_25D=mdl.conf.nc1;
        mdl.nc2_25D=mdl.conf.nc2;
    elseif mdl.stype == 3
        mdl.eq=mdl.conf.ode2D;
        mdl.vf_=mdl.conf.vf2D;
        mdl.params=mdl.conf.params2Dc;
        mdl.parnames=mdl.conf.parnames2D;
        mdl.IC=mdl.conf.IC2D;
        mdl.vfrange=mdl.conf.vfrange2D;
        mdl.nc1=mdl.conf.nc1;
        mdl.nc2=mdl.conf.nc2;
    else
        error('Model type unknown')
    end

    %Common options to all models
    
    mdl.ncrange=mdl.conf.ncrange;
    mdl.ph_periods=mdl.conf.ph_periods;
    mdl.tspan=mdl.conf.tspan;
    mdl.ode=mdl.conf.ode;
    mdl.options=mdl.conf.options;
    mdl.bins=mdl.conf.bins;
end