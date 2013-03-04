function plot_scatter_unimanual(data,varname,vartype)    
    %Define or get some globals
    global plot_type;

    [hnds, ids, cnt, reps]=size(data);
    colors=get_colors();
    marker='o';
    hands={'Left','Right'};
    
    %Select the type of plot
    set_figtype(plot_type,varname,vartype);
    
    %Get limits for plot scaling, common to all plots
    [mindata, maxdata]=get_limits(data);

    %Iterate over both hands, one plot per hand
    for h=1:hnds
        %Create subplots depending on configuration
        create_subplots(h,plot_type,varname,vartype);
        hold on       
        %Set Y limits in advance        
        set_limits(mindata,maxdata);        
        %Do the actual scatter plots
        for id=1:ids
            if h==1 && id==3, continue; end
            xpos=get_xpos(id,h);
            for i=1:length(xpos)
                scatter([1,1,1]*xpos(i),data(h,id,i,:),'Marker',marker,...
                    'MarkerEdgeColor',colors{i},'MarkerFaceColor',colors{i});
            end
        end
        %Plot annotation for ID left level and ID right level
        plot_ids(ids,h,maxdata);       
        %Plot lines to separate groups
        plot_lines();        
        %Plot guiding lines and remove useless ticks or add pp-based ones
        do_cosmetics(ids,h,[hands{h},' ',varname])
        hold off
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Auxiliar functions of disparate purpose...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x=get_x(id,hand)
    if hand==1 && id==2
        id=3;
    end
    x=12*(id-1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xpos=get_xpos(id,h)
    xpos0=[1,2,3,4,5,7,8,9,10,11]+get_x(id,h);
    xpos=[];
    spos=[-.25,0,.25];
    for p=1:10
        xpos(3*(p-1)+1:3*p)=spos+xpos0(p);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mindata, maxdata]=get_limits(data)
    idx=abs(data-nanmean(data(:))) < 5*nanstd(data(:));
    mindata=min(data(idx));
    maxdata=max(data(idx));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_limits(mindata,maxdata)
    if isempty(mindata) || isempty(maxdata)
        return    
    elseif mindata>0
        ylim([0,maxdata+maxdata/10]);
    else
        ylim([mindata,maxdata+maxdata/10]);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_ids(ids,h,maxdata)
    if isempty(maxdata)
        return;
    end
    labels={'Difficult','Medium','Easy'};
    
    for id=1:ids
        if h==1 && id==2; continue; end
        text(5+get_x(id,h),maxdata+maxdata/10,labels{id},'FontWeight','bold');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function subplottight(n,m,i)
    [c,r] = ind2sub([m n], i);
    subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function colors=get_colors()
colors= {   [1 1 0],[1 1 .1],[1 1 .2],... %yellow
            [1 0 1],[1 .1 1],[1 .2 1],... %magenta
            [0 1 1],[.1 1 1],[.2 1 1],... %cyan
            [1 0 0],[1 .1 0],[1 .2 0],... %red
            [0 1 0],[0 1 .1],[0 1 .2],... %green
            [0 0 1],[.1 0 1],[.2 0 1],... %blue
            [0 0 0],[.1 .1 .1],[.2 .2 .2],... %black
            [0 .5 .5],[.1 .5 .5],[.2 .5 .5],... %teal
            [.5 .5 0],[.5 .5 .1],[.5 .5 .2],... %olive
            [.5 0 .5],[.5 .1 .5],[.5 .2 .5] ... %purple
        };
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_lines()
    vline(get_x(1,2)-0.5,'k')
    vline(get_x(2,2)-0.5,'k')
    vline(get_x(3,2)-0.5,'k')
    vline(get_x(4,2)-0.5,'k')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_subplots(hand,plot_type, varname,vartype)
    scrsz = get(0,'ScreenSize');
    %Create subplots depending on configuration
    if ~isempty(strfind(vartype,'ls')) || ~isempty(strfind(varname,'minPeakDistance'))
        if ~isempty(strfind(plot_type,'tight'))
            subplottight(1,1,hand);
        elseif ~isempty(strfind(plot_type,'subplot'))
            subplot(1,1,hand);
        elseif ~isempty(strfind(plot_type,'figure'))
            figure('Position',[1 scrsz(4)/2 scrsz(3)/1 scrsz(4)/3])
            set(gcf,'name',varname);
        end
    else
        if ~isempty(strfind(plot_type,'tight'))
            subplottight(2,1,hand);
        elseif ~isempty(strfind(plot_type,'subplot'))
            subplot(2,1,hand);
        elseif ~isempty(strfind(plot_type,'figure'))
            figure('Position',[1 scrsz(4)/2 scrsz(3)/1 scrsz(4)/3])
            if hand==1
                figname=[varname,'_Left'];
            else
                figname=[varname,'_Right'];
            end
            set(gcf,'name',figname);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_figtype(plot_type,rootname,vartype)
    scrsz = get(0,'ScreenSize');
    if ~isempty(strfind(plot_type,'subplot')) || ~isempty(strfind(plot_type,'tight')) && ...
        ~isempty(strfind(vartype,'ls'))
        figure('Position',[1 scrsz(4)/2 scrsz(3)/1 scrsz(4)/3])
        set(gcf,'name',rootname);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function do_cosmetics(ids,h,ylabelstr)
    [xticksp,xticksl]=get_xticks(ids,h);
    set(gca,'XTick',xticksp);
    set(gca,'XTickLabel',xticksl);
    set(gca,'box','off');
    set(gca,'XLim', [0 get_x(4,1)-0.45]);
    if length(ylabelstr)>8
        if ~isempty(strfind(ylabelstr,' '))
            [s1,s2]=strtok(ylabelstr,' ');
            ylabelstr={s1,s2};
        else
            l=floor(length(ylabelstr)/2);
            ylabelstr={ylabelstr(1:l),ylabelstr(l+1:end)};
        end
    end
    ylabh=ylabel(ylabelstr,'rot',0);
    set(ylabh,'Position',get(ylabh,'Position') - [1 0 0]);
    grid on;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xticksp,xticksl]=get_xticks(ids,h)
    xticksl=[];
    xticksp=[];
    xpos0=[1,2,3,4,5,7,8,9,10,11];
    xlabels={'2','3','6','8','9', '1','4','5','7','10'};
    if h==1, ids=2; end
    for id=1:ids        
        xticksp=[xticksp,xpos0+get_x(id,h)];
        xticksl=[xticksl,xlabels];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%