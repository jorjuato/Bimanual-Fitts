function plot(obj,mode,graphPath,rootname,ext)
    if nargin<5, ext='fig';end
    if nargin<4, rootname='nosession';end
    if nargin<3, graphPath='';end  
    if nargin<2, mode=1; end
    
    obj.bimanual.plot(graphPath,rootname,ext);
    obj.uniLeft.plot(graphPath,rootname,ext);
    obj.uniRight.plot(graphPath,rootname,ext);
    obj.plot_relative_osc(mode,graphPath,rootname,ext);
end 
