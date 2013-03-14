function plot(obj,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname=[];end
    if nargin<2, graphPath=[];end
    
    obj.plot_vf(graphPath,rootname,ext)
    obj.ts.plot(graphPath,rootname,ext)
    if isa(obj.ts,'TimeSeriesBimanual')
        obj.oscL.plot(graphPath,rootname,ext)
        obj.oscR.plot(graphPath,rootname,ext)
        obj.ls.plot(graphPath,rootname,ext)
    else
        obj.osc.plot(graphPath,rootname,ext)
    end
