function dataRel = get_all_data_rel(obj)
    %Get global properties    
    [v,h,pp,ss,idl,idr,r]=size(obj.dataB);
    dataRel=zeros(v,h,pp,ss,idl,idr,r);

    for p=1:pp
        %Iterate over within factors
        for s=1:ss  % session number
            for a=1:idl % left: difficult, easy
                for b=1:idr   % right: difficult, medium, easy
                    for c=1:3 % replication number
                        %Bimanual trials
                        for v=1:length(obj.vnamesB)
                            if strcmp(obj.vtypesB{v},'ls')
                                continue
                            else
                                vu=strcmp(obj.vnamesB{v},obj.vnamesU);
                                if any(vu)
                                    dataRel(v,1,p,s,a,b,c)=squeeze(obj.dataB(v,1,p,s,a,b,c))/nanmean(squeeze(obj.dataU(vu,1,p,s,a,:))); 
                                    dataRel(v,2,p,s,a,b,c)=squeeze(obj.dataB(v,2,p,s,a,b,c))/nanmean(squeeze(obj.dataU(vu,2,p,s,b,:)));
                                end
                            end
                        end                                    
                    end
                end
            end
        end
    end
end
