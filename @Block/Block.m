classdef Block < handle
    properties(SetAccess = private)
        size
        data_set
        path
        unimanual=0
    end%properties
    
    methods%Constructor
        function obj = Block(blockpath)
            if nargin == 0
                obj.size = size(obj.data_set);
                if length(obj.size)==2, obj.unimanual=1; end
            else
                obj.path=blockpath;
                obj.get_dataset();
                obj.concatenate();
                obj.size = size(obj.data_set);
                if length(obj.size)==2, obj.unimanual=1; end
            end
        end
    end
    
    methods%Prototypes
        plot(obj,figname)
        plot_lockingStrength(obj,graphPath,rootname,ext)
        plot_oscillations(obj,graphPath,rootname,ext)
        plot_timeSeries(obj,rep,graphPath,rootname,ext)
        plot_vectorFields(obj,mode,graphPath,rootname,ext)
        
        get_dataset(obj)
        B = subsref(obj,S)
        new = copy(obj)
        concatenate(obj)
    end
end
