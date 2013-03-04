classdef Data_Series
    properties
        names
        colors
        xlabels
        ylabels
    end
    
    methods%Constructor
        function ds = Data_Series(names,colors,xlabels,ylabels)
            ds.names=names;
            ds.colors=colors;
            ds.xlabels=xlabels;
            ds.ylabels=ylabels;
        end        
    end
end