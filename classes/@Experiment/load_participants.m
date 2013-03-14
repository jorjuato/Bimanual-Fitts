function xp = load_participants(obj)
    if nargin == 1 && isa(obj,'Experiment')
        xp = obj;
    else
        conf=Config();
        oldmemcfg=conf.inmemory;
        conf.inmemory=0;
        xp=Experiment(conf);
        xp.conf.inmemory=oldmemcfg;
    end
    for p=1:10        
        filename=joinpath(xp.conf.save_path,strcat('participant',num2str(p,'%03d')));
        tmp=load(filename);
        xp.participants(p)=tmp.obj;
    end
end
