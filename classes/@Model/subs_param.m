function subs_param(mdl,pname,value)
    if iscell(pname)
        newpar=cell2mat(mdl.params);
        mask=logical(zeros(size(newpar)));         %#ok<LOGL>
        for p=1:length(pname)
            mask = mask | strcmp(pname{p},mdl.parnames);
        end
        newpar(mask)=value;
        mdl.params=num2cell(newpar); 
    else
        cmp=strcmp(pname,mdl.parnames);
        if any(cmp)
            mdl.params{cmp}=value;
        end
    end
end