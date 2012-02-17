function plot(obj,mode,graphPath,rootname,ext)
    if nargin<5, ext='fig';end
    if nargin<4, rootname='nosession';end
    if nargin<3, graphPath='';end  
    if nargin<2, mode=1; end
    
    root_dir=joinpath(graphPath,rootname);
    bi_dir  =joinpath(root_dir,'Bimanual');
    uL_dir  =joinpath(root_dir,'UnimanualLeft');
    uR_dir  =joinpath(root_dir,'UnimanualRight');
    rel_dir =joinpath(root_dir,'Relative');
    mkdir(root_dir);
    mkdir(bi_dir);
    mkdir(uL_dir);
    mkdir(uR_dir);
    mkdir(rel_dir);
    rootname='';
    obj.bimanual.plot(bi_dir,rootname,ext);
    obj.uniLeft.plot(uL_dir,rootname,ext);
    obj.uniRight.plot(uR_dir,rootname,ext);
    obj.plot_relative_osc(mode,rel_dir,rootname,ext);
end 
