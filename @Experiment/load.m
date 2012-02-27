function exp = load(experiment)
    display('Method disbled, Experiment wrapps on-disk information now');
    return;
    
    root_dir=joinpath(getuserdir(),'KINARM');
    tmp=load(joinpath(root_dir,'experiment'));
    exp=tmp.experiment;
end
