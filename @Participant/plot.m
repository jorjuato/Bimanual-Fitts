% Plots kinematic properties of data from a bimanual Fitts experiment withvariation of 
% either the phase (in-phase/anti-phase) or the viscosity.
% All plotting functionare included in the file. It should work
% with DS structures generated with getMultiResults_fb because it doesn't  
% depend on any parameter of DS structure, only its dimensions.

function  plot(obj)
    oscillations_dir   =joinpath(obj.conf.learning_dir,'oscillations');
    relative_dir       =joinpath(obj.conf.learning_dir,'relative');
    lockingStrength_dir=joinpath(obj.conf.learning_dir,'lockingStrength');
    vf_dir             =joinpath(obj.conf.learning_dir,'vectorFields');
    
    if ~exist(obj.conf.plot_participant_path,'dir') & obj.conf.interactive==0
        mkdir(obj.conf.plot_participant_path);
    end
    if ~exist(obj.conf.learning_dir,'dir') & obj.conf.interactive==0
        mkdir(obj.conf.learning_dir);
    end
    
    obj.plot_learning_oscillations(oscillations_dir);
    obj.plot_learning_relative(relative_dir);    
    obj.plot_learning_lockingStrength(lockingStrength_dir);
    %obj.plot_learning_vf(vf_dir,ext);
	obj.plot_vf(vf_dir);
	obj.plot_va(vf_dir);
	
    for s=1:obj.size
        if obj.sessions(s).train == 0
            obj.sessions(s).plot();
        end
    end
end
