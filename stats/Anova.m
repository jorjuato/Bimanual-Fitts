classdef Anova < handle
   properties
        groups=[[2,3,6,8,9];[1,4,5,7,10]];
        promediate=0
        %Factors
        grLevels   % 0=coupled; 1=uncopled
        ssLevels   % 1, 4, 7
        ppLevels   % 1,2,3,4,5,6,7,8,9,10
        rhLevels   % 1=2.6, 2=4.5, 3=5.4
        lhLevels   % 1=2.6; 2=5.4
        
        %anovan arguments
        data
        varnames
        vargroups
        random
        nested
        
        %anovan output
        pvals
        tbl
        stats
   end

    methods
    function obj=Anova(exp,varType,v)
        
        for g=[1,2]
            for p=obj.groups(g,:)
                if isa(exp,'Experiment')
                    pp=exp.participants(p);
                else
                    disp('Loading participant before analysis')
                    pp=Participant.load(p,exp);
                end
                for s=[1,4,7]
                    for r=1:3
                        %Unimanual data should only be added once per hand
                        if strfind(varType,'U') & strfind(varType,'L') & r>1
                            continue
                        end
                        for l=[1,2]
                            %Unimanual data should only be added once
                            if strfind(varType,'U') & strfind(varType,'R') & l>1
                                continue
                            end
                            for h=[1,2]
                                for rep=1:3
                                    if strcmp(varType,'oscL')
                                        data=pp.sessions(s).bimanual.data_set{l,r,rep}.oscL.(v)(:);
                                    elseif strcmp(varType,'oscR')
                                        data=pp.sessions(s).bimanual.data_set{l,r,rep}.oscR.(v)(:);
                                    elseif strcmp(varType,'UoscR')
                                        data=pp.sessions(s).uniRight.data_set{r,rep}.osc.(v)(:);
                                    elseif strcmp(varType,'UoscL')
                                        data=pp.sessions(s).uniLeft.data_set{l,rep}.osc.(v)(:);
                                    elseif strcmp(varType,'reloscL')
                                        dataBi=pp.sessions(s).bimanual.data_set{l,r,rep}.oscL.(v)(:);
                                        dataUni=pp.sessions(s).uniLeft.data_set{l,rep}.osc.(v)(:);
                                        data=mean(dataBi)/mean(dataUni);
                                    elseif strcmp(varType,'reloscR')
                                        dataBi=pp.sessions(s).bimanual.data_set{l,r,rep}.oscR.(v)(:);
                                        dataUni=pp.sessions(s).uniRight.data_set{r,rep}.osc.(v)(:);
                                        data=mean(dataBi)/mean(dataUni);
                                    elseif strcmp(varType,'ls')
                                        data=pp.sessions(s).bimanual.data_set{l,r,rep}.ls.(v)(:);
                                    elseif strcmp(varType,'vfL')
                                        data=pp.sessions(s).bimanual.data_set{l,r,rep}.vfL.(v)(:);
                                    elseif strcmp(varType,'vfR')
                                        data=pp.sessions(s).bimanual.data_set{l,r,rep}.vfR.(v)(:);
                                    elseif strcmp(varType,'UvfL')
                                        data=pp.sessions(s).uniLeft.data_set{l,rep}.vf.(v)(:);
                                    elseif strcmp(varType,'UvfR')
                                        data=pp.sessions(s).uniRight.data_set{r,rep}.vf.(v)(:);
                                    elseif strcmp(varType,'relvfL')
                                        dataBi=pp.sessions(s).bimanual.data_set{l,r,rep}.vfL.(v)(:);
                                        dataUni=pp.sessions(s).uniLeft.data_set{l,rep}.vf.(v)(:);
                                        data=mean(dataBi)/mean(dataUni);
                                    elseif strcmp(varType,'relvfR')
                                        dataBi=pp.sessions(s).bimanual.data_set{l,r,rep}.vfR.(v)(:);
                                        dataUni=pp.sessions(s).uniRight.data_set{r,rep}.vf.(v)(:);
                                        data=mean(dataBi)/mean(dataUni);
                                    else
                                        display('Something is going wrong!!')
                                        return
                                    end
                                
                                    if obj.promediate==1
                                        obj.data=[obj.data;mean(data)];
                                        obj.grLevels=[obj.grLevels;g];
                                        obj.ppLevels=[obj.ppLevels;p];  
                                        obj.ssLevels=[obj.ssLevels;s];   
                                        obj.rhLevels=[obj.rhLevels;r];        
                                        obj.lhLevels=[obj.lhLevels;l];                                 
                                    else
                                        n=length(data);
                                        obj.data=[obj.data;data];
                                        obj.grLevels=[obj.grLevels;repmat([g],n,1)];
                                        obj.ppLevels=[obj.ppLevels;repmat([p],n,1)];  
                                        obj.ssLevels=[obj.ssLevels;repmat([s],n,1)];   
                                        obj.rhLevels=[obj.rhLevels;repmat([r],n,1)];        
                                        obj.lhLevels=[obj.lhLevels;repmat([l],n,1)];
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        %Prepare arguments for anovan
        obj.varnames = {'grp' 'pp' 'S' 'IDR' 'IDL'};
        obj.vargroups= {obj.grLevels obj.ppLevels obj.ssLevels obj.rhLevels obj.lhLevels};
        obj.random = [2];
        obj.nested = [0 0 0 0 0 ; 1 0 0 0 0 ; 1 1 0 0 0 ; 1 1 1 0 0 ; 1 1 1 1 0 ];
        
        %Compute anova stats
        [obj.pvals,obj.tbl,obj.stats] = ...
        anovan(obj.data, obj.vargroups, 'model',2, 'random',obj.random,'nested',obj.nested,'varnames',obj.varnames);                          
    end
    end %methods
end