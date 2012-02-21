function plot(obj,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath='';end
    
    timeseries_dir     =joinpath(graphPath,'timeSeries');
    oscillations_dir   =joinpath(graphPath,'oscillations');    
    vf_dir             =joinpath(graphPath,'vectorFields');

    mkdir(timeseries_dir);
    mkdir(oscillations_dir);    
    mkdir(vf_dir);    
    rootname='';
    
    
    obj.plot_timeSeries(obj.size(end),timeseries_dir,rootname,ext);    
    obj.plot_oscillations(oscillations_dir,rootname,ext);
    %obj.plot_vectorFields(1,vf_dir,rootname,ext);
    obj.plot_va(vf_dir,rootname,ext);
    obj.plot_vf(vf_dir,rootname,ext);
    
    if obj.unimanual==0
        lockingStrength_dir=joinpath(graphPath,'lockingStrength');
        mkdir(lockingStrength_dir);
        obj.plot_lockingStrength(lockingStrength_dir,rootname,ext);
    end
end % plot
