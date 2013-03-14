function exp = load(obj)
    conf=Config();
    tmp=load(joinpath(conf.save_path,'experiment.mat'));
    exp=tmp.experiment;
    
    for i=1:length(exp.participants)
        exp.participants(i).conf=conf;
        exp.participants(i).update_conf(conf);
    end
end
