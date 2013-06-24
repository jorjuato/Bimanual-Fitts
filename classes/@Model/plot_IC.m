function plot_IC(mdl,no)
    if nargin<2, no=0; end
    if isempty(mdl.icset)
        error('You have to run an IC simulation before')
    else
        mdl.plot_IC_ts(no);
        %mdl.plot_IC_phsp(no);
    end
end