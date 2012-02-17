function save(experiment)
    root_dir=joinpath(getuserdir(),'KINARM');
    save(joinpath(root_dir,'experiment'),'experiment','-v7.3');
end
