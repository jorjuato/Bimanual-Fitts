classdef Trial < handle
   properties(SetObservable = true)
      conf
   end
    properties(SetAccess = private)
        ts
        osc
        oscL
        oscR
        info
        concatenated=0
    end 
    
    properties
        ls
        vf
        vfL
        vfR
    end

    methods        
        %%%%%%%%%%%%%
        % Constructor
        %%%%%%%%%%%%%
        function obj = Trial(data,conf)
            if nargin<2, conf=Config(); end
                
            %Call apropiate get_results function, output stored in DS.name
            obj.conf=conf;
            if isa(data,'TimeSeriesBimanual')
                obj.info=data.info;
                obj.ts=data;
                obj.oscL = Oscillations(obj.ts,'L',copy(conf));
                obj.oscR = Oscillations(obj.ts,'R',copy(conf));
                obj.ls   = LockingStrength(obj.ts,copy(conf));
                obj.vfL  = []; %Fill vf object from Block concatenation
                obj.vfR  = []; %To avoid recomputation of VF                 
            elseif isa(data,'TimeSeriesUnimanual')
                obj.info=data.info;
                obj.ts=data;
                obj.osc  = Oscillations(obj.ts,'',copy(conf));
                obj.vf   = [];                
            elseif  obj.conf.unimanual==1
                obj.info = obj.get_trial_info_uni(data);
                obj.ts   = TimeSeriesUnimanual(data,obj.info,copy(conf));
                obj.osc  = Oscillations(obj.ts,'',copy(conf));
                obj.vf   = VectorField(obj.ts,'',copy(conf));
            else
                obj.info = obj.get_trial_info_bi(data);
                obj.ts   = TimeSeriesBimanual(data,obj.info,copy(conf));
                obj.oscL = Oscillations(obj.ts,'L',copy(conf));
                obj.oscR = Oscillations(obj.ts,'R',copy(conf));
                obj.ls   = LockingStrength(obj.ts,copy(conf));
                obj.vfL  = VectorField(obj.ts,'L',copy(conf));
                obj.vfR  = VectorField(obj.ts,'R',copy(conf));                
            end
            addlistener(obj,'conf','PostSet',@(src,evnt)update_conf(obj,src,evnt));
        end

        [fcns, names, xlabels, ylabels] = get_plots(obj)
        
        plot(obj,graphPath,rootname,ext)
        
        plot_va(obj,graphPath,rootname,ext)
        
        plot_vf(obj,graphPath,rootname,ext)
        
        plot_angvar(tr,graphPath,vname,rootname,ext)
        
        plot_hists(tr)
        
        new=copy(obj)
        
        set_concatenated(obj)
        
        update_conf(obj,src,event)
        
        update_idx(obj)
        
    end
    

    methods(Static=true, Access=private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Prototypes of static methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        info = get_trial_info_bi(data)
        info = get_trial_info_uni(data)
        
    end % methods
end% classdef
