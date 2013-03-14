function xo = get_bincenters_normalized(obj)
    %Normalized version
    if length(obj.conf.binnumber) == 1
        xo = {linspace(-1.0005,1.0005,obj.conf.binnumber)'...
            linspace(-1.0005,1.0005,obj.conf.binnumber)'};
    else
        xo = {linspace(-1.0005,1.0005,obj.conf.binnumber(1))'...
            linspace(-1.0005,1.0005,obj.conf.binnumber(2))'};
    end
end %get_bincenters_normalized
