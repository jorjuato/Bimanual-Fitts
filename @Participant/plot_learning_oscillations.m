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
    tr = blk.data_set{1,1,1};
    oscNames = properties(tr.oscL);
    [fcns, labels, ylims] = tr.oscL.get_plots();
    
    for f=1:length(fcns)        
        for b=1:length(blkNames)         
            if findstr(blkNames{b},'uni')
                rootname = sprintf('Learning_%s_',blkNames{b});           
                [f1, ~] = size(obj.sessions(1).(blkNames{b}).data_set);   
                if graphPath
                    fig = figure('visible','off');
                else
                    fig = figure();
                end
                set(fig,'Name',blkNames{b});
                %FIX get_valid_sessions
                sessions = getValidSessions(obj);
                Sno = length(sessions);
                %oscNames = fieldnames(session.(blkNames{b}){1,end}.osc);
                bar_grps = zeros(f1,Sno,2);
                IDs = zeros(f1,1);
                %Fetch data
                for i=1:f1    
                    IDs(i) = S(sessions(1)).(blkNames{b}).data_set{i,end}.info.ID;
                    for s=1:Sno
                        osc = S(sessions(s)).(blkNames{b}).data_set{i,end}.osc;
                        bar_grps(i,s,1) = mean(filterOutliers(osc.(oscNames{f})));
                        bar_grps(i,s,2) = std(filterOutliers(osc.(oscNames{f})));
                    end
                end
                %Plot it
                %ylim(ylims{f});
                %hold('off');
                %set(0,'CurrentFigure',fig);

                hold on;
                h = bar(IDs,bar_grps(:,:,1),'grouped');
                x = getBarCentroids(get(get(h(1),'children'),'xdata'));         
                errorbar(x,bar_grps(:,1,1),bar_grps(:,1,2),'k', 'linestyle', 'none', 'linewidth', 1);
                x = getBarCentroids(get(get(h(2),'children'),'xdata'));         
                errorbar(x,bar_grps(:,2,1),bar_grps(:,2,2),'k', 'linestyle', 'none', 'linewidth', 1);
                hold off;
                
                %Plot legend
                for s=1:Sno                    
                    legendCell{s} = sprintf('Session %d',s);
                end
                hl = legend(h(1:Sno),legendCell{1:Sno},'Location','BestOutside');
                set(hl,'FontSize',8);      
                
                %More graphical traits
                set(gca,'XTick',sort(IDs));
                title(sprintf('%s Learning in block %s',oscNames{f},blkNames{b}),'fontsize',14,'fontweight','b');
                xlabel('ID','fontweight','b');
                ylabel(labels{f},'fontweight','b','Rotation',90);
                %hold off;
                %Save plot
                if graphPath
                    filename = strcat(rootname,oscNames{f});
                    figname = joinpath(graphPath,filename);
                    if strcmp(ext,'fig')
                        hgsave(fig,figname);
                    else
                        saveas(fig,figname,ext); close(fig);
                    end
                end
            elseif findstr(blkNames{b},'bi')
                %Create figure for interactive or batch mode
                if graphPath
                    fig = figure('visible','off');
                else
                    fig = figure();
                end
                
                %Get some information to organize the plots
                rootname = sprintf('Learning_%s_',blkNames{b});
                blk=session.(blkNames{b});
                [f1, f2, ~] = size(blk.data_set);
                sessions = getValidSessions(obj);
                Sno = length(sessions);    
                
                %Fetch data           
                for i=1:f1
                    bar_grps = zeros(f2,2*Sno,f1,2);
                    IDs = zeros(f2,1);
                    for j=1:f2
                        IDs(j) = obj.sessions(1).bimanual.data_set{i,j,1}.info.RID;
                        for s=1:Sno
                            DS = obj.sessions(sessions(s)).(blkNames{b}).data_set;   
                            oscL = DS{i,j,end}.oscL;
                            oscR = DS{i,j,end}.oscR;
                            bar_grps(j,s,i,1) = mean(filterOutliers(oscL.(oscNames{f})));
                            bar_grps(j,s,i,2) = ste(filterOutliers(oscL.(oscNames{f})));
                            bar_grps(j,Sno+s,i,1) = mean(filterOutliers(oscR.(oscNames{f})));
                            bar_grps(j,Sno+s,i,2) = ste(filterOutliers(oscR.(oscNames{f})));
                        end
                    end
                    
                    %Start first subplot
                    %ylim(ylims{f});
                    
                    %set(0,'CurrentFigure',fig);
                    subpl = subplot(1,f1,i);
                    %subpl = gca;

                    %Do the bar-errors plotting
                    hold on;
                    h = bar(IDs,bar_grps(:,:,i,1),'grouped');
                    for j = 1:2*Sno
                        x = getBarCentroids(get(get(h(j),'children'),'xdata'));
                        errorbar(x,bar_grps(:,j,i,1),bar_grps(:,j,i,2),'k', 'linestyle', 'none', 'linewidth', 0.5);
                    end
                    hold off;
                    
                    %Make a nice legend
                    red = [1,0,0];
                    blue = [0,0,1];
                    legendCell = cell(2*Sno);
                    for s=1:Sno                    
                        set(h(s),'FaceColor',red/s,'EdgeColor','k');
                        set(h(Sno+s),'FaceColor',blue/s,'EdgeColor','k');
                        legendCell{s} = sprintf('Left S%d',s);
                        legendCell{Sno+s} = sprintf('Right S%d',s);
                    end

                    %Only plot legend in second subplot
                    if i==2
                        hl = legend(h(1:Sno*2),legendCell{1:Sno*2},'Location','North');  
                        set(hl,'FontSize',8);
                        set(fig,'Name',blkNames{b});
                    end
                    
                    %Some more aesthetics
                    title(sprintf('IDL=%1.1f / %s Learning',DS{i,1,1}.info.LID,oscNames{f}),'fontsize',14,'fontweight','b');
                    xlabel('IDR','fontweight','b');
                    ylabel(labels{f},'fontweight','b','Rotation',90);
                    ymin = min(min(bar_grps(:,:,i,1)));
                    ymax = max(max(bar_grps(:,:,i,1)));
                    ylim = [ymin-ymin/10,ymax+ymax/10 ];
                    
                    if strcmp(fcns{f},'Acceleration Time') || strcmp(fcns{f},'Deceleration Time')
                        xmin = min(min(get(get(h(1),'children'),'xdata')));
                        xmax = max(max(get(get(h(end),'children'),'xdata')));
                        line([xmin,xmax],[0.5,0.5],'Color','k','LineWidth',2);
                    end
                    set(subpl,'XTick',sort(round(IDs*10)/10));
                    set(subpl,'ylim',ylim);                    
                end
                if graphPath
                    filename = strcat(rootname,oscNames{f});
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
