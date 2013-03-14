function plot_vf(obj,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath='';end

    if ischar(graphPath)
        fig=figure();
        ax=subplot(1,3,1);
    elseif iscell(graphPath)
        ax=graphPath{1};
        x=graphPath{2};
        v=graphPath{3};
        plot(ax,x,v,'color',[1,.7,1]);
    else
        ax=graphPath;
    end
    hold on;
    i=isfinite(obj.vectors{1}) & isfinite(obj.vectors{2});
    [X,Y]=meshgrid(obj.vectors{end}{1},obj.vectors{end}{2});
    quiver(ax,X(i),Y(i),obj.vectors{1}(i),obj.vectors{2}(i));
    hold off;
%     
%     if hState == 1
%         hold on;
%     else
%         hold off;
%     end
%     
    if ischar(graphPath)
        %Generate random sequence and append to the end (based on seconds or whatever)
        filename = 'VectorField';
        figname = joinpath(joinpath(graphPath,rootname),filename);
        saveas(fig,figname,ext);
        close(fig);
    end
end % plot
