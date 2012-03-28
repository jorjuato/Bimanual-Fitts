classdef Anova < handle
   properties
        groups=[[2,3,6,8,9],[1,4,5,7,10]];
        %Factors
        grLevels   % 0=coupled; 1=uncopled
        ssLevels   % 1, 4, 7
        ppLevels   % 1,2,3,4,5,6,7,8,9,10
        rhLevels   % 1=2.6, 2=4.5, 3=5.4
        lhLevels   % 1=2.6; 2=5.4
        hdLevels   % 1=Left; 2=Right
        
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
        if strcmp(varType,'osc')
            for g=[1,2]
                for p=obj.groups(g)
                    for s=[1,4,7]
                        for r=1:3
                            for l=[1,2]                            
                                for h=[1,2]
                                    if h==1
                                        data=exp.participants(p).sessions(s).bimanual.data_set{l,r,end}.oscL.(v)(:);
                                    else
                                        data=exp.participants(p).sessions(s).bimanual.data_set{l,r,end}.oscR.(v)(:);
                                    end
                                    n=length(data);
                                    obj.data=[obj.data;data];
                                    obj.grLevels=[obj.grLevels;repmat([g],n,1)];
                                    obj.ppLevels=[obj.ppLevels;repmat([p],n,1)];  
                                    obj.ssLevels=[obj.ssLevels;repmat([s],n,1)];   
                                    obj.rhLevels=[obj.rhLevels;repmat([r],n,1)];        
                                    obj.lhLevels=[obj.lhLevels;repmat([l],n,1)];
                                    obj.hdLevels=[obj.hdLevels;repmat([h],n,1)];
                                end
                            end
                        end
                    end
                end
            end
            %Prepare arguments for anovan
            obj.varnames = {'group' 'participant' 'session' 'IDRight' 'IDLeft' 'hand'};
            obj.vargroups= {obj.grLevels obj.ppLevels obj.ssLevels obj.rhLevels obj.lhLevels obj.hdLevels};
            obj.random = [3,4,5,6];
            obj.nested = [0 0 0 0 0 0; 0 0 0 0 0 0; 1 1 0 0 0 0; 1 1 1 0 0 0; 1 1 1 1 0 0; 1 1 1 1 1 0];
            
            %Compute anova stats
            [obj.pvals,obj.tbl,obj.stats] = ...
            anovan(obj.data, obj.vargroups, 'model',2, 'random',obj.random,'nested',obj.nested,'varnames',obj.varnames);
                          
        elseif strcmp(varType,'ls')
            for g=[1,2]     
                for p=obj.groups(g)
                    for s=[1,4,7]
                        for r=1:3
                            for l=[1,2]                            
                                data=exp.participants(p).sessions(s).bimanual.data_set{l,r,end}.ls.(v)(:);
                                n=length(data);
                                obj.data=[obj.data;data];
                                obj.grLevels=[obj.grLevels;repmat([g],n,1)];    
                                obj.ssLevels=[obj.ssLevels;repmat([s],n,1)];   
                                obj.ppLevels=[obj.ppLevels;repmat([p],n,1)];      
                                obj.rhLevels=[obj.rhLevels;repmat([r],n,1)];        
                                obj.lhLevels=[obj.lhLevels;repmat([l],n,1)];
                            end
                        end
                    end
                end
            end
            %Prepare arguments for anovan
            obj.varnames = {'group' 'participant' 'session' 'IDRight' 'IDLeft'};
            obj.vargroups= {obj.grLevels obj.ppLevels obj.ssLevels obj.rhLevels obj.lhLevels};
            obj.random = [3,4,5];
            obj.nested = [0 0 0 0 0; 0 0 0 0 0; 1 1 0 0 0; 1 1 1 0 0; 1 1 1 1 0];
            
            %Compute anova stats
            [obj.pvals,obj.tbl,obj.stats] = ...
            anovan(obj.data, obj.vargroups, 'model',2, 'random',obj.random,'nested',obj.nested,'varnames',obj.varnames);      
            
        end
    end
    end %methods
end
