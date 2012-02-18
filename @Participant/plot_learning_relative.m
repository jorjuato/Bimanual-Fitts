% Plots kinematic properties of data from a bimanual Fitts experiment withvariation of 
% either the phase (in-phase/anti-phase) or the viscosity.
% All plotting functionare included in the file. It should work
% with DS structures generated with getMultiResults_fb because it doesn't  
% depend on any parameter of DS structure, only its dimensions.

function  plot_learning_relative(obj,mode,graphPath,ext)     
    if nargin<4, ext='png';end
    if nargin<3, graphPath=joinpath(joinpath(getuserdir(),'KINARM'),'plots');end
    if nargin<2, mode=1; end
    
    S = obj.sessions;
    session=S(1);
    blk = session.bimanual.data_set;
    [f1, f2, ~] = size(blk); 
    oscNames = properties(blk{1,1,end}.oscL);
    [fcns, labels, ylims] = blk{1,1,1}.oscL.get_plots();
    
    for f=1:length(fcns)        
        rootname = sprintf('Learning-Rel_%s',fcns{f});                    
        sessions = getValidSessions(obj);
        Sno = length(sessions);
        bar_grps = zeros(f2,2*Sno,f1,2);
        IDs = zeros(f2,1);
        
        if graphPath
            fig = figure('visible','off');
        else
            fig = figure();
        end
        
        set(fig,'Name',fcns{f});
        for i=1:f1
            for j=1:f2
                IDs(j) = S(sessions(1)).bimanual.data_set{i,j,end}.info.RID;
                for s=1:Sno                         
                    oscL = S(sessions(s)).bimanual.data_set{i,j,end}.oscL;
                    oscR = S(sessions(s)).bimanual.data_set{i,j,end}.oscR;
                    oscLu = S(sessions(s)).uniLeft.data_set{i,end}.osc;
                    oscRu = S(sessions(s)).uniRight.data_set{j,end}.osc;
                    bar_grps(j,s,i,1) = get_mean(oscL.(oscNames{f}),oscLu.(oscNames{f}),mode);
                    bar_grps(j,s,i,2) = get_stderr(oscL.(oscNames{f}),oscLu.(oscNames{f}),mode);
                    bar_grps(j,Sno+s,i,1) = get_mean(oscR.(oscNames{f}),oscRu.(oscNames{f}),mode);
                    bar_grps(j,Sno+s,i,2) = get_stderr(oscR.(oscNames{f}),oscRu.(oscNames{f}),mode);
                end
            end
            %ylim(ylims{f});

            %hold('off');
            %set(0,'CurrentFigure',fig);
            subpl = subplot(1,f1,i);    
                    
            %Plot bars and errorbars
            hold on;           
            h = bar(IDs,bar_grps(:,:,i,1),'grouped');
            for j = 1:2*Sno
                x = getBarCentroids(get(get(h(j),'children'),'xdata'));
                errorbar(x,bar_grps(:,j,i,1),bar_grps(:,j,i,2),'k', 'linestyle', 'none', 'linewidth', 0.5);
            end
            hold off
            
            %Define legend traits
            red = [1,0,0];
            blue = [0,0,1];
            for s=1:Sno                    
                set(h(s),'FaceColor',red/s,'EdgeColor','k');
                set(h(Sno+s),'FaceColor',blue/s,'EdgeColor','k');
                legendCell{s} = sprintf('Left S%d',s);
                legendCell{Sno+s} = sprintf('Right S%d',s);
            end            
            %and show only in second graph
            if i==2
                hl = legend(h(1:Sno*2),legendCell{1:Sno*2},'Location','Best');  
                set(hl,'FontSize',8);
            end
            
            %More plot traits...
            title(sprintf('IDL=%1.1f Learning Relative %s',S(1).bimanual.data_set{i,1,1}.info.LID,oscNames{f}),'fontsize',14,'fontweight','b');
            xlabel('ID Right','fontweight','b');
            ylabel(labels{f},'fontweight','b','Rotation',90);
            ymin = min(min(bar_grps(:,:,i,1)));
            ymax = max(max(bar_grps(:,:,i,1)));
            ylim = [ymin-abs(ymin)/10,ymax+abs(ymax)/10 ];
            ylabel(labels{f});
            set(subpl,'XTick',sort(round(IDs*10)/10));
            set(subpl,'ylim',ylim);
        end
        %Decide whether to save or not
        if graphPath
            %filename = sprintf('%s_IDLeft-%d',rootname,round(S(1).bimanual.data_set{i,1,1}.info.LID));
            figname = joinpath(graphPath,rootname);
            if strcmp(ext,'fig')
                hgsave(fig,figname,'all');
            else
                saveas(fig,figname,ext); close(fig);
            end
        end                           
    end
end
