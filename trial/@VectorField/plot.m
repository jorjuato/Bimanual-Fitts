function plot(obj,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath=[];end

    fig=figure();
    subplot(1,3,1);
    %plot(tr.xnorm,tr.vnorm,'color',[1,.7,1]);
    %hold on;
    i=isfinite(obj.vectors{1}) & isfinite(obj.vectors{2});
    [X,Y]=meshgrid(obj.vectors{end}{1},obj.vectors{end}{2});
    quiver(X(i),Y(i),obj.vectors{1}(i),obj.vectors{2}(i));
    %hold off;
    axis tight;
    subplot(1,3,2);
    imagesc(flipud(obj.angles{1}),[0,pi]);
    subplot(1,3,3);
    imagesc(flipud(obj.angles{2}),[0,pi]);

    if ischar(graphPath)
        %Generate random sequence and append to the end (based on seconds or whatever)
        filename = 'VectorField';
        figname = joinpath(joinpath(graphPath,rootname),filename));
        saveas(fig,figname,ext);
        close(fig);
    end
end % plot
