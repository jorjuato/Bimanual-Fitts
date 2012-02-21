% Plots kinematic properties of data from a bimanual Fitts experiment withvariation of 
% either the phase (in-phase/anti-phase) or the viscosity.
% All plotting functionare included in the file. It should work
% with DS structures generated with getMultiResults_fb because it doesn't  
% depend on any parameter of DS structure, only its dimensions.

function  plot(obj,graphPath,ext)
    if nargin<3, ext='png';end
    if nargin<2, graphPath=joinpath(joinpath(getuserdir(),'KINARM'),'plots');end
    
    mode=1;
    if ischar(obj.name)
        name=obj.name;
    else
        name=num2str(obj.name,'%03d');
    end
    root_dir           =joinpath(graphPath,name);
    learning_dir       =joinpath(root_dir,    'Learning');
    oscillations_dir   =joinpath(learning_dir,'oscillations');
    relative_dir       =joinpath(learning_dir,'relative');
    lockingStrength_dir=joinpath(learning_dir,'lockingStrength');
    vf_dir             =joinpath(learning_dir,'vectorFields');
    mkdir(root_dir);
    mkdir(learning_dir);
    mkdir(oscillations_dir);
    mkdir(relative_dir);
    mkdir(lockingStrength_dir);
    mkdir(vf_dir);
    
    obj.plot_learning_oscillations(oscillations_dir,ext);
    obj.plot_learning_relative(mode,relative_dir,ext);    
    obj.plot_learning_lockingStrength(lockingStrength_dir,ext);
    %obj.plot_learning_vf(vf_dir,ext);
	obj.plot_vf(vf_dir,ext);
	obj.plot_va(vf_dir,ext);
	
    for s=1:obj.size
        if obj.sessions(s).train == 0
            rootname=strcat('session',num2str(s));
            obj.sessions(s).plot(mode,root_dir,rootname,ext);
        end
    end
end
