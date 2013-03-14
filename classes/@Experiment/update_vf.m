function update_vf(obj)
    if obj.conf.parallelMode==1
        labsConf = findResource(); 
        if matlabpool('size') == 0
            matlabpool(labsConf.ClusterSize); 
        end
        parfor i=1:obj.conf.participants
            p=Participant.load(i,copy(obj.conf));
            p.update_vf();
            p.save();
        end             
    else            
        for i=1:obj.conf.participants
            p=Participant.load(i,copy(obj.conf));
            p.update_vf();
            p.save();
        end
    end
end
