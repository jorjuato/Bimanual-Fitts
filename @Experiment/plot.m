function plot(obj)    
    if ~exist(obj.conf.plot_dir)
        mkdir(obj.conf.plot_dir);
    end
    
    if obj.conf.parallelMode==1
        labsConf = findResource(); 
        if matlabpool('size') == 0
            matlabpool(labsConf.ClusterSize); 
        end
        parfor i=1:obj.size
            p=Participant.load(i,copy(obj.conf));
            plot(p);
        end             
    else            
        for i=1:obj.size
            p=Participant.load(i,(obj.conf));
            plot(p);
        end
    end   
end
