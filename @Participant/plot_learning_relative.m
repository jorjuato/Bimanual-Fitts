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
    blk = session.bimanual;
    [fcns, labels, ylims] = blk{1,1,1}.osc.get_plots();
    
    for f=1:length(fcns)        
        rootname = sprintf('Learning-Relative_mode-%d_%s',mode,fcns{f});            
        [f1, f2, ~] = blk.size; 
        sessions = getValidSessions(S);
        Sno = length(sessions);
        oscNames = properties(S(1).bimanual{1,1,end}.oscL);
        for i=1:f1
            bar_grps = zeros(f2,2*Sno,2);
            IDs = zeros(f2,1);
            for j=1:f2
                IDs(j) = S(sessions(1)).bimanual{i,j,end}.info.IDR;
                for s=1:Sno                         
                    oscL = S(sessions(s)).bimanual{i,j,end}.oscL;
                    oscR = S(sessions(s)).bimanual{i,j,end}.oscR;
                    oscLu = S(sessions(s)).uniLeft{i,end}.osc;
                    oscRu = S(sessions(s)).uniRight{j,end}.osc;
                    bar_grps(j,s,1) = get_mean(oscL.(oscNames{f}),oscLu.(oscNames{f}),mode);
                    bar_grps(j,s,2) = get_stderr(oscL.(oscNames{f}),oscLu.(oscNames{f}),mode);
                    bar_grps(j,Sno+s,1) = get_mean(oscR.(oscNames{f}),oscRu.(oscNames{f}),mode);
                    bar_grps(j,Sno+s,2) = get_stderr(oscR.(oscNames{f}),oscRu.(oscNames{f}),mode);
                end
            end
            %ylim(ylims{f});
            if graphPath
                fig = figure('visible','off');
            else
                fig = figure();
            end
            set(fig,'Name',fcns{f});
            hold('off');
            set(0,'CurrentFigure',fig);
            subpl = gca;
            title(sprintf('ID Left=%1.1f / Relative %s Learning',S(1).bimanual{i,1,1}.info.IDL,oscNames{f}),'fontsize',14,'fontweight','b');
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
            ylim = [ymin-abs(ymin)/10,ymax+abs(ymax)/10 ];
            ylabel(labels{f});
            set(subpl,'XTick',sort(round(IDs*10)/10));
            set(subpl,'ylim',ylim);
            hold off;
            if graphPath
                filename = sprintf('%s_IDLeft-%d',rootname,round(S(1).bimanual{i,1,1}.IDLeft));
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
