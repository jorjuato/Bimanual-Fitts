function plot_va(tr,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath='';end
    
    %Choose the vector field objectto plot
    if isa(tr.ts,'TimeSeriesUnimanual')
        vf=tr.vf;
    elseif findstr(rootname,'R')
        vf=tr.vfR;
    else
        vf=tr.vfL;
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
    
    vf.plot_va(ax);
    
    if ischar(graphPath) & ~isempty(graphPath)
        hgsave(fig,figname); close fig;
    end
end
