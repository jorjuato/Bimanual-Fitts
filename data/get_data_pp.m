function [dataBi,dataUn,varnamesBi,varnamesUn,vartypesBi, vartypesUn] = get_data_pp(pno,avg,rel)
    if nargin<2,avg=1;end
    if nargin<3,rel=0;end

    %Set some globals for data fetching
    if isa(pno,'Participant')
        pp=pno;
    else
        pp=Participant(pno);
    end
    
    global vtypes
    vtypes={'ts','osc','vf','ls'};
    max_raw_data=1000;

    %Define arrays
    [varnamesBi, vartypesBi, varnamesUn, vartypesUn] = get_variables();
    if avg==1, r=0; else r=3; end
    hands=2; idl=2; idr=3; ss=3; 
    
    %Do the real thing!
    tic
    if rel==1 
        % always average data for relative measures
        dataUn=zeros(length(varnamesBi),hands,ss,idr,r)*NaN;
        dataBi=zeros(length(varnamesUn),hands,ss,idl,idr,r)*NaN;
        dataBi=get_data_rel(pp,dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn);
    elseif avg==1
        dataUn=zeros(length(varnamesBi),hands,ss,idr,r);
        dataBi=zeros(length(varnamesUn),hands,ss,idl,idr,r);
        [dataBi,dataUn] = get_data_averaged(pp,dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn);
    elseif avg==0 
        dataUn=zeros(length(varnamesBi),hands,ss,idr,max_raw_data);
        dataBi=zeros(length(varnamesUn),hands,ss,idl,idr,max_raw_data);
        [dataBi,dataUn] = get_data_raw(pp,dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn);
    else
        error('There is something wrong with your options!')
    end
    toc
end

function [dataBi,dataUn] = get_data_averaged(pp,dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn)
[~,h,ss,idl,idr,r]=size(dataBi);
idx=0;
%Iterate over within factors
for s=1:ss  % session number
    for a=1:idl % left: difficult, easy
        for b=1:idr   % right: difficult, medium, easy
            for c=1:3 % replication number
                %Bimanual trials
                for v=1:length(varnamesBi)
                    if strcmp(vartypesBi{v},'ts')
                        dataBi(v,1,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.ts.(['L' varnamesBi{v}]));
                        dataBi(v,2,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.ts.(['R' varnamesBi{v}]));
                    elseif strcmp(vartypesBi{v},'osc')
                        dataBi(v,1,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.oscL.(varnamesBi{v}));
                        dataBi(v,2,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.oscR.(varnamesBi{v}));
                    elseif strcmp(vartypesBi{v},'vf')
                        dataBi(v,1,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.vfL.(varnamesBi{v}));
                        dataBi(v,2,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.vfR.(varnamesBi{v}));
                    else % vartype=ls
                        dataBi(v,1,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.ls.(varnamesBi{v}));
                        dataBi(v,2,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.ls.(varnamesBi{v}));
                    end
                end
                %Unimanual Trials
                for v=1:length(varnamesUn)
                    if b==1
                        dataUn(v,1,s,a,c)=nanmedian(pp(s).uniLeft{a,c}.(vartypesUn{v}).(varnamesUn{v}));
                    end
                    if a==1
                        dataUn(v,2,s,b,c)=nanmedian(pp(s).uniRight{b,c}.(vartypesUn{v}).(varnamesUn{v}));
                    end
                end
            end
        end
    end
end
end


function [dataBi,dataUn] = get_data_raw(pp,dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn)
%Get global properties
[vno,h,ss,idl,idr,r]=size(dataBi);
cntBi=zeros(vno,h,ss,idl,idr);
cntUn=zeros(length(varnamesUn),h,ss,idr);
%Iterate over within factors
for s=1:ss  % session number
    for a=1:idl % left: difficult, easy
        for b=1:idr   % right: difficult, medium, easy
            for c=1:3 % replication number
                %Bimanual trials
                for v=1:vno
                    if strcmp(vartypesBi{v},'ts')
                        %Left hand variables
                        d=pp(s).bimanual{a,b,c}.ts.(['L' varnamesBi{v}]);
                        oldi=cntBi(v,1,s,a,b);
                        newi=oldi+length(d);
                        cntBi(v,1,s,a,b)=newi;
                        dataBi(v,1,s,a,b,oldi+1:newi)=d(:);
                        %Right hand variables
                        d=pp(s).bimanual{a,b,c}.ts.(['R' varnamesBi{v}]);
                        oldi=cntBi(v,2,s,a,b);
                        newi=oldi+length(d);
                        cntBi(v,2,s,a,b)=newi;
                        dataBi(v,2,s,a,b,oldi+1:newi)=d(:);
                    elseif strcmp(vartypesBi{v},'osc')
                        %Avoid single valued functions in non-averaged data
                        if strcmp(varnamesBi{v},'IDOwn')   || strcmp(varnamesBi{v},'IDOther') || ...
                           strcmp(varnamesBi{v},'IDOwnEf') || strcmp(varnamesBi{v},'IDOtherEf')
                            continue
                        end
                        %Left hand variables
                        d=pp(s).bimanual{a,b,c}.oscL.(varnamesBi{v});
                        oldi=cntBi(v,1,s,a,b);
                        newi=oldi+length(d);
                        cntBi(v,1,s,a,b)=newi;
                        dataBi(v,1,s,a,b,oldi+1:newi)=d(:);
                        %Right hand variables
                        d=pp(s).bimanual{a,b,c}.oscR.(varnamesBi{v});
                        oldi=cntBi(v,2,s,a,b);
                        newi=oldi+length(d);
                        cntBi(v,2,s,a,b)=newi;
                        dataBi(v,2,s,a,b,oldi+1:newi)=d(:);
                    elseif strcmp(vartypesBi{v},'vf')
                        %Left hand variables
                        d=pp(s).bimanual{a,b,c}.vfL.(varnamesBi{v});
                        oldi=cntBi(v,1,s,a,b);
                        newi=oldi+length(d);
                        cntBi(v,1,s,a,b)=newi;
                        dataBi(v,1,s,a,b,oldi+1:newi)=d(:);
                        %Right hand variables
                        d=pp(s).bimanual{a,b,c}.vfR.(varnamesBi{v});
                        oldi=cntBi(v,2,s,a,b);
                        newi=oldi+length(d);
                        cntBi(v,2,s,a,b)=newi;
                        dataBi(v,2,s,a,b,oldi+1:newi)=d(:);
                    else
                        %Locking strength variables
                        d=pp(s).bimanual{a,b,c}.ls.(varnamesBi{v});
                        oldi=cntBi(v,1,s,a,b);
                        newi=oldi+length(d);
                        cntBi(v,1,s,a,b)=newi;
                        cntBi(v,2,s,a,b)=newi;
                        dataBi(v,1,s,a,b,oldi+1:newi)=d(:);
                        dataBi(v,2,s,a,b,oldi+1:newi)=d(:);
                    end
                end
                %Unimanual Trials
                for v=1:length(varnamesUn)
                    %Avoid single valued functions in non-averaged data
                    if strcmp(varnamesUn{v},'IDOwn')   || strcmp(varnamesUn{v},'IDOther') || ...
                            strcmp(varnamesUn{v},'IDOwnEf') || strcmp(varnamesUn{v},'IDOtherEf')
                        continue
                    end
                    if b==1
                        d=pp(s).uniLeft{a,c}.(vartypesUn{v}).(varnamesUn{v});
                        oldi=cntUn(v,1,s,a);
                        newi=oldi+length(d);
                        cntUn(v,1,s,a)=newi;
                        dataUn(v,1,s,a,oldi+1:newi)=d(:);
                    end
                    if a==1
                        d=pp(s).uniRight{b,c}.(vartypesUn{v}).(varnamesUn{v});
                        oldi=cntUn(v,2,s,b);
                        newi=oldi+length(d);
                        cntUn(v,2,s,b)=newi;
                        dataUn(v,2,s,b,oldi+1:newi)=d(:);
                    end
                end
            end
        end
    end
end
end

function [dataBi,dataUn] = get_data_rel(pp,dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn)
%Get global properties
[~,h,ss,idl,idr,r]=size(dataBi);
%Iterate over within factors
for s=1:ss  % session number
    for a=1:idl % left: difficult, easy
        for b=1:idr   % right: difficult, medium, easy
            for c=1:3 % replication number
                %Bimanual trials
                for v=1:length(varnamesBi)
                    if strcmp(vartypesBi{v},'ts')
                        dataBi(v,1,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.ts.(['L' varnamesBi{v}]));
                        dataBi(v,2,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.ts.(['R' varnamesBi{v}]));
                    elseif strcmp(vartypesBi{v},'osc')
                        dataBi(v,1,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.oscL.(varnamesBi{v}));
                        dataBi(v,2,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.oscR.(varnamesBi{v}));
                    elseif strcmp(vartypesBi{v},'vf')
                        dataBi(v,1,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.vfL.(varnamesBi{v}));
                        dataBi(v,2,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.vfR.(varnamesBi{v}));
                    else
                        dataBi(v,1,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.ls.(varnamesBi{v}));
                        dataBi(v,2,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.ls.(varnamesBi{v}));
                    end
                end
                %Unimanual Trials
                for v=1:length(varnamesUn)
                    if b==1
                        dataUn(v,1,s,a,c)=nanmedian(pp(s).uniLeft{a,c}.(vartypesUn{v}).(varnamesUn{v}));
                    end
                    if a==1
                        dataUn(v,2,s,b,c)=nanmedian(pp(s).uniRight{b,c}.(vartypesUn{v}).(varnamesUn{v}));
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
