function new = copy(obj)
    filename=strcat('temp',random_string(5));
    save(filename, 'obj');
    Foo = load(filename);
    new = Foo.obj;
    delete(strcat(filename,'.mat'));
end
