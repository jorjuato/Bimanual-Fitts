% Plots kinematic properties of data from a bimanual Fitts experiment withvariation of 
% either the phase (in-phase/anti-phase) or the viscosity.
% All plotting functionare included in the file. It should work
% with DS structures generated with getMultiResults_fb because it doesn't  
% depend on any parameter of DS structure, only its dimensions.

function  plot_learning_lockingStrength(obj,graphPath)
    if nargin<2, graphPath=''; end    
    if ~exist(graphPath,'dir') & obj.conf.interactive==0
        mkdir(graphPath);
    end
    
    S = obj.sessions;
    session=S(1);
    [f1, f2, ~] = size(session.bimanual.data_set);  
    [fields, names, labels, ylims] = get_ls_plots();
    
    for f=1:length(fields)        
        rootname = sprintf('Learning_%s',fields{f});       
        sessions = getValidSessions(obj);
        Sno = length(sessions);
        if obj.conf.interactive==0
            fig = figure('visible','off');
        else
            fig = figure();
        end
        set(fig,'Name',fields{f});
        
        %Fetch data
        for i=1:f1
            bar_grps = zeros(f2,Sno,f1,2);
            IDs = zeros(f2,1);
            for j=1:f2
                IDs(j) = S(sessions(1)).bimanual.data_set{i,j,end}.info.RID;
                for s=1:Sno
                    DS = S(sessions(s)).bimanual.data_set;                            
                    %ls = DS{i,j,end}.ls;
                    data=get_data_field(fields{f},DS,i,j);
                    bar_grps(j,s,i,1) = mean(data);
                    bar_grps(j,s,i,2) = ste(data);
                end
            end

            %Plot bars and error bars
            subpl = subplot(1,f1,i);
            hold on;
            h = bar(IDs,bar_grps(:,:,i,1),'grouped');
            for s=1:Sno
                x = getBarCentroids(get(get(h(s),'children'),'xdata'));
                errorbar(x,bar_grps(:,s,i,1),bar_grps(:,s,i,2),'k', 'linestyle', 'none', 'linewidth', 0.5);
            end
            hold off;
            
            %Plot legend
            red = [1,0,0];
            for s=1:Sno                    
                set(h(s),'FaceColor',red/s,'EdgeColor','k');
                legendCell{s} = sprintf('S%d',s);
            end
            if i==2
                hl = legend(h(1:Sno),legendCell{1:Sno},'Location','Best');  
                set(hl,'FontSize',8);
            end
            
            %More plot aesthetics
            ymin = min(min(bar_grps(:,:,i,1)));
            ymax = max(max(bar_grps(:,:,i,1)));
            ylim = [ymin-ymin/10,ymax+ymax/10 ];
            if strcmp(names{f},'Acceleration Time') || strcmp(names{f},'Deceleration Time')
                xmin = min(min(get(get(h(1),'children'),'xdata')));
                xmax = max(max(get(get(h(end),'children'),'xdata')));
                line([xmin,xmax],[0.5,0.5],'Color','k','LineWidth',2);
            end
            set(subpl,'XTick',sort(round(IDs*10)/10));
            %set(subpl,'ylim',ylim{f});
            title(sprintf('IDL=%1.1f / %s Learning',DS{i,1,1}.info.LID,fields{f}),'fontsize',14,'fontweight','b');
            xlabel('ID Right','fontweight','b');
            ylabel(labels{f},'fontweight','b','Rotation',90);            
        end 
        if exist(graphPath,'dir') & obj.conf.interactive==0
            figname = joinpath(graphPath,rootname);
            if strcmp(ext,'fig')
                hgsave(fig,figname,'all');
            else
                saveas(fig,figname,obj.conf.ext); close(fig);
            end
        end              
    end                    
end

function data =get_data_field(field,ds,i,j)
    rep=size(ds,3)-1;
    data=zeros(rep,1);  
    for r=1:rep
        data(r)=ds{i,j,r}.ls.(field);
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
    
