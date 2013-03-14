function plot_bars(bar_grps,ds,plot_type,do_legend,varname)
    hno=0;
    if length(size(bar_grps))==6
        [hno,f1no,f2no,f3no,ss,~]=size(bar_grps);
        hnames={'LeftHand','RightHand'};
    else
        [f1no,f2no,f3no,ss,~]=size(bar_grps);
    end
    
    %Each of the groups is a different coloured data-series    
    if do_legend==1
        legend_groups=zeros(1,f3no);
    end
    
    %Do the real plotting
    if hno
        %Iterate over both hands, one plot per hand
        for hand=1:hno
            set_figtype(plot_type,strcat(varname,hnames{hand}));
            for f1=1:f1no
                create_subplots(plot_type,f1no,f1,strcat(varname,hnames{hand}));
                hold on
                for f3=1:f3no            
                    for f2=1:f2no
                        gap=ss*(f3-1+f2no*(f2-1));
                        for s=1:ss
                            h=bar(s+gap,squeeze(bar_grps(hand,f1,f2,f3,s,1)),'FaceColor', ds.colors{f3}(s,:));
                            errorbar(s+gap,bar_grps(hand,f1,f2,f3,s,1),bar_grps(hand,f1,f2,f3,s,2),'k', 'linestyle','none', 'linewidth', 0.5);
                        end
                    end
                    %Store handle to generate legend
                    if do_legend==1, legend_groups(f3)=h; end
                end
                do_cosmetics(bar_grps);
            end
            if do_legend==1
                legend(legend_groups,get_legend(ds),'Location','Best');
            end
            hold off
        end
    else
        set_figtype(plot_type,varname);
        for f1=1:f1no
            create_subplots(plot_type,f1no,f1,varname);
            hold on
            for f3=1:f3no
                for f2=1:f2no
                    gap=ss*(f3-1+f2no*(f2-1));
                    for s=1:ss
                        h=bar(s+gap,squeeze(bar_grps(f1,f2,f3,s,1)),'FaceColor', ds.colors{f3}(s,:));
                        errorbar(s+gap,bar_grps(f1,f2,f3,s,1),bar_grps(f1,f2,f3,s,2),'k', 'linestyle','none', 'linewidth', 0.5);
                    end
                end
                %Store handle for later generate legend
                if do_legend==1, legend_groups(f3)=h; end
            end
            do_cosmetics(bar_grps);
        end
        if do_legend==1
            legend(legend_groups,get_legend(ds),'Location','Best');
        end
    end
    
    %end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function subplottight(n,m,i)
    [c,r] = ind2sub([m n], i);
    subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function leg = get_legend(ds)
    leg={};
    for i=1:length(ds.names)
        leg{i}=ds.names{i};
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
    else
        figure('Position',[1 scrsz(4)/2 scrsz(3)/1 scrsz(4)/3],'name',rootname);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function do_cosmetics(bar_grps)
    %Get data range
    ymin=min(bar_grps(:));
    ymax=max(bar_grps(:));
    %Plot guiding lines and remove useless ticks      
    hline([0.5,1],{'k--','k--'}) %,{'0.5s','1s'})
    hline(1,'k-')
    %set(gca,'YTick',[]);
    set(gca,'XTick',[]);
    set(gca,'ylim',[ymin-abs(ymin/10),ymax+abs(ymax/10)]);
    set(gca,'box','off');
    grid on;
    %s = struct(handle(gca));
    %s.YTick=[];
    %s.XTick=[];
    %s.xlim=[0,9];
    %s.box='off';     
end