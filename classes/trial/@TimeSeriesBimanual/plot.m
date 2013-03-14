function plot(obj,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath=[];end
    
    single_figure=0;
    
    [fcns, names, xlabels, ylabels] = obj.get_plots();
    %Create figure for this function
    if single_figure==1
        if ischar(graphPath) 
            fig = figure('visible','off');
        elseif ~iscell(graphPath)
            fig = figure();
        end
    end
    %Apply plotting methods
    for f=1:length(fcns)
        %Create subplot and call plotting function
        if single_figure==1
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
        else
            if ischar(graphPath)
                fig = figure('visible','off');
            elseif ~iscell(graphPath)
                fig = figure();
            end
            fcns{f}(obj);
            ylabel(ylabels{f});
            xlabel(xlabels{f});
        end
        
    end
    if ischar(graphPath)
        %Generate random sequence and append to the end (based on seconds or whatever)
        filename = 'TimeSeriesBimanual';
        figname = joinpath(joinpath(graphPath,rootname),filename);
        saveas(fig,figname,ext);
        close(fig);
    end
end
