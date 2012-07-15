% Plots kinematic properties of data from a bimanual Fitts experiment withvariation of 
% either the phase (in-phase/anti-phase) or the viscosity.
% All plotting functionare included in the file. It should work
% with DS structures generated with getMultiResults_fb because it doesn't  
% depend on any parameter of DS structure, only its dimensions.

function  posterplot_LearningHarmonicity(HR,HL,HRu,HLu)
    if nargin<4, error('Not enough input arguments'); end
    
    %Define or fetch some globals
    [grp, ss, idl, idr, reps]=size(HR);    
    plot_type='figure';
    hands=2;
    bar_widths=[1,0.7,0.5];
    do_legend=0;
    rootname='Harmonicity';
    data_series=struct( 'name' ,{'Coupled','Uncoupled','Unimanual'},...
                        'color',{[[0.6,0.2,0.2] ; [0.8,0.2,0.2];[1,0.2,0.2]],...
                                 [[0.2,0.2,1]   ; [0.2,0.2,0.8];[0.2,0.2,0.6]],...
                                 [[0.2,0.6,0.2] ; [0.2,0.8,0.2];[0.2,1,0.2]]},...
                        'order',{2,3,1});
    
    %Fetch all data for bars
    bar_grps = zeros(hands,grp+1,(idl+1)*idr,ss,2);
    for g=1:(grp+1)
        ord=data_series(g).order;
        cnt=0;
        for r=1:idr
            for l=1:idl     
                cnt=cnt+1;
                if g==3
                    %Unimanual plots added as 3rd group
                    for s=1:ss
                        bar_grps(1,ord,cnt,s,1)=mean(HLu(2,s,l,:));
                        bar_grps(1,ord,cnt,s,2)=std(HLu(2,s,l,:));
                        bar_grps(2,ord,cnt,s,1)=mean(HRu(2,s,r,:));
                        bar_grps(2,ord,cnt,s,2)=std(HRu(2,s,r,:));
                    end
                else                    
                    for s=1:ss
                        bar_grps(1,ord,cnt,s,1)=mean(HL(g,s,l,r,:));
                        bar_grps(1,ord,cnt,s,2)=std(HL(g,s,l,r,:));       
                        bar_grps(2,ord,cnt,s,1)=mean(HR(g,s,l,r,:));
                        bar_grps(2,ord,cnt,s,2)=std(HR(g,s,l,r,:));
                    end            
                end
            end
        end
    end    
    
    %Select the type of plot
    scrsz = get(0,'ScreenSize');
    if ~isempty(strfind(plot_type,'subplot')) || ~isempty(strfind(plot_type,'tight'))
        figure('Position',[1 scrsz(4)/2 scrsz(3)/1 scrsz(4)/3])
        set(gcf,'name',rootname);
    end
    
    %Iterate over both hands, one plot per hand
    for hand=1:hands
        if ~isempty(strfind(plot_type,'tight'))
            subplottight(2,1,hand);
        elseif ~isempty(strfind(plot_type,'subplot'))
            subplot(2,1,hand);
        elseif ~isempty(strfind(plot_type,'figure'))
            figure('Position',[1 scrsz(4)/2 scrsz(3)/1 scrsz(4)/3])
            if hand==1
                figname=[rootname,'_Left'];
            else
                figname=[rootname,'_Right'];
            end
            set(gcf,'name',figname);
        end
        
        %Each of the groups is a different coloured data-series
        legend_groups=zeros(1,grp+1);
        for g=1:grp+1
            idx=get_idx(data_series,g);
            %Do the actual bar-errors plotting
            if g==1
                %First temporal plot, to get X positions of bar series
                h = bar(squeeze(bar_grps(hand,g,:,:,1)),'BarWidth',bar_widths(g));
                xtmp = fliplr(getBarCentroids(get(get(h(2),'children'),'xdata')));
                for i=1:length(xtmp)
                    n=floor((i-1)/2);
                    xtmp(i)=xtmp(i)+1*n;
                end
                %Replot with adjusted X positions with more space between
                %IDR factor levels 
                h = bar(xtmp,squeeze(bar_grps(hand,g,:,:,1)),'grouped');                
            else
                hold on
                h = bar(fliplr(x{2}),squeeze(bar_grps(hand,g,:,:,1)),'grouped');
            end
            
            %Set bars appereance: color and width            
            set(h,'BarWidth',bar_widths(g)); 
            for i=1:length(h)
                set(h(i),'FaceColor',data_series(idx).color(i,:));
                x{i} = getBarCentroids(get(get(h(i),'children'),'xdata'));
                %errorbar(x,bar_grps(:,i,1),bar_grps(:,i,2),'k', 'linestyle','none', 'linewidth', 0.5);
            end
            
            %Plot guiding lines and remove useless ticks
            hline([0.5,1],{'k--','k--'})%,{'0.5s','1s'})
            hline(1,'k-')
            set(gca,'YTick',[]);
            set(gca,'XTick',[]);
            set(gca,'xlim',[0,9]);
            set(gca,'box','off');
            %if hand==2
            %    set(gca, 'YDir', 'reverse');
            %end
            %Do legend?
            if do_legend==1,legend_groups(g)=h(2); end
        end
        if do_legend==1
            legend(legend_groups,get_legend(data_series),'Location','Best');
        end
        hold off
    end
end


function subplottight(n,m,i)
    [c,r] = ind2sub([m n], i);
    subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n])
end

function leg = get_legend(data_series)
    leg={};
    for i=1:3
        idx=get_idx(data_series,i);
        leg{i}=data_series(idx).name;
    end
end

function idx= get_idx(data_series,o)
    for i=1:3
        if data_series(i).order==o
            idx=i;
            return
        end
    end
end
