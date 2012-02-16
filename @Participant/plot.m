% Plots kinematic properties of data from a bimanual Fitts experiment withvariation of 
% either the phase (in-phase/anti-phase) or the viscosity.
% All plotting functionare included in the file. It should work
% with DS structures generated with getMultiResults_fb because it doesn't  
% depend on any parameter of DS structure, only its dimensions.

function  plot(obj,graphPath,ext)
    if nargin<3, ext='png';end
    if nargin<2, graphPath=joinpath(joinpath(getuserdir(),'KINARM'),'plots');end
    
    mode=1;
    
    obj.plot_learning_oscillations(graphPath,ext);
    obj.plot_learning_relative(mode,graphPath,ext);    
    obj.plot_learning_lockingStrength(graphPath,ext);D
    obj.plot_learning_vf(graphPath,ext);

    for i=1:obj.size
        S = obj(s)
        if S.train == 0
            S.plot()
        end
    end
end
