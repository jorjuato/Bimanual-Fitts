function plot_param(mdl,no)
    if nargin<2, no=0; end

    if isempty(mdl.pset)
        error('You have to run a parametrization before')
    else
        mdl.plot_param_ts(no)
        mdl.plot_param_phsp(no)
        mdl.plot_param_cosphsp(no)
    end
end