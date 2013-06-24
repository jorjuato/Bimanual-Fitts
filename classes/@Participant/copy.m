function new = copy(obj)
%     filename=strcat('temp',random_string(5));
%     filepath=joinpath(tempdir,filename);
%     save(filepath, 'obj');
%     Foo = load(filepath);
%     new = Foo.obj;
%     delete(strcat(filepath,'.mat'));
    if isa('obj','Config')
        new = deepcopy(obj,obj.name);
    else
        new = deepcopy(obj,obj.conf.name);
    end
end
