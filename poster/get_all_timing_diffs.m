function [P_timing,P_timingN]=get_all_timing_diffs()
%     if nargin==0, xp=Experiment(); end
%         
%     if ~isa(xp,'Experiment')
%         error('Need a Experiment instance to process timing data')
%     end
    
    %enable parallel mode...
    if matlabpool('size') == 0,
        labsConf = findResource();
        labsConf.clusterSize=5;
        matlabpool(labsConf.clusterSize);
    end
    
    P_timing={};
    P_timingN={};
    tic
    parfor p=1:10
        S_timing={};
        S_timingN={};
        pp=Participant.load(p);
        %pp=xp_prime(p);
        for s=1:3
            data=pp(s).bimanual.data_set;
            [idl,idr,repl]=size(data);
            B_timing=cell(idl,idr);
            B_timingN=cell(idl,idr);
            for l=1:idl
                for r=1:idr            
                    for rep=1:repl-1
                        B_timing{l,r} =[B_timing{l,r}(:);data{l,r,rep}.ts.minPeakDistance];
                        B_timingN{l,r}=[B_timing{l,r}(:);data{l,r,rep}.ts.minPeakDistanceNorm];
                    end
                end
            end
            S_timing{s}=B_timing;
            S_timingN{s}=B_timingN;
        end
        P_timing{p} =S_timing;
        P_timingN{p}=S_timingN;
    end
    toc
end