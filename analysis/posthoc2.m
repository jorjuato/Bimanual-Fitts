function [f1mat,f2mat]=posthoc2(vname,data,vnames,factors)
    if nargin<4, error('need bimanual data, all bimanual variable names and factors/variable names to study');end    
    if strcmp('all',factors), factors={'grp','ss','idl','idr'};  end
    
    data = rearrange_var_data(vname,data,vnames,factors);

    [newdata, grplabels]=get_posthoc_groups(data,factors);
    
    outmat=holm2(newdata,0,0.5,2,grplabels);

    [f1mat,f2mat]=showholmbyfactor(outmat+outmat',data,factors);
    
end



            