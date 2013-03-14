function plot_vf(tr,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath='';end
    
    if isa(tr.ts,'TimeSeriesUnimanual')
        vf=tr.vf;
        x=tr.ts.xnorm;
        v=tr.ts.vnorm;
    elseif findstr(rootname,'R')
        vf=tr.vfR;
        x=tr.ts.Rxnorm;
        v=tr.ts.Rvnorm;
    elseif findstr(rootname,'L')
        vf=tr.vfL;
        x=tr.ts.Lxnorm;
        v=tr.ts.Lvnorm;
    else 
        return
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
    
    in{1}=ax;in{2}=x;in{3}=v;

    vf.plot_vf(in);
    
    if ischar(graphPath) & ~isempty(graphPath)
        hgsave(fig,figname); close fig;
    end
end
