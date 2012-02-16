function new = copy(obj)
    save('temp.mat', 'obj');
    Foo = load('temp.mat');
    new = Foo.obj;
    delete('temp.mat');
end