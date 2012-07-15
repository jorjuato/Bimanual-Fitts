function timing=get_timing_diffs(block)
    if ~isa(block,'Block')
        error('Need a Block instance to process timing data')
    elseif length(size(block.data_set)) < 3
        error('Need a Bimanual Block to process timing data')
    end
    
    data=block.data_set;
    [idl,idr,repl]=size(data);
    timing=cell(idl,idr);       
    
    for l=1:idl
        for r=1:idr
            %enable parallel mode...
            if matlabpool('size') == 0,
                labsConf = findResource();
                labsConf.clusterSize=3;
                matlabpool(labsConf.clusterSize);
            end
            for rep=1:repl-1
                timing{l,r}=[timing{l,r}(:);data{l,r,rep}.ts.minPeakDistanceNorm];
            end
        end
    end
    
    %C=[2,3,6,8,9];U=[1,4,5,7,10];
end