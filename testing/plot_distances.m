function plot_distances(tr,filename)
    if nargin<2, filename=''; end  

    figure();
    subplot(5,1,1)
    plot_time_series(tr.ts);    
    subplot(5,1,2)
    plot(phasedist4D(tr));
    subplot(5,1,3)
    plot(phasedist3D(tr));
    subplot(5,1,4)
    plot(phasedist2D(tr));
    subplot(5,1,5)
    plot(phasedist1D(tr));
    
    %Save to disk if filename provided
    if ~isempty(filename)
        saveas(gcf,filename,'png');
    end
end