function new = deepcopy(obj, n)
    if nargin<2, n='0'; end
    if ~ischar(n), n=num2str(n); end
    
    filename=['temp',n,random_string(5)];
    filepath=joinpath(tempdir,filename);
    save(filepath, 'obj');
    Foo = load(filepath);
    new = Foo.obj;
    delete([filepath,'.mat']);
end