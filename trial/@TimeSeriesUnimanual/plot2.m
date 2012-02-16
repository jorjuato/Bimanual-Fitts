function plot(obj,graphPath,ext)
if nargin<3, ext='fig';end
if nargin<2, graphPath='';end

[fcns, names, xlabels, ylabels] = obj.get_plots();
%Create figure for this function
if graphPath
    fig = figure('visible','off');
else
    fig = figure();
end
%Apply plotting methods
for f=1:length(fcns)
    %Create subplot and call plotting function
    subplot(1,f,f1);
    fcns{f}(obj);
    ylabel(ylabels{f});
    xlabel(xlabels{f});
end
if graphPath
    %Generate random sequence and append to the end (based on seconds or whatever)
    filename = 'TimeSeriesPlotUnimanual';
    figname = joinpath(graphPath,filename);
    saveas(fig,figname,ext);
    close(fig);
end

end % plot