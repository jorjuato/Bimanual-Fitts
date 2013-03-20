function [f1mat,f2mat]=posthoc2(vname,data,vnames,factors)
    %That's an easy one. It runs holm test after preparing data for the
    %analysys. After that, it returns crosslevel pairwise comparisons
    if nargin<4, error('need bimanual data, all bimanual variable names and factors/variable names to study');end    
    if strcmp('all',factors), factors={'grp','ss','idl','idr'};  end
    
    data = rearrange_var_data(vname,data,vnames,factors);

    [phgrps, phgrplabels]=get_posthoc_groups(data,factors);
    
    Holmmat=holm2(phgrps,0,0.5,2,phgrplabels);

    [f1mat,f2mat]=get_pairwise_comparisons(Holmmat+Holmmat',data,factors);
    
end



            