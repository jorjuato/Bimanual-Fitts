function plot(obj,graphPath,ext)
    if nargin<3, ext='fig';end
    if nargin<2, graphPath='';end

    [fcns, names, xlabels, ylabels] = obj.get_plots();
    %Create figure for this function
    if ischar(graphPath) 
        fig = figure('visible','off');
    elseif ~iscell(graphPath)
        fig = figure();
    end
    %Apply plotting methods
    for f=1:length(fcns)
        %Create subplot and call plotting function
        if iscell(graphPath)
            fcns{f}(obj,graphPath{f});
            ylabel(graphPath{f},ylabels{f});
            xlabel(graphPath{f},xlabels{f});
        else
            subplot(1,length(fcns),f);
            fcns{f}(obj);
            ylabel(ylabels{f});
            xlabel(xlabels{f});
        end
        
    end
    if ischar(graphPath)
        %Generate random sequence and append to the end (based on seconds or whatever)
        filename = 'TimeSeriesPlot';
        figname = joinpath(graphPath,filename);
        saveas(fig,figname,ext);
        close(fig);
    end
end