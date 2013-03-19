function dataRel = get_data_rel(dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi)
    %Get global properties
    [v,h,pp,ss,idl,idr,r]=size(dataBi);
    dataRel=zeros(v,h,pp,ss,idl,idr,r);    

    for p=1:pp
        %Iterate over within factors
        for s=1:ss  % session number
            for a=1:idl % left: difficult, easy
                for b=1:idr   % right: difficult, medium, easy
                    for c=1:3 % replication number
                        %Bimanual trials
                        for v=1:length(varnamesBi)
                            if strcmp(vartypesBi{v},'ls')
                                continue
                            else
                                vu=strcmp(varnamesBi{v},varnamesUn);
                                if any(vu)
                                    dataRel(v,1,p,s,a,b,c)=squeeze(dataBi(v,1,p,s,a,b,c))/nanmean(squeeze(dataUn(vu,1,p,s,a,:))); 
                                    dataRel(v,2,p,s,a,b,c)=squeeze(dataBi(v,2,p,s,a,b,c))/nanmean(squeeze(dataUn(vu,2,p,s,b,:)));
                                end
                            end
                        end                                    
                    end
                end
            end
        end
    end
end