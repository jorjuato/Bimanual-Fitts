% Plots kinematic properties of data from a bimanual Fitts experiment withvariation of 
% either the phase (in-phase/anti-phase) or the viscosity.
% All plotting functionare included in the file. It should work
% with DS structures generated with getMultiResults_fb because it doesn't  
% depend on any parameter of DS structure, only its dimensions.

function  plot_learning_lockingStrength(S,mode,graphPath,ext)    
    if nargin<4, ext='png';end
    if nargin<3, graphPath=joinpath(joinpath(getuserdir(),'KINARM'),'plots');end
    if nargin<2, mode=1; end
    
    S = obj.sessions;
    session=S(1);
    [fields, names, labels, ylims] = get_ls_plots();
    
    for f=1:length(fcns)        
        rootname = sprintf('Learning-%s',fcns{f});            
        [f1, f2, ~] = session.bimanual.size;  
        %FIX IT!!! 
        sessions = getValidSessions(S);
        Sno = length(sessions);
        %Fetch data
        for i=1:f1
            bar_grps = zeros(f2,Sno,2);
            IDs = zeros(f2,1);
            for j=1:f2
                IDs(j) = S(sessions(1)).bimanual{i,j,end}.info.IDR;
                for s=1:Sno
                    DS = S(sessions(s)).bimanual);                            
                    ls = DS{i,j,end}.ls;
                    bar_grps(j,s,1) = mean(filterOutliers(ls.(names{f})));
                    bar_grps(j,s,2) = ste(filterOutliers(ls.(names{f})));
                end
            end
             %ylim(ylims{f});
            if graphPath
                fig = figure('visible','off');
            else
                fig = figure();
            end
            set(fig,'Name',names{b});
            hold('off');
            set(0,'CurrentFigure',fig);
            %subpl = subplot(1,f1,i);
            subpl = gca;
            title(sprintf('ID Left=%1.1f / %s Learning',DS{i,1,1}.info.IDL,names{f}),'fontsize',14,'fontweight','b');
            xlabel('ID Right','fontweight','b');
            ylabel(labels{f},'fontweight','b','Rotation',90);
            hold on;
            h = bar(IDs,bar_grps(:,:,1),'grouped');
            red = [1,0,0];
            blue = [0,0,1];
            legendCell = cell(Sno);
            for s=1:Sno                    
                set(h(s),'FaceColor',red/s,'EdgeColor','k');
                legendCell{s} = sprintf('Left S%d',s);
            end
            for j = 1:Sno
                x = getBarCentroids(get(get(h(j),'children'),'xdata'));
                errorbar(x,bar_grps(:,j,1),bar_grps(:,j,2),'k', 'linestyle', 'none', 'linewidth', 0.5);
            end
            hl = legend(h(1:Sno),legendCell{1:Sno},'Location','Best');  
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

function [fields, names, labels, ylims] = get_ls_plots()

    fields= {...
            'Rf',...
            'Lf',...
            'rho',...
            'flsPC',...
            'flsAmp',...
            'phDiffMean',...
            'phDiffStd'};
            

    names = {...
             'Frequency'...
            ,'Frequency'...
            ,'Frequency Quotient'...
            ,'Frequency Locking Strength PC'...
            ,'Frequency Locking Strength Amplitude'...
            ,'Phase Difference Mean'...
            ,'Phase Difference Stdev'...
            };
    labels = {...
             'Frequency (Hz)'...
            ,'Frequency (Hz)'...
            ,'Frequency Quotient'...
            ,'FLS Pure Coordination'...
            ,'FLS Amplitude'...
            ,'Mean Phase Difference (rad)'...
            ,'Stdev Phase Difference (rad)'...
            };
    ylims = {...
              [0,5]...
             ,[0,5]...
             ,[0,5]...
             ,[]...
             ,[]...
             ,[-2*pi,2*pi]...
             ,[-2*pi,2*pi]};
end
    
