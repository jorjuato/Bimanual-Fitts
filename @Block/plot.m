function plot(obj,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath=joinpath(joinpath(getuserdir(),'KINARM'),'plots');end
    
    obj.plot_timeSeries(obj.size(end),graphPath,rootname,ext);
    obj.plot_lockingStrength(graphPath,rootname,ext);
    obj.plot_oscillations(graphPath,rootname,ext);
    obj.plot_vectorFields(1,graphPath,rootname,ext);
end % plot
