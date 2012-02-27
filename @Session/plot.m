function plot(obj)
    if ~exist(obj.conf.plot_session_path,'dir') & obj.conf.interactive==0
        mkdir(obj.conf.plot_session_path);
    end
    
    obj.bimanual.plot();
    obj.uniLeft.plot();
    obj.uniRight.plot();
    obj.plot_relative_osc();
    obj.plot_va();
    obj.plot_vf();
end 
