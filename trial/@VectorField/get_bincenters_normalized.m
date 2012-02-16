function xo = get_bincenters_normalized(obj)
    %Normalized version
    if length(obj.binnumber) == 1
        xo = {linspace(-1,1,obj.binnumber)'...
            linspace(-1,1,obj.binnumber)'};
    else
        xo = {linspace(-1,1,obj.binnumber(1))'...
            linspace(-1,1,obj.binnumber(2))'};
    end
end %get_bincenters_normalized