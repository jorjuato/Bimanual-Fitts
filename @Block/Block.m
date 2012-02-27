classdef Block < handle
   properties(SetObservable = true)
      conf
   end
    properties
        data_set
    end
    properties(SetAccess = private)
        size
        %path
        %unimanual=0
    end%properties
    
    methods%Constructor
        function obj = Block(blockpath,conf)
            if nargin == 0
                obj.size = size(obj.data_set);
                if length(obj.size)==2, obj.unimanual=1; end
                obj.concatenate();  
            else
                if findstr(blockpath,'uni')
                    conf.unimanual=1;
                end
                conf.blockpath=blockpath;
                obj.conf = conf;
                obj.get_dataset();
                obj.size = size(obj.data_set);
                if length(obj.size)==2, obj.conf.unimanual=1; end
                obj.concatenate();
            end
            confListener = addlistener(obj,'conf','PostSet',@(src,evnt)update_conf(obj,src,evnt));
        end
    end
    
    methods%Prototypes
        plot(obj)
        plot_va(obj)
        plot_vf(obj)
        plot_lockingStrength(obj)
        plot_oscillations(obj)
        plot_timeSeries(obj)
        
        get_dataset(obj)
        %B = subsref(obj,S)
        new = copy(obj)
        tr = concatenate(obj)
        update_vf(obj);
    end
end
