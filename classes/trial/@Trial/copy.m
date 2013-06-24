function new = copy(obj)
%     filename=strcat('temp',random_string(5));
%     filepath=joinpath(tempdir,filename);
%     save(filepath, 'obj');
%     Foo = load(filepath);
%     new = Foo.obj;
%     delete(strcat(filepath,'.mat'));
    new = deepcopy(obj,obj.conf.name);
end
