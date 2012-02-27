function save(obj)  
    root_dir=joinpath(getuserdir(),'KINARM');
    if ischar(obj.conf.name)
        name = obj.conf.name;
    else
        name=strcat('participant',num2str(obj.conf.name,'%03d'));
    end
    save(joinpath(obj.conf.save_dir,name),'obj','-v7.3');
end
