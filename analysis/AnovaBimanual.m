classdef AnovaBimanual < handle
   properties
        groups=[[2,3,6,8,9];[1,4,5,7,10]];
        promediate=1
        %Factors
        grLevels   % 0=coupled; 1=uncopled
        ssLevels   % 1, 4, 7
        ppLevels   % 1,2,3,4,5,6,7,8,9,10
        rhLevels   % 1=2.6, 2=4.5, 3=5.4
        lhLevels   % 1=2.6; 2=5.4
        
        %anovan arguments
        data
        factors = {'grp' 'pp' 'S' 'IDR' 'IDL'}
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
    function obj=AnovaBimanual()
        %pass
    end
    
    function add_participant(obj,pp,varType,v)
        p=str2num(pp.conf.name(end-2:end));
        [g,~]= find(obj.groups==p);
        for s=[1,4,7]
            ds=pp.sessions(s).bimanual.data_set;
            for r=1:3
                for l=[1,2]
                    for rep=1:3
                        if strcmp(varType,'oscL')
                            data=ds{l,r,rep}.oscL.(v)(:);
                        elseif strcmp(varType,'oscR')
                            data=ds{l,r,rep}.oscR.(v)(:);
                        elseif strcmp(varType,'ls')
                            data=ds{l,r,rep}.ls.(v)(:);
                        elseif strcmp(varType,'vfL')
                            data=ds{l,r,rep}.vfL.(v)(:);
                        elseif strcmp(varType,'vfR')
                            data=ds{l,r,rep}.vfR.(v)(:);
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
    
    function finalize_data(obj)
        %Prepare arguments for anovan
        obj.vargroups= {obj.grLevels obj.ppLevels obj.ssLevels obj.rhLevels obj.lhLevels};
        obj.random = [2];
        obj.nested = [0 0 0 0 0 ; 1 0 0 0 0 ; 1 1 0 0 0 ; 1 1 1 0 0 ; 1 1 1 1 0 ];
        
        %Compute anova stats
        %[obj.pvals,obj.tbl,obj.stats] = ...
        %anovan(obj.data, obj.vargroups, 'model',2, 'random',obj.random,'nested',obj.nested,'varnames',obj.varnames);                          
    end
    
    function new = copy(obj,save_path)
        filename=joinpath(save_path,strcat('temp',random_string(5)));
        save(filename, 'obj');
        Foo = load(filename);
        new = Foo.obj;
        delete(strcat(filename,'.mat'));
    end
    
    function promediate_Anova2(AV)
        AV.promediate=1;
        grL=AV.grLevels(:);
        ssL=AV.ssLevels(:);   % 1, 4, 7
        ppL=AV.ppLevels(:);   % 1,2,3,4,5,6,7,8,9,10
        rhL=AV.rhLevels(:);   % 1=2.6, 2=4.5, 3=5.4
        lhL=AV.lhLevels(:);   % 1=2.6; 2=5.4
        data=AV.data(:);
        AV.grLevels=[];
        AV.ssLevels=[];
        AV.ppLevels=[];
        AV.rhLevels=[];
        AV.lhLevels=[];
        AV.data=[];
        for g=[1,2]
            for p=AV.groups(g,:)
                for s=[1,4,7]
                    for r=1:3
                        for l=[1,2]
                            idx=(grL==g & ssL==s & ppL==p & rhL==r & lhL==l);
                            AV.data=[AV.data;mean(data(idx))];
                            AV.grLevels=[AV.grLevels;g];
                            AV.ppLevels=[AV.ppLevels;p];  
                            AV.ssLevels=[AV.ssLevels;s];   
                            AV.rhLevels=[AV.rhLevels;r];        
                            AV.lhLevels=[AV.lhLevels;l];
                        end
                    end
                end
            end
        end
    end
    end %methods
end
