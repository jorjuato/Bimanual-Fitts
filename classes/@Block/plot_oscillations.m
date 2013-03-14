% Plots kinematic properties of data from a bimanual Fitts experiment withvariation of 
% either the phase (in-phase/anti-phase) or the viscosity.
% All plotting functionare included in the file. It should work
% with DS structures generated with getMultiResults_fb because it doesn't  
% depend on any parameter of DS structure, only its dimensions.

function  plot_oscillations(obj)
    graphPath=joinpath(obj.conf.plot_block_path,'oscillations');
    if ~exist(graphPath,'dir') & obj.conf.interactive==0
        mkdir(graphPath);
    end
    
    DS = obj.data_set;
    
        
    if obj.conf.unimanual==1
        oscData = properties(DS{1,end}.osc);
        [f1, ~] = size(DS);
        [names, labels, ylims] = DS{1,1,end}.osc.get_plots();
    else
        oscData = properties(DS{1,1,end}.oscL);
        [f1, f2, ~] = size(DS);
        [names, labels, ylims] = DS{1,1,end}.oscL.get_plots();
    end
    

    for f=1:length(oscData)
        if obj.conf.interactive==0
            fig = figure('visible','off');
        else
            fig = figure();
        end
        set(fig,'Name',names{f});
        
        if obj.conf.unimanual==1
            bar_grps = zeros(f1,2);
            IDs = zeros(f1,1);
            for i=1:f1
                IDs(i) = DS{i,end}.info.ID;
                osc = DS{i,end}.osc;
                bar_grps(i,1) = mean(filterOutliers(osc.(oscData{f})));
                bar_grps(i,2) = std(filterOutliers(osc.(oscData{f})));
            end
            %ylim(ylims{f});
            hold('off');
            set(0,'CurrentFigure',fig);
            title(names{f},'fontsize',14,'fontweight','b');
            xlabel('ID','fontweight','b');
            ylabel(labels{f},'fontweight','b','Rotation',90);
            hold on;
            h = bar(IDs,bar_grps(:,1),'grouped');
            x = getBarCentroids(get(get(h(1),'children'),'xdata'));  
            errorbar(x,bar_grps(:,1),bar_grps(:,2),'k', 'linestyle', 'none', 'linewidth', 2);
            set(gca,'XTick',sort(IDs));
            hold off;
            if graphPath
                filename = sprintf('%s-%s',rootname,names{f});
                figname = joinpath(graphPath,filename);
                saveas(fig,figname,ext); close(fig);
            end
        else %Bimanual                    
            for i=1:f1
                bar_grps = zeros(f2,2,2);
                IDs = zeros(f2,1);
                for j=1:f2
                    IDs(j) = DS{i,j,end}.info.RID;
                    oscL = DS{i,j,end}.oscL;
                    oscR = DS{i,j,end}.oscR;
                    bar_grps(j,1,1) = mean(filterOutliers(oscL.(oscData{f})));
                    bar_grps(j,1,2) = ste(filterOutliers(oscL.(oscData{f})));
                    bar_grps(j,2,1) = mean(filterOutliers(oscR.(oscData{f})));
                    bar_grps(j,2,2) = ste(filterOutliers(oscR.(oscData{f})));
                end
                %ylim(ylims{f});
                hold('off');
                set(0,'CurrentFigure',fig);
                subplot(1,f1,i);
                title(sprintf('ID Left=%1.1f, %s',DS{i,1,1}.info.LID,oscData{f}),'fontsize',14,'fontweight','b');
                xlabel('ID Right','fontweight','b');
                ylabel(labels{f},'fontweight','b','Rotation',90);
                hold on;
                h = bar(IDs,bar_grps(:,:,1),'grouped');
                x = getBarCentroids(get(get(h(1),'children'),'xdata'));  
                errorbar(x,bar_grps(:,1,1),bar_grps(:,1,2),'k', 'linestyle', 'none', 'linewidth', 2);
                x = getBarCentroids(get(get(h(2),'children'),'xdata'));  
                errorbar(x,bar_grps(:,2,1),bar_grps(:,2,2),'k', 'linestyle', 'none', 'linewidth', 2);
                h = legend('Left','Rigth');
                set(h,'FontSize',8);
                set(gca,'XTick',sort(IDs));
                hold off;
            end
         
            if exist(graphPath) & obj.conf.interactive==0
                figname = joinpath(graphPath,oscData{f});
                saveas(fig,figname,obj.conf.ext); close(fig);
            end
        end
    end
end
