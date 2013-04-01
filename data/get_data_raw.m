function get_data_raw(xp,obj)
    %Get global properties
    global C
    
    [vno,h,grp,ss,idl,idr,r]=size(obj.dataB);
    cntBi=zeros(vno,h,grp,ss,idl,idr);
    cntUn=zeros(length(obj.vnamesU),h,grp,ss,idr);

    for p=1:10
        %Load participant p from disk
        pp=xp(p);
        display(['Now processing participant ' num2str(p)])
        %Choose between group-based or participant-based sorting. 
        if grp==10 
            %Participant-based sorting
            g=p;
        else       
            %Group based sorting
            if any(C==p) 
                %Coupled group
                g=1;
            else         
                %Uncoupled group
                g=2;
            end
        end

        %Iterate over within factors
        for s=1:ss  % session number
            for a=1:idl % left: difficult, easy
                for b=1:idr   % right: difficult, medium, easy
                    for c=1:3 % replication number
                        %Bimanual trials
                        for v=1:vno
                            if strcmp(obj.vtypesB{v},'ls')
                                %Dual handed variables
                                d=pp(s).bimanual{a,b,c}.ls.(obj.vnamesB{v});
                                oldi=cntBi(v,1,g,s,a,b);
                                newi=oldi+length(d);
                                cntBi(v,1,g,s,a,b)=newi;
                                cntBi(v,2,g,s,a,b)=newi;
                                obj.dataB(v,1,g,s,a,b,oldi+1:newi)=d(:);                                
                                obj.dataB(v,2,g,s,a,b,oldi+1:newi)=d(:);
                            else
                                %Avoid single valued functions in non-averaged data
                                if strcmp(obj.vnamesB{v},'IDOwn')   || strcmp(obj.vnamesB{v},'IDOther') || ...
                                   strcmp(obj.vnamesB{v},'IDOwnEf') || strcmp(obj.vnamesB{v},'IDOtherEf')
                                    continue
                                end
                                %Left hand variables
                                d=pp(s).bimanual{a,b,c}.([obj.vtypesB{v} 'L']).(obj.vnamesB{v});
                                oldi=cntBi(v,1,g,s,a,b);
                                newi=oldi+length(d);
                                cntBi(v,1,g,s,a,b)=newi;
                                obj.dataB(v,1,g,s,a,b,oldi+1:newi)=d(:);
                                %Right hand variables
                                d=pp(s).bimanual{a,b,c}.([obj.vtypesB{v} 'R']).(obj.vnamesB{v});
                                oldi=cntBi(v,2,g,s,a,b);
                                newi=oldi+length(d);
                                cntBi(v,2,g,s,a,b)=newi;
                                obj.dataB(v,2,g,s,a,b,oldi+1:newi)=d(:);
                            end
                        end
                        %Unimanual Trials
                        for v=1:length(obj.vnamesU)
                            %Avoid single valued functions in non-averaged data
                            if strcmp(obj.vnamesU{v},'IDOwn')   || strcmp(obj.vnamesU{v},'IDOther') || ...
                               strcmp(obj.vnamesU{v},'IDOwnEf') || strcmp(obj.vnamesU{v},'IDOtherEf')
                                    continue
                            end
                            if b==1
                                d=pp(s).uniLeft{a,c}.(obj.vtypesU{v}).(obj.vnamesU{v});
                                oldi=cntUn(v,1,g,s,a);
                                newi=oldi+length(d);
                                cntUn(v,1,g,s,a)=newi;
                                obj.dataU(v,1,g,s,a,oldi+1:newi)=d(:);
                            end
                            if a==1
                                d=pp(s).uniRight{b,c}.(obj.vtypesU{v}).(obj.vnamesU{v});
                                oldi=cntUn(v,2,g,s,b);
                                newi=oldi+length(d);
                                cntUn(v,2,g,s,b)=newi;
                                obj.dataU(v,2,g,s,b,oldi+1:newi)=d(:);
                            end
                        end                                    
                    end
                end
            end
        end
    end
    obj.obj.dataB=obj.dataB;
    obj.obj.dataU=obj.dataU;
end