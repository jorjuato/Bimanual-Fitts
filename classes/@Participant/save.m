function save(obj)  
    if ischar(obj.conf.name)
        name = obj.conf.name;
    else
        name=strcat('participant',num2str(obj.conf.name,'%03d'));
    end
    save(joinpath(obj.conf.save_path,name),'obj','-v7.3');
end
