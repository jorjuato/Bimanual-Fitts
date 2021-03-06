function plot_va(obj,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath='';end

    if isempty(graphPath)
        fig=figure();
        ax=subplot(1,1,1); hold on;
    elseif ischar(graphPath)
        fig=figure();
        ax=subplot(1,1,1);
    else
        ax=graphPath;
    end

    imagesc(flipud(obj.angles{2}),[0,pi]);
    set(ax, 'XTick',[], 'XTickLabel',[]);
    set(ax, 'YTick',[], 'YTickLabel',[]);
    
    if ischar(graphPath) && ~isempty(graphPath)
        %Generate random sequence and append to the end (based on seconds or whatever)
        filename = 'VectorAngles';
        figname = joinpath(joinpath(graphPath,rootname),filename);
        saveas(fig,figname,ext);
        close(fig);
    end
end % plot
