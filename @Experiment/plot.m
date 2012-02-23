function plot(obj)
    plot_dir=joinpath(joinpath(getuserdir(),'KINARM'),'plots');
    if ~exist(plot_dir)
        mkdir(plot_dir);
    end
    for p=1:length(obj.participants)        
        obj.participants(p).plot();
    end
end
