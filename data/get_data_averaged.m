function get_data_averaged(xp,obj)
    %Get global properties
    global C
    
    [~,h,grp,ss,idl,idr,r]=size(obj.dataB);

    %Prepare indexes for group-based or participant-based sorting. 
    if grp==10
        i=zeros(10,1);
    else    
        i=zeros(2,1);        
    end

    for p=1:10     % participant number
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
                %Coupled group = 1
                g=1;
            else         
                %Uncoupled group = 2
                g=2;
            end
        end
        %Increase count for this participant/group
        i(g)=i(g)+1;

        %Iterate over within factors
        for s=1:ss  % session number
            for a=1:idl % left: difficult, easy
                for b=1:idr   % right: difficult, medium, easy
                    for c=1:3 % replication number
                        %Compute index based on i vector and actual replication
                        %For participant-based sorting, it equals to reps
                        idx=(i(g)-1)*3+c;
                        %Bimanual trials
                        for v=1:length(obj.vnamesB)
                            if strcmp(obj.vtypesB{v},'ls')
                                obj.dataB(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ls.(obj.vnamesB{v}));
                                obj.dataB(v,2,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ls.(obj.vnamesB{v}));
                            else
                                obj.dataB(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.([obj.vtypesB{v} 'L']).(obj.vnamesB{v}));
                                obj.dataB(v,2,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.([obj.vtypesB{v} 'R']).(obj.vnamesB{v}));
                            end
                        end
                        %Unimanual Trials
                        for v=1:length(obj.vnamesU)
                            if b==1
                                obj.dataU(v,1,g,s,a,idx)=nanmedian(pp(s).uniLeft{a,c}.(obj.vtypesU{v}).(obj.vnamesU{v}));
                            end
                            if a==1
                                obj.dataU(v,2,g,s,b,idx)=nanmedian(pp(s).uniRight{b,c}.(obj.vtypesU{v}).(obj.vnamesU{v}));
                            end
                        end                                    
                    end
                end
            end
        end
    end
end