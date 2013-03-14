function save(experiment)
    display('Method disbled, Experiment wrapps on-disk information now');
    return;
    
    root_dir=joinpath(getuserdir(),'KINARM');
    save(joinpath(root_dir,'experiment'),'experiment','-v7.3');
end
