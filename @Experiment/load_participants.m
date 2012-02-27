function exp = load_participants()
    display('Method disbled, Experiment wrapps on-disk information now');
    return
    
    exp=Experiment();
    root_dir=joinpath(getuserdir(),'KINARM');
    for p=1:10        
        filename=joinpath(root_dir,strcat('participant',num2str(p,'%03d')));
        tmp=load(filename);
        exp.participants(p,1)=tmp.obj;
    end
end
