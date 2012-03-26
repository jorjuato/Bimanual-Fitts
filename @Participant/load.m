function part = load(p,conf)
    if nargin<2, conf=Config(); end
    name=strcat('participant',num2str(p,'%03d'));
    p_name=strcat(name,'.mat');
    
    if isa(conf,'char')
        tmp=load(joinpath(conf,p_name));
        conf=Config();
    else
        tmp=load(joinpath(conf.save_path,p_name));
    end
    conf.name=name;
    part=tmp.obj;
    part.conf=copy(conf);
    part.update_conf(copy(conf));
end
