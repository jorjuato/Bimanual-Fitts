function exp = load_participants(obj)
    if nargin == 1 & isa(obj,'Experiment')
        exp = obj;
    else
        conf=Config();
        oldmemcfg=conf.inmemory;
        conf.inmemory=0;
        exp=Experiment(conf);
        exp.conf.inmemory=oldmemcfg;
    end
    for p=1:10        
        filename=joinpath(exp.conf.save_path,strcat('participant',num2str(p,'%03d')));
        tmp=load(filename);
        exp.participants(p,1)=tmp.obj;
    end
end
