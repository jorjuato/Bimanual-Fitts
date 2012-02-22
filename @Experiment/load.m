function exp = load(experiment)
    root_dir=joinpath(getuserdir(),'KINARM');
    tmp=load(joinpath(root_dir,'experiment'));
    exp=tmp.experiment;
end
