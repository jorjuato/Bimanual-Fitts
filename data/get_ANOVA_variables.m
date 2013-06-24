function obj = get_ANOVA_variables()
    global vtypes
    obj=struct();
    obj.vnamesB={};
    obj.vtypesB={};
    obj.vnamesU={};
    obj.vtypesU={};
    for v=1:length(vtypes)
        if strcmp('osc',vtypes{v})
            vars=Oscillations.get_anova_variables();
            obj.vnamesB=[ obj.vnamesB, vars];
            obj.vnamesU=[ obj.vnamesU, vars];
            obj.vtypesB=[ obj.vtypesB, repmat(vtypes(v),1,length(vars))];
            obj.vtypesU=[ obj.vtypesU, repmat(vtypes(v),1,length(vars))];
        elseif strcmp('vf',vtypes{v})
            vars=VectorField.get_anova_variables();
            obj.vnamesB=[ obj.vnamesB, vars];
            obj.vnamesU=[ obj.vnamesU, vars];
            obj.vtypesB=[ obj.vtypesB, repmat(vtypes(v),1,length(vars))];
            obj.vtypesU=[ obj.vtypesU, repmat(vtypes(v),1,length(vars))];        
        else
            vars=LockingStrength.get_anova_variables();
            obj.vnamesB=[ obj.vnamesB, vars];
            obj.vtypesB=[ obj.vtypesB, repmat(vtypes(v),1,length(vars))];        
        end    
    end
end
