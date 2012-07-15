function plot(obj) 
    if ~exist(obj.conf.plot_path,'dir')
        mkdir(obj.conf.plot_path);
    end
    
    pps=1:10;
    
    if obj.conf.parallelMode==1
        labsConf = findResource(); 
        if matlabpool('size') == 0
            %matlabpool(labsConf.ClusterSize); 
            matlabpool(obj.conf.workers)
            %matlabpool local 2;
        end
        if obj.conf.inmemory == 1
            parfor i=1:10
                plot(obj.participants(i));
            end
        else
            parfor i=1:10
                p=Participant.load(i,copy(obj.conf));
                plot(p);
            end
        end             
    elseif obj.conf.inmemory == 1
	    for i=pps
            plot(obj.participants(i));
	    end
	else           
        for i=pps
            p=Participant.load(i,(obj.conf));
            plot(p);
        end
    end   
end
