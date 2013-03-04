function [dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn] = get_data(xp,grp,avg,eff)
    if nargin<1,xp=Experiment();end
    if nargin<2,grp=0;end
    if nargin<3,avg=1;end
    if nargin<4,eff=0;end

    %Set some globals for data fetching
    global vtypes
    global C
    vtypes={'ts','osc','vf','ls'};
    %vtypes={'ts','osc','ls'};
    C=[2,3,6,8,9];
    max_raw_data=1000;
    

    %Define arrays
    [varnamesBi, vartypesBi, varnamesUn, vartypesUn] = get_variables();
    if grp==1, g=2; else g=10; end
    if avg==1, r=0; else r=3; end
    hands=2; idl=2; idr=3; ss=3; 


    tic
    if avg==1 && eff==0
        dataUn=zeros(length(varnamesBi),hands,g,ss,idr,r);
        dataBi=zeros(length(varnamesUn),hands,g,ss,idl,idr,r);
        [dataBi,dataUn] = get_data_averaged(xp,dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn);
    elseif eff==1
        dataUn=zeros(length(varnamesBi),hands,g,ss,idr,max_raw_data)*NaN;
        dataBi=zeros(length(varnamesUn),hands,g,ss,idl,idr,max_raw_data)*NaN;
        [dataBi,dataUn] = get_data_eff(xp,dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn);
    elseif avg==0 
        dataUn=zeros(length(varnamesBi),hands,g,ss,idr,max_raw_data);
        dataBi=zeros(length(varnamesUn),hands,g,ss,idl,idr,max_raw_data);
        [dataBi,dataUn] = get_data_raw(xp,dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn);
    else
        error('There is something wrong with your options!')
    end
    toc
end

function [dataBi,dataUn] = get_data_averaged(xp,dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn)
    %Get global properties
    global C
    [~,h,grp,ss,idl,idr,r]=size(dataBi);

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
        if grp==10 %Participant-based sorting
            g=p;
        else       %Group based sorting
            if any(C==p) %Coupled group has index 1
                g=1;
            else         %Uncoupled group has  index 2
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
                        for v=1:length(varnamesBi)
                            if strcmp(vartypesBi{v},'ts')
                                if strcmp(varnamesBi{v},'Harmonicity') || strcmp(varnamesBi{v},'Circularity') || strcmp(varnamesBi{v},'IDef') || strcmp(varnamesBi{v},'f')
                                    dataBi(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ts.(['L' varnamesBi{v}]));
                                    dataBi(v,2,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ts.(['R' varnamesBi{v}]));
                                else
                                    dataBi(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ts.(varnamesBi{v}));
                                    dataBi(v,2,g,s,a,b,idx)=-nanmedian(pp(s).bimanual{a,b,c}.ts.(varnamesBi{v}));
                                end
                            elseif strcmp(vartypesBi{v},'osc')
                                dataBi(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.oscL.(varnamesBi{v}));
                                dataBi(v,2,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.oscR.(varnamesBi{v}));
                            elseif strcmp(vartypesBi{v},'vf')
                                dataBi(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.vfL.(varnamesBi{v}));
                                dataBi(v,2,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.vfR.(varnamesBi{v}));
                            else
                                dataBi(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ls.(varnamesBi{v}));
                                dataBi(v,2,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ls.(varnamesBi{v}));
                            end
                        end
                        %Unimanual Trials
                        for v=1:length(varnamesUn)
                            if b==1
                                dataUn(v,1,g,s,a,idx)=nanmedian(pp(s).uniLeft{a,c}.(vartypesUn{v}).(varnamesUn{v}));
                            end
                            if a==1
                                dataUn(v,2,g,s,b,idx)=nanmedian(pp(s).uniRight{b,c}.(vartypesUn{v}).(varnamesUn{v}));
                            end
                        end                                    
                    end
                end
            end
        end
    end
end


function [dataBi,dataUn] = get_data_raw(xp,dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn)
    %Get global properties
    global C
    [vno,h,grp,ss,idl,idr,r]=size(dataBi);
    cntBi=zeros(vno,h,grp,ss,idl,idr);
    cntUn=zeros(length(varnamesUn),h,grp,ss,idr);

    for p=1:10     % participant number
        %Load participant p from disk
        pp=xp(p);
        display(['Now processing participant ' num2str(p)])
        %Choose between group-based or participant-based sorting. 
        if grp==10 %Participant-based sorting
            g=p;
        else       %Group based sorting
            if any(C==p) %Coupled group has index 1
                g=1;
            else         %Uncoupled group has  index 2
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
                            if strcmp(vartypesBi{v},'ts')
                                if strcmp(varnamesBi{v},'Harmonicity') || strcmp(varnamesBi{v},'Circularity') || strcmp(varnamesBi{v},'IDef') || strcmp(varnamesBi{v},'f')
                                    
                                    d=pp(s).bimanual{a,b,c}.ts.(['L' varnamesBi{v}]);
                                    oldi=cntBi(v,1,g,s,a,b);
                                    newi=oldi+length(d);
                                    cntBi(v,1,g,s,a,b)=newi;
                                    dataBi(v,1,g,s,a,b,oldi+1:newi)=d(:);
                                    
                                    d=pp(s).bimanual{a,b,c}.ts.(['R' varnamesBi{v}]);
                                    oldi=cntBi(v,2,g,s,a,b);
                                    newi=oldi+length(d);
                                    cntBi(v,2,g,s,a,b)=newi;
                                    dataBi(v,2,g,s,a,b,oldi+1:newi)=d(:);
                                else
                                    d=pp(s).bimanual{a,b,c}.ts.(varnamesBi{v});
                                    oldi=cntBi(v,1,g,s,a,b);
                                    newi=oldi+length(d);
                                    cntBi(v,1,g,s,a,b)=newi;
                                    dataBi(v,1,g,s,a,b,oldi+1:newi)=d(:);
                                    
                                    d=pp(s).bimanual{a,b,c}.ts.(varnamesBi{v});
                                    oldi=cntBi(v,2,g,s,a,b);
                                    newi=oldi+length(d);
                                    cntBi(v,2,g,s,a,b)=newi;
                                    dataBi(v,2,g,s,a,b,oldi+1:newi)=d(:);
                                end
                            elseif strcmp(vartypesBi{v},'osc')
                                d=pp(s).bimanual{a,b,c}.oscL.(varnamesBi{v});
                                oldi=cntBi(v,1,g,s,a,b);
                                newi=oldi+length(d);
                                cntBi(v,1,g,s,a,b)=newi;
                                dataBi(v,1,g,s,a,b,oldi+1:newi)=d(:);
                                
                                d=pp(s).bimanual{a,b,c}.oscR.(varnamesBi{v});
                                oldi=cntBi(v,2,g,s,a,b);
                                newi=oldi+length(d);
                                cntBi(v,2,g,s,a,b)=newi;
                                dataBi(v,2,g,s,a,b,oldi+1:newi)=d(:);
                            elseif strcmp(vartypesBi{v},'vf')
                                d=pp(s).bimanual{a,b,c}.vfL.(varnamesBi{v});
                                oldi=cntBi(v,1,g,s,a,b);
                                newi=oldi+length(d);
                                cntBi(v,1,g,s,a,b)=newi;
                                dataBi(v,1,g,s,a,b,oldi+1:newi)=d(:);
                                
                                d=pp(s).bimanual{a,b,c}.vfR.(varnamesBi{v});
                                oldi=cntBi(v,2,g,s,a,b);
                                newi=oldi+length(d);
                                cntBi(v,2,g,s,a,b)=newi;
                                dataBi(v,2,g,s,a,b,oldi+1:newi)=d(:);
                            else
                                d=pp(s).bimanual{a,b,c}.ls.(varnamesBi{v});
                                oldi=cntBi(v,1,g,s,a,b);
                                newi=oldi+length(d);
                                cntBi(v,1,g,s,a,b)=newi;
                                cntBi(v,2,g,s,a,b)=newi;
                                dataBi(v,1,g,s,a,b,oldi+1:newi)=d(:);                                
                                dataBi(v,2,g,s,a,b,oldi+1:newi)=d(:);
                            end
                        end
                        %Unimanual Trials
                        for v=1:length(varnamesUn)
                            if b==1
                                d=pp(s).uniLeft{a,c}.(vartypesUn{v}).(varnamesUn{v});
                                oldi=cntUn(v,1,g,s,a);
                                newi=oldi+length(d);
                                cntUn(v,1,g,s,a)=newi;
                                dataUn(v,1,g,s,a,oldi+1:newi)=d(:);
                            end
                            if a==1
                                d=pp(s).uniRight{b,c}.(vartypesUn{v}).(varnamesUn{v});
                                oldi=cntUn(v,1,g,s,b);
                                newi=oldi+length(d);
                                cntUn(v,1,g,s,b)=newi;
                                dataUn(v,2,g,s,b,oldi+1:newi)=d(:);
                            end
                        end                                    
                    end
                end
            end
        end
    end
end

function [dataBi,dataUn] = get_data_eff(xp,dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn)
    %Get global properties
    [~,h,grp,ss,idl,idr,r]=size(dataBi);

    %Prepare indexes for group-based or participant-based sorting. 
    i=zeros(2,ss,idl,idr);        

    for p=1:10     % participant number
        %Load participant p from disk
        pp=xp(p);
        display(['Now processing participant ' num2str(p)])
        %Iterate over within factors
        for s=1:ss  % session number
            for a=1:idl % left: difficult, easy
                for b=1:idr   % right: difficult, medium, easy
                    for c=1:3 % replication number
                        %Compute index based on i vector and actual replication
                        %For participant-based sorting, it equals to reps
                        if pp(s).bimanual{a,b,c}.ls.rho < 1.2
                            g=1;
                        else
                            g=2;
                        end
                        i(g,s,a,b)=i(g,s,a,b)+1;
                        idx=i(g,s,a,b);
                        %Bimanual trials
                        for v=1:length(varnamesBi)
                            if strcmp(vartypesBi{v},'ts')
                                if strcmp(varnamesBi{v},'Harmonicity') || strcmp(varnamesBi{v},'Circularity') || strcmp(varnamesBi{v},'IDef') || strcmp(varnamesBi{v},'f')
                                    dataBi(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ts.(['L' varnamesBi{v}]));
                                    dataBi(v,2,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ts.(['R' varnamesBi{v}]));
                                else
                                    dataBi(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ts.(varnamesBi{v}));
                                    dataBi(v,2,g,s,a,b,idx)=-nanmedian(pp(s).bimanual{a,b,c}.ts.(varnamesBi{v}));
                                end
                            elseif strcmp(vartypesBi{v},'osc')
                                dataBi(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.oscL.(varnamesBi{v}));
                                dataBi(v,2,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.oscR.(varnamesBi{v}));
                            elseif strcmp(vartypesBi{v},'vf')
                                dataBi(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.vfL.(varnamesBi{v}));
                                dataBi(v,2,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.vfR.(varnamesBi{v}));
                            else
                                dataBi(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ls.(varnamesBi{v}));
                                dataBi(v,2,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ls.(varnamesBi{v}));
                            end
                        end
                        %Unimanual Trials
                        for v=1:length(varnamesUn)
                            if b==1
                                dataUn(v,1,g,s,a,idx)=nanmedian(pp(s).uniLeft{a,c}.(vartypesUn{v}).(varnamesUn{v}));
                            end
                            if a==1
                                dataUn(v,2,g,s,b,idx)=nanmedian(pp(s).uniRight{b,c}.(vartypesUn{v}).(varnamesUn{v}));
                            end
                        end                                    
                    end
                end
            end
        end
    end
end

function [varnamesBi, vartypesBi, varnamesUn, vartypesUn] = get_variables()
    global vtypes
    varnamesBi={};
    vartypesBi={};
    varnamesUn={};
    vartypesUn={};
    for v=1:length(vtypes)
        if strcmp('ts',vtypes{v})
            vars=TimeSeriesBimanual.get_anova_variables();
            varnamesBi=[ varnamesBi, vars];
            vartypesBi=[ vartypesBi, repmat(vtypes(v),1,length(vars))];
            vars=TimeSeriesUnimanual.get_anova_variables();
            varnamesUn=[ varnamesUn, vars];
            vartypesUn=[ vartypesUn, repmat(vtypes(v),1,length(vars))];        
        elseif strcmp('osc',vtypes{v})
            vars=Oscillations.get_anova_variables();
            varnamesBi=[ varnamesBi, vars];
            varnamesUn=[ varnamesUn, vars];
            vartypesBi=[ vartypesBi, repmat(vtypes(v),1,length(vars))];
            vartypesUn=[ vartypesUn, repmat(vtypes(v),1,length(vars))];
        elseif strcmp('vf',vtypes{v})
            vars=VectorField.get_anova_variables();
            varnamesBi=[ varnamesBi, vars];
            varnamesUn=[ varnamesUn, vars];
            vartypesBi=[ vartypesBi, repmat(vtypes(v),1,length(vars))];
            vartypesUn=[ vartypesUn, repmat(vtypes(v),1,length(vars))];        
        else
            vars=LockingStrength.get_anova_variables();
            varnamesBi=[ varnamesBi, vars];
            vartypesBi=[ vartypesBi, repmat(vtypes(v),1,length(vars))];        
        end    
    end
end
