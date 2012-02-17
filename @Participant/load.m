function part = load(p)
    root_dir=joinpath(getuserdir(),'KINARM');
    p_name=strcat(strcat('participant',num2str(p,'%03d')),'.mat');
    tmp=load(joinpath(root_dir,p_name));
    part=tmp.obj;
end
