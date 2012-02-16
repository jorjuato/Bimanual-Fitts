function plot_relative_osc(obj,mode,graphPath,rootname,ext)
    if nargin<5, ext='fig';end
    if nargin<4, rootname='nosession';end
    if nargin<3, graphPath='';end  
    if nargin<2, mode=1; end
    
    bimanual=obj.bimanual;
    uniRight=obj.uniRight;
    uniLeft=obj.uniLeft;
    tr=uniLeft{1,end};
    oscData = properties(tr.osc);
    [names, labels, ylims] = tr.osc.get_plots();

    [f1, f2, ~] = obj.bimanual.size;

    for f=1:length(oscData)
        if graphPath
            fig = figure('visible','off');
        else
            fig = figure();
        end
        set(fig,'Name',names{f});
                         
        for i=1:f1
            bar_grps = zeros(f2,2,2);
            IDs = zeros(f2,1);
            for j=1:f2
                IDs(j) = bimanual{i,j,end}.info.IDR;
                oscL   = bimanual{i,j,end}.oscL;
                oscLu  = uniLeft{i,end}.osc;
                oscR   = bimanual{i,j,end}.oscR;
                oscRu  = uniRight{j,end}.osc;
                bar_grps(j,1,1) = get_mean(oscL.(oscData{f}),oscLu.(oscData{f}),mode);
                bar_grps(j,1,2) = get_stderr(oscL.(oscData{f}),oscLu.(oscData{f}),mode);
                bar_grps(j,2,1) = get_mean(oscR.(oscData{f}),oscRu.(oscData{f}),mode);
                bar_grps(j,2,2) = get_stderr(oscR.(oscData{f}),oscRu.(oscData{f}),mode);
            end
            %ylim(ylims{f});
            hold('off');
            %set(0,'CurrentFigure',fig);
            subpl = subplot(1,f1,i);
            title(sprintf('ID Left=%1.1f',bimanual{i,1,1}.info.IDL),'fontsize',14,'fontweight','b');
            xlabel('ID Right','fontweight','b');
            ylabel(labels{f},'fontweight','b','Rotation',90);
            hold on;
            h=bar(IDs,bar_grps(:,:,1),'grouped');
            x = getBarCentroids(get(get(h(1),'children'),'xdata'));
            errorbar(x,bar_grps(:,1,1),bar_grps(:,1,2),'k', 'linestyle', 'none', 'linewidth', 0.7);
            x = getBarCentroids(get(get(h(2),'children'),'xdata'));
            errorbar(x,bar_grps(:,2,1),bar_grps(:,2,2),'k', 'linestyle', 'none', 'linewidth', 0.7);
            if mode == 1 || mode == 4 %Plot a line in y=1 to show the equivalence point
                xmin = min(min(get(get(h(1),'children'),'xdata')));
                xmax = max(max(get(get(h(end),'children'),'xdata')));
                line([xmin,xmax],[1,1],'Color','k','LineWidth',2);
            end
            hl = legend('Left','Rigth');
            set(hl,'FontSize',8);
            ymin = min(min(bar_grps(:,:,1)));
            ymax = max(max(bar_grps(:,:,1)));
            if isfinite(ymin) && isfinite(ymax)
                ylim = [ymin-abs(ymin)/10,ymax+abs(ymax)/10 ];
                set(subpl,'ylim',ylim);
            end
            set(subpl,'XTick',sort(round(IDs*10)/10));
            hold off;
        end

        if graphPath
            filename = sprintf('%s-%s',rootname,oscData{f});
            figname = joinpath(graphPath,filename);
            saveas(fig,figname,ext); close(fig);
        end
    end
end 
