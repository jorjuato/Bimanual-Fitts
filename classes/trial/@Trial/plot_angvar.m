function plot_angvar(tr,graphPath,vname,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath='';end
    
    %Select the data to plot
    if isa(tr.ts,'TimeSeriesUnimanual')
        v=tr.ts.([vname,'_hist']);
    else
        v=tr.ts.([rootname,vname,'_hist']);
    end

    %Choose interactive or not plot
    if ischar(graphPath)
        if graphPath
            fig = figure('visible','off');            
            ax=subplot(111);
        else
            fig=figure();
            ax=subplot(111);
        end
    else
        ax=graphPath;
    end
    
    bar(ax,v);
    vline(length(v)/2,'k');
    xlim([0,length(v)]);
    
    if ischar(graphPath) & ~isempty(graphPath)
        figname=joinpath(graphPath,[rootname,vname,'_hist.',ext]);
        hgsave(fig,figname); close fig;
    end
end

