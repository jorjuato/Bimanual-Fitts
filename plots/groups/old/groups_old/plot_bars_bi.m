function plot_bars_bi(bar_grps,data_series,plot_type,varname)
    global do_legend
    [hno,grp,cnt,ss,~]=size(bar_grps);
    %Each of the groups is a different coloured data-series
    set_figtype(plot_type,varname);

    if do_legend==1
        legend_groups=zeros(1,grp);
    end
    
    %Iterate over both hands, one plot per hand
    for hand=1:hno
        create_subplots(plot_type,hno,hand,varname);
        for g=1:grp
            %Do the actual bar-errors plotting
            idx=get_idx(data_series,g);
            if g==1
                %First temporal plot, to get X positions of bar series
                h = bar(squeeze(bar_grps(hand,g,:,:,1)),'BarWidth',data_series(g).width);
                %s1 = struct(handle(h(2)));
                %s2 = struct(handle(s1.Children));
                %xtmp = fliplr(getBarCentroids(s2.XData));
                xtmp = fliplr(getBarCentroids(get(get(h(2),'children'),'xdata')));               
                for i=1:length(xtmp)
                    n=floor((i-1)/2);
                    xtmp(i)=xtmp(i)+1*n;
                end
                %Replot with adjusted X positions with more space between
                %IDR factor levels
                h = bar(xtmp,squeeze(bar_grps(hand,g,:,:,1)));
            else
                hold on
                h = bar(fliplr(x{2}),squeeze(bar_grps(hand,g,:,:,1)));
            end

            %Set bars appereance: color and width
            set(h,'BarWidth',data_series(g).width);
            x=cell(length(h),1);
            for i=1:length(h)
                %s1 = struct(handle(h(i)));
                %s2 = struct(handle(s1.Children));
                %s1.FaceColor=data_series(idx).color(i,:);
                %x{i}=getBarCentroids(s2.XData);
                set(h(i),'FaceColor',data_series(idx).color(i,:));
                x{i} = getBarCentroids(get(get(h(i),'children'),'xdata'));
                %errorbar(x{i},bar_grps(hand,g,:,i,1),bar_grps(hand,g,:,i,2),'k', 'linestyle','none', 'linewidth', 0.5);
            end
            %Store handle for later generate legend
            if do_legend==1,legend_groups(g)=h(2);end
            
%             for i=1:length(h)
%                 h(i)=errorbar(x{i},bar_grps(hand,g,:,i,1),bar_grps(hand,g,:,i,2),'k', 'linestyle','none', 'linewidth', 0.5);
%             end
            
            do_cosmetics();
            
        end
        if do_legend==1
            legend(legend_groups,get_legend(data_series),'Location','Best');
        end
        hold off
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function subplottight(n,m,i)
    [c,r] = ind2sub([m n], i);
    subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function leg = get_legend(data_series)
    leg={};
    for i=1:length(data_series)
        idx=get_idx(data_series,i);
        leg{i}=data_series(idx).name;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function idx= get_idx(data_series,o)
    for i=1:length(data_series)
        if data_series(i).order==o
            idx=i;
            return
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_subplots(plot_type,vno,v,name)
    scrsz = get(0,'ScreenSize');
    %Create subplots depending on configuration
    if ~isempty(strfind(plot_type,'tight')) 
        subplottight(vno,1,v);
    elseif ~isempty(strfind(plot_type,'subplot'))
        subplot(vno,1,v);
    elseif ~isempty(strfind(plot_type,'figure'))
        figure('Position',[1 scrsz(4)/2 scrsz(3)/1 scrsz(4)/3])
        set(gcf,'name',name);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
function set_figtype(plot_type,rootname)
    scrsz = get(0,'ScreenSize');
    if ~isempty(strfind(plot_type,'subplot')) || ~isempty(strfind(plot_type,'tight'))
        figure('Position',[1 scrsz(4)/2 scrsz(3)/1 scrsz(4)/3])
        set(gcf,'name',rootname);
    %else
    %    figure('Position',[1 scrsz(4)/2 scrsz(3)/1 scrsz(4)/3],'name',rootname);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function do_cosmetics()
    %Plot guiding lines and remove useless ticks      
    hline([0.5,1],{'k--','k--'}) %,{'0.5s','1s'})
    hline(1,'k-')
    %set(gca,'YTick',[]);
    set(gca,'XTick',[]);
    set(gca,'xlim',[0,9]);
    set(gca,'box','off');
    grid on;
    %s = struct(handle(gca));
    %s.YTick=[];
    %s.XTick=[];
    %s.xlim=[0,9];
    %s.box='off';     
end