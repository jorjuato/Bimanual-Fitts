function plot(obj,graphPath,ext)
    obj.plot_vf(graphPath,ext)
    obj.ts.plot(graphPath,ext)
    if isa(obj.ts,'TimeSeriesBimanual')
        obj.oscL.plot(graphPath,ext)
        obj.oscR.plot(graphPath,ext)
        obj.ls.plot(graphPath,ext)
    else
        obj.osc.plot(graphPath,ext)
    end
