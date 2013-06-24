function xo = get_bincenters(obj,DS,dim)
    %Non normalized version
    rep=size(DS,length(dim)+1)-1;
    xmin=0; xmax=0;vmin=0;vmax=0;
    
    for r=1:rep
        if length(dim)==1 && ~isempty(DS{dim,r})
            xmin = min([min(DS{dim,r}.x),xmin]);
            xmax = max([max(DS{dim,r}.x),xmax]);
            vmin = min([min(DS{dim,r}.v),vmin]);
            vmax = max([max(DS{dim,r}.v),vmax]);
        elseif strcmp(obj.hand,'L') && ~isempty(DS{dim(1),dim(2),r})
            xmin = min([min(DS{dim(1),dim(2),r}.Lx),xmin]);
            xmax = max([max(DS{dim(1),dim(2),r}.Lx),xmax]);
            vmin = min([min(DS{dim(1),dim(2),r}.Lv),vmin]);
            vmax = max([max(DS{dim(1),dim(2),r}.Lv),vmax]);
        elseif strcmp(obj.hand,'R') && ~isempty(DS{dim(1),dim(2),r})
            xmin = min([min(DS{dim(1),dim(2),r}.Rx),xmin]);
            xmax = max([max(DS{dim(1),dim(2),r}.Rx),xmax]);
            vmin = min([min(DS{dim(1),dim(2),r}.Rv),vmin]);
            vmax = max([max(DS{dim(1),dim(2),r}.Rv),vmax]);
        end
    end
    
    if length(obj.conf.binnumber) == 1
        xo = {linspace(xmin,xmax,obj.conf.binnumber)'...
            linspace(vmin,vmax,obj.conf.binnumber)'};
    else
        xo = {linspace(xmin,xmax,obj.conf.binnumber(1))'...
            linspace(vmin,vmax,obj.conf.binnumber(2))'};
    end
end %get_bincenters
