classdef Trial < handle
    properties(SetAccess = private)
        ts
        vf
        vfL
        vfR
        osc
        oscL
        oscR
        ls
        info
        concatenated=0
    end % properties

    methods
        
        [fcns, names, xlabels, ylabels] = get_plots(obj)
        
        plot(obj,graphPath,rootname,ext)
        
        new=copy(obj)
        
        concatenate(obj,obj2)
        
        set_concatenated(obj)
        
        %%%%%%%%%%%%%
        % Constructor
        %%%%%%%%%%%%%
        function obj = Trial(data,name)
            if nargin<2, return; end
                
            %Call apropiate get_results function, output stored in DS.name
            if findstr(name,'uni')
                if findstr(name,'L')
                    hand='L';
                else
                    hand='R';
                end
                obj.info = obj.get_trial_info_uni(data);
                obj.ts   = TimeSeriesUnimanual(data,obj.info,hand);
                obj.osc  = Oscillations(obj.ts,'');
                obj.vf   = VectorField(obj,'');
            else
                obj.info = obj.get_trial_info_bi(data);
                obj.ts   = TimeSeriesBimanual(data,obj.info);
                obj.oscL = Oscillations(obj.ts,'L');
                obj.oscR = Oscillations(obj.ts,'R');
                obj.ls   = LockingStrength(obj.ts);
                obj.vfL  = VectorField(obj,'L');
                obj.vfR  = VectorField(obj,'R');                
            end
        end
    end
    

    methods(Static=true, Access=private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Prototypes of static methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        info = get_trial_info_bi(data)
        info = get_trial_info_uni(data)
        
    end % methods
end% classdef
