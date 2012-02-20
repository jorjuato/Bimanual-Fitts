function plot(obj,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath=[];end

    fig=figure();
    ax1=subplot(1,2,1);
    ax2=subplot(1,2,2);
    obj.plot_vf(ax1);
    obj.plot_va(ax2);

    if ischar(graphPath)
        %Generate random sequence and append to the end (based on seconds or whatever)
        filename = 'VectorField';
        figname = joinpath(joinpath(graphPath,rootname),filename));
        saveas(fig,figname,ext);
        close(fig);
    end
end % plot
