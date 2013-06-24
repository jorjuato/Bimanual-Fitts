function run(mdl)
    [mdl.t, mdl.ph] = mdl.ode(mdl.eq,mdl.tspan,mdl.IC,mdl.options,mdl.params{:});    
    if mdl.conf.plot, mdl.plot(); end
end