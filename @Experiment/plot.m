function plot(obj,parallelMode)
    if nargin==1, parallelMode=1; end
    
    plot_dir=joinpath(joinpath(getuserdir(),'KINARM'),'plots');
    if ~exist(plot_dir)
        mkdir(plot_dir);
    end
    
    if parallelMode==1
        labsConf = findResource(); 
        if matlabpool('size') == 0
            matlabpool(labsConf.ClusterSize); 
        end
        parfor i=1:obj.size
            p=Participant.load(i,obj.path);
            plot(p);
        end             
    else            
        for i=1:obj.size
            p=Participant.load(i,obj.path);
            plot(p);
        end
    end   
end
