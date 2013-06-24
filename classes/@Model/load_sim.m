function load_sim(mdl,sim)
    size([sim.t])
    mdl.t = [sim.t];
    mdl.ph = [sim.ph];
    mdl.load_param([sim.params]);
end