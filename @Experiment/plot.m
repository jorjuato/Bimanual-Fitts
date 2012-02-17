function plot(obj)
    plot_dir=joinpath(joinpath(getuserdir(),'KINARM'),'plots');
    mkdir(plot_dir);
    for p=1:length(obj.participants)        
        %rootname=strcat('participant',num2str(p,'%03d'));
        %participant_plot_dir=joinpath(plot_dir,rootname); 
        %mkdir(participant_plot_dir);
        obj.participants(p).plot();
    end
end
