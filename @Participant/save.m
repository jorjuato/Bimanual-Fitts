function save(obj)  
    root_dir=joinpath(getuserdir(),'KINARM');
    if ischar(obj.name)
        name = obj.name;
    else
        name=strcat('participant',num2str(obj.name,'%03d'));
    end
    save(joinpath(root_dir,name),'obj','-v7.3');
end
