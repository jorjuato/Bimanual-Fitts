function plot(obj,figname)
    if nargin<2, figname=''; end
    
    obj.plot_timeSeries();
    obj.plot_lockingStrength();
    obj.plot_oscillations();
    obj.plot_vectorField():
end % plot
