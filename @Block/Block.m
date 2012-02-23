classdef Block < handle
    properties
        data_set
    end
    properties(SetAccess = private)
        size
        path
        unimanual=0
    end%properties
    
    methods%Constructor
        function obj = Block(blockpath)
            if nargin == 0
                obj.size = size(obj.data_set);
                if length(obj.size)==2, obj.unimanual=1; end
                obj.concatenate();  
            else
                obj.path=blockpath;
                obj.get_dataset();
                obj.size = size(obj.data_set);
                if length(obj.size)==2, obj.unimanual=1; end
                obj.concatenate();
            end
        end
    end
    
    methods%Prototypes
        plot(obj,graphPath,rootname,ext)
        plot_va(obj,graphPath,rootname,ext)
        plot_vf(obj,graphPath,rootname,ext)
        plot_lockingStrength(obj,graphPath,rootname,ext)
        plot_oscillations(obj,graphPath,rootname,ext)
        plot_timeSeries(obj,rep,graphPath,rootname,ext)
        
        get_dataset(obj)
        %B = subsref(obj,S)
        new = copy(obj)
        tr = concatenate(obj)
        update_vf(obj);
    end
end
