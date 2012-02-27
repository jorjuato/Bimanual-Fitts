function update_vf(obj,parallelMode)
    if nargin<2, parallelMode=1; end

    if parallelMode==1
        labsConf = findResource(); 
        if matlabpool('size') == 0
            matlabpool(labsConf.ClusterSize); 
        end
        parfor i=1:obj.size
            p=Participant.load(i,obj.path);
            p.update_vf();
            p.save();
        end             
    else            
        for i=1:obj.size
            p=Participant.load(i,obj.path);
            p.update_vf();
            p.save();
        end
    end
end
