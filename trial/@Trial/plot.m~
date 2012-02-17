function plot(obj)
    obj.plot_vf()
    obj.ts.plot()
    if isa(obj.ts,'TimeSeriesBimanual')
        obj.oscL.plot()
        obj.oscR.plot()
        obj.ls.plot()
    else
        obj.osc.plot()
    end
