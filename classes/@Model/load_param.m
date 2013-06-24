function load_param(mdl,parval)
    if length(mdl.params) == length(parval)
        if iscell(parval)
            mdl.params = parval;
        else
            mdl.params=num2cell(parval);
        end
    else
        error('Wrong number of parameters for current model')
    end
end