function part = load(p,conf)
    if nargin<2, conf=Config(); end
    
    p_name=strcat(strcat('participant',num2str(p,'%03d')),'.mat');
    
    if isa(conf,'char')
        tmp=load(joinpath(conf,p_name));
        conf=Config();
    else
        tmp=load(joinpath(conf.save_path,p_name));
    end
    part=tmp.obj;
    part.conf = conf;
end
