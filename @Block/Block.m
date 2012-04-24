classdef Block < handle
   properties(SetObservable = true)
      conf
   end
    properties
        data_set
    end
    properties(SetAccess = private)
        size
    end%properties
    
    methods%Constructor
        function obj = Block(blockpath,conf)
            if nargin < 1
                obj.size = size(obj.data_set);
                if length(obj.size)==2, obj.conf.unimanual=1; end
                obj.concatenate();  
            else
                if nargin < 2
                    obj.conf=Config();
                else
                    obj.conf = conf;
                end
                obj.conf.blockpath=blockpath;
                if findstr(obj.conf.blockpath,'uni')
                    obj.conf.unimanual=1;
                    if findstr(obj.conf.blockpath,'L')
                        obj.conf.hand='L';
                    else
                        obj.conf.hand='R';
                    end
                    obj.get_unimanual();
                else
                    obj.get_bimanual();            
                end               
                obj.size = size(obj.data_set);
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
        
        get_unimanual(obj)
        get_bimanual(obj)
        %B = subsref(obj,S)
        new = copy(obj)
        tr = concatenate(obj)
        update_vf(obj)
        update_ls(obj)
        update_idx(obj)
    end
end
