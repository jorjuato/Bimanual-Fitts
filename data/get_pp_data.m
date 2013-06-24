function obj = get_pp_data(pno)
    %Set some globals for data fetching
    if isa(pno,'Participant')
        pp=pno;
    else
        pp=Participant(pno);
    end
    
    global vtypes
    vtypes={'osc','vf','ls'};


    %Define arrays
    obj=get_ANOVA_variables();
    hands=2; idl=2; idr=3; ss=3; r=3;
    
    tic
    obj.dataU=zeros(length(obj.vnamesB),hands,ss,idr,r);
    obj.dataB=zeros(length(obj.vnamesU),hands,ss,idl,idr,r);
    obj = get_pp_data_averaged(pp,obj);
    toc
end

function obj = get_pp_data_averaged(pp,obj)
[~,h,ss,idl,idr,r]=size(obj.dataB);
idx=0;
%Iterate over within factors
for s=1:ss  % session number
    for a=1:idl % left: difficult, easy
        for b=1:idr   % right: difficult, medium, easy
            for c=1:3 % replication number
                %Bimanual trials
                for v=1:length(obj.vnamesB)
                    if strcmp(obj.vtypesB{v},'ls')
                        obj.dataB(v,1,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.ls.(obj.vnamesB{v}));
                        obj.dataB(v,2,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.ls.(obj.vnamesB{v}));
                    else
                        obj.dataB(v,1,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.([obj.vtypesB{v} 'L']).(obj.vnamesB{v}));
                        obj.dataB(v,2,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.([obj.vtypesB{v} 'R']).(obj.vnamesB{v}));
                    end
                end
                %Unimanual Trials
                for v=1:length(obj.vnamesU)
                    if b==1
                        obj.dataU(v,1,s,a,c)=nanmedian(pp(s).uniLeft{a,c}.(obj.vtypesU{v}).(obj.vnamesU{v}));
                    end
                    if a==1
                        obj.dataU(v,2,s,b,c)=nanmedian(pp(s).uniRight{b,c}.(obj.vtypesU{v}).(obj.vnamesU{v}));
                    end
                end
            end
        end
    end
end
end
