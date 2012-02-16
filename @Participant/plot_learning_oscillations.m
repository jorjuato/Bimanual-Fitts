% Plots kinematic properties of data from a bimanual Fitts experiment withvariation of 
% either the phase (in-phase/anti-phase) or the viscosity.
% All plotting functionare included in the file. It should work
% with DS structures generated with getMultiResults_fb because it doesn't  
% depend on any parameter of DS structure, only its dimensions.

function  plot_learning_oscillations(obj,graphPath,ext)
    if nargin<3, ext='png';end
    if nargin<2, graphPath=joinpath(joinpath(getuserdir(),'KINARM'),'plots');end
    
    S = obj.sessions;
    session=S(1);
    blkNames = properties(session);
    blk = session.bimanual;
    [fcns, labels, ylims] = blk{1,1,1}.osc.get_plots();
    
    for f=1:length(fcns)        
        for b=1:length(blkNames)         
            if findstr(blkNames{b},'uni')
                rootname = sprintf('Learning-%s_%s',fcns{f},blkNames{b});            
                [f1, ~] = session.(blkNames{b}).size;   
                if graphPath
                    fig = figure('visible','off');
                else
                    fig = figure();
                end
                set(fig,'Name',blkNames{b});
                %FIX get_valid_sessions
                sessions = getValidSessions(S);
                Sno = length(sessions);
                oscNames = fieldnames(session.(blkNames{b}){1,end}.osc);
                bar_grps = zeros(f1,Sno,2);
                IDs = zeros(f1,1);
                %Fetch data
                for i=1:f1    
                    IDs(i) = S(sessions(1)).(blkNames{b}){i,end}.info.ID;
                    for s=1:Sno
                        osc = S(sessions(s)).(blkNames{b}){i,end}.osc;
                        bar_grps(i,s,1) = mean(filterOutliers(osc.(oscNames{f})));
                        bar_grps(i,s,2) = std(filterOutliers(osc.(oscNames{f})));
                    end
                end
                %Plot it
                %ylim(ylims{f});
                hold('off');
                set(0,'CurrentFigure',fig);
                title(sprintf('%s Learning in block %s',oscNames{f},blkNames{b}),'fontsize',14,'fontweight','b');
                xlabel('ID','fontweight','b');
                ylabel(labels{f},'fontweight','b','Rotation',90);
                hold on;
                h = bar(IDs,bar_grps(:,:,1),'grouped');
                x = getBarCentroids(get(get(h(1),'children'),'xdata'));         
                errorbar(x,bar_grps(:,1,1),bar_grps(:,1,2),'k', 'linestyle', 'none', 'linewidth', 1);
                x = getBarCentroids(get(get(h(2),'children'),'xdata'));         
                errorbar(x,bar_grps(:,2,1),bar_grps(:,2,2),'k', 'linestyle', 'none', 'linewidth', 1);
                legendCell = cell(Sno);
                for s=1:Sno                    
                    legendCell{s} = sprintf('Session %d',s);
                end
                hl = legend(h(1:Sno),legendCell{1:Sno});
                set(hl,'FontSize',8);      
                set(gca,'XTick',sort(IDs));
                hold off;
                if graphPath
                    figname = joinpath(graphPath,rootname);
                    if strcmp(ext,'fig')
                        hgsave(fig,figname);
                    else
                        saveas(fig,figname,ext); close(fig);
                    end
                end
            elseif findstr(blkNames{b},'bi')
                rootname = sprintf('Learning-%s_%s',fcns{f},blkNames{b});            
                [f1, f2, ~] = session.(blkNames{b}).size;   
                sessions = getValidSessions(S);
                Sno = length(sessions);
                oscNames = properties(S(1).(blkNames{b}){1,1,end}.oscL);
                for i=1:f1
                    bar_grps = zeros(f2,2*Sno,2);
                    IDs = zeros(f2,1);
                    for j=1:f2
                        IDs(j) = S(sessions(1)).(blkNames{b}){i,j,end}.info.IDR;
                        for s=1:Sno
                            DS = S(sessions(s)).(blkNames{b});                            
                            oscL = DS{i,j,end}.oscL;
                            oscR = DS{i,j,end}.oscR;
                            bar_grps(j,s,1) = mean(filterOutliers(oscL.(oscNames{f})));
                            bar_grps(j,s,2) = ste(filterOutliers(oscL.(oscNames{f})));
                            bar_grps(j,Sno+s,1) = mean(filterOutliers(oscR.(oscNames{f})));
                            bar_grps(j,Sno+s,2) = ste(filterOutliers(oscR.(oscNames{f})));
                        end
                    end
                    %ylim(ylims{f});
                    if graphPath
                        fig = figure('visible','off');
                    else
                        fig = figure();
                    end
                    set(fig,'Name',blkNames{b});
                    hold('off');
                    set(0,'CurrentFigure',fig);
                    %subpl = subplot(1,f1,i);
                    subpl = gca;
                    title(sprintf('ID Left=%1.1f / %s Learning in block %s',DS{i,1,1}.info.IDL,oscNames{f},blkNames{b}),'fontsize',14,'fontweight','b');
                    xlabel('ID Right','fontweight','b');
                    ylabel(labels{f},'fontweight','b','Rotation',90);
                    hold on;
                    h = bar(IDs,bar_grps(:,:,1),'grouped');
                    red = [1,0,0];
                    blue = [0,0,1];
                    legendCell = cell(2*Sno);
                    for s=1:Sno                    
                        set(h(s),'FaceColor',red/s,'EdgeColor','k');
                        set(h(Sno+s),'FaceColor',blue/s,'EdgeColor','k');
                        legendCell{s} = sprintf('Left S%d',s);
                        legendCell{Sno+s} = sprintf('Right S%d',s);
                    end
                    for j = 1:2*Sno
                        x = getBarCentroids(get(get(h(j),'children'),'xdata'));
                        errorbar(x,bar_grps(:,j,1),bar_grps(:,j,2),'k', 'linestyle', 'none', 'linewidth', 0.5);
                    end
                    hl = legend(h(1:Sno*2),legendCell{1:Sno*2},'Location','Best');  
                    set(hl,'FontSize',8);
                    ymin = min(min(bar_grps(:,:,1)));
                    ymax = max(max(bar_grps(:,:,1)));
                    ylim = [ymin-ymin/10,ymax+ymax/10 ];
                    if strcmp(fcns{f},'Acceleration Time') || strcmp(fcns{f},'Deceleration Time')
                        xmin = min(min(get(get(h(1),'children'),'xdata')));
                        xmax = max(max(get(get(h(end),'children'),'xdata')));
                        line([xmin,xmax],[0.5,0.5],'Color','k','LineWidth',2);
                    end
                    set(subpl,'XTick',sort(round(IDs*10)/10));
                    set(subpl,'ylim',ylim);
                    hold off;
                    if graphPath
                        filename = sprintf('%s-IDLeft-%d',rootname,round(DS{i,1,1}.info.IDL));
                        figname = joinpath(graphPath,filename);
                        if strcmp(ext,'fig')
                            hgsave(fig,figname,'all');
                        else
                            saveas(fig,figname,ext); close(fig);
                        end
                    end
                end
            end
        end                           
    end
end
