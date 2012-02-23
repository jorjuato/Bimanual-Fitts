function update_vf(obj)
    labsConf = findResource(); 
    if matlabpool('size') == 0
        matlabpool(labsConf.ClusterSize); 
    end
    parfor i=1:length(obj.participants)
        part=obj.participants(i);
        part.update_vf();
    end
end
