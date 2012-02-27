function plot(obj)
    obj.plot_timeSeries();    
    obj.plot_oscillations();
    obj.plot_va();
    obj.plot_vf();
    
    if obj.conf.unimanual==0
        obj.plot_lockingStrength();
    end
end % plot
