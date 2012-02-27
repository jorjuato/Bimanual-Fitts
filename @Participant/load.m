function part = load(p,path)
    if nargin<2, path=joinpath(getuserdir(),'KINARM'); end
    
    p_name=strcat(strcat('participant',num2str(p,'%03d')),'.mat');
    tmp=load(joinpath(path,p_name));
    part=tmp.obj;
end
