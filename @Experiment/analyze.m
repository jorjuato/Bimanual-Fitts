function analyze(obj)
    vars=Oscillations.get_anova_variables();
    for v=1:length(vars)
        vname=strcat('Anova_',vars{v});
        %if isempty(strcmp(vname, properties(obj)))
        addprop(obj,vname);
        %end
        obj.(vname)=Anova(obj,'osc',vars{v});     
    end
    vars=LockingStrength.get_anova_variables();
    for v=1:length(vars)
        vname=strcat('Anova_',vars{v});
        %if isempty(strcmp(vname, properties(obj)))
        addprop(obj,vname);
        %end
        obj.(vname)=Anova(obj,'ls',vars{v});     
    end    
