classdef AnovaUnimanual < handle
   properties
        groups=[[2,3,6,8,9];[1,4,5,7,10]];
        promediate=0
        %Factors
        grLevels   % 0=coupled; 1=uncopled
        ssLevels   % 1, 4, 7
        ppLevels   % 1,2,3,4,5,6,7,8,9,10
        idLevels   % 1=2.6, 2=4.5, 3=5.4
        
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
    function obj=AnovaUnimanual()
        %pass
    end
    
    function add_participant(obj,pp,varType,v)
        p=str2num(pp.conf.name(end-2:end));
        [g,~]= find(obj.groups==p);
        if strcmp(varType(end),'L')
            id=[1,2];
        else
            id=1:3;
        end
        for s=[1,4,7]
            for i=id
                for rep=1:3
                    if strfind(varType,'osc')
                        data=pp.sessions(s).bimanual.data_set{l,r,rep}.osc.(v)(:);
                    elseif strfind(varType,'vf')
                        data=pp.sessions(s).bimanual.data_set{l,r,rep}.vfL.(v)(:);
                    else
                        display('Something is going wrong!!')
                        return
                    end
                
                    if obj.promediate==1
                        obj.data=[obj.data;mean(data)];
                        obj.grLevels=[obj.grLevels;g];
                        obj.ppLevels=[obj.ppLevels;p];  
                        obj.ssLevels=[obj.ssLevels;s];   
                        obj.idLevels=[obj.idLevels;i];                                      
                    else
                        n=length(data);
                        obj.data=[obj.data;data];
                        obj.grLevels=[obj.grLevels;repmat([g],n,1)];
                        obj.ppLevels=[obj.ppLevels;repmat([p],n,1)];  
                        obj.ssLevels=[obj.ssLevels;repmat([s],n,1)];   
                        obj.idLevels=[obj.idLevels;repmat([i],i,1)];        

                    end
                end
                end
            end
        end
    end
    
    function finalize_data(obj)
        %Prepare arguments for anovan
        obj.varnames = {'grp' 'pp' 'S' 'ID'};
        obj.vargroups= {obj.grLevels obj.ppLevels obj.ssLevels obj.idLevels };
        obj.random = [2];
        obj.nested = [0 0 0 0 ; 1 0 0 0 ; 1 1 0 0 ; 1 1 1 0 ];
        
        %Compute anova stats
        %[obj.pvals,obj.tbl,obj.stats] = ...
        %anovan(obj.data, obj.vargroups, 'model',2, 'random',obj.random,'nested',obj.nested,'varnames',obj.varnames);                          
    end
    
    end %methods
end
