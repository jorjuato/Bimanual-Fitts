%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Auxiliar functions for controlling plotting of either uni or bi data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_scatter_bimanual(data,varname,vartype,rel)
    if nargin<4, rel=0; end
    
    global plot_type;
    
    %Define or get some globals
    if length(size(data))==5
        [hnds, idl, idr, cnt, reps]=size(data);
        hands={'Left','Right'};
    else
        [idl, idr, cnt, reps]=size(data);
        hnds=1; hands={''};
    end
    colors=get_colors();
    marker='o';
    
    %Select the type of plot
    if rel
        set_figtype(plot_type,['rel' varname],vartype);
    else
        set_figtype(plot_type,varname,vartype);
    end
    
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
        for r=1:idr
            for l=1:idl
                xpos=get_xpos(r,l);
                for i=1:length(xpos)
                    if hnds==1
                        d=data(l,r,i,:);
                    else
                        d=data(h,l,r,i,:);
                    end
                    scatter([1,1,1]*xpos(i),d,'Marker',marker,...
                    'MarkerEdgeColor',colors{i},'MarkerFaceColor',colors{i});
                end
            end
        end        
        %Plot annotation for ID left level and ID right level
        plot_idl(idr,idl,maxdata);
        plot_idr(idr,maxdata);        
        %Plot lines to separate groups
        plot_lines();        
        %Plot guiding lines and remove useless ticks or add pp-based ones
        if rel
            do_cosmetics(idr,idl,[hands{h},' ','relative ', varname]) 
        else
            do_cosmetics(idr,idl,[hands{h},' ',varname])
        end
        hold off
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Auxiliar functions of disparate purpose...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x=get_x(r,l)
    x=12*(2.1*(r-1)+l-1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xpos=get_xpos(r,l)
    xpos0=[1,2,3,4,5,7,8,9,10,11]+get_x(r,l);
    xpos=[];
    spos=[-.25,0,.25];
    for p=1:10
        xpos(3*(p-1)+1:3*p)=spos+xpos0(p);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mindata, maxdata]=get_limits(data)
    idx=abs(data(:)-nanmean(data(:))) < 5*nanstd(data(:));
    mindata=nanmin(data(idx));
    maxdata=nanmax(data(idx));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_limits(mindata,maxdata)
    if mindata>0
        ylim([0,maxdata+maxdata/10]);
    else
        ylim([mindata,maxdata+maxdata/10]);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_idl(idr,idl,maxdata)
    labels={'LD','LE'};
    for r=1:idr
        for l=1:idl
            text(6+get_x(r,l),maxdata,labels{l});
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_idr(idr,maxdata)
    labels={'Right Difficult','Right Medium','Right Easy'};
    %labels={'RD','RM','RE'};
    for r=1:idr
        text(9.5+get_x(r,1),maxdata+maxdata/10,labels{r},'FontWeight','bold');
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
    %First, IDR lines, thick
    vline(get_x(1,1)-0.5,'k')
    vline(get_x(2,1)-0.5,'k')
    vline(get_x(3,1)-0.5,'k')
    vline(get_x(4,1)-0.5,'k')
    %Now, IDL lines, lighter
    vline(get_x(1,2),'k--')
    vline(get_x(2,2),'k--')
    vline(get_x(3,2),'k--')
    %Participant lines, disabled
%     if mod(i,3)==1
%         vline(xpos(i)-0.12,'k');
%     elseif mod(i,3)==0
%         vline(xpos(i)+0.12,'k');
%     end
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
function do_cosmetics(idr,idl,ylabelstr)
    [xticksp,xticksl]=get_xticks(idr,idl);
    set(gca,'XTick',xticksp);
    set(gca,'XTickLabel',xticksl);
    set(gca,'box','off');
    set(gca,'XLim', [0 get_x(4,1)-0.45]);
    %Split label string in two lines if it is longer than 8 char
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
    set(ylabh,'Position',get(ylabh,'Position') - [3 0 0]);
    grid on;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xticksp,xticksl]=get_xticks(idr,idl)
    xticksl=[];
    xticksp=[];
    xpos0=[1,2,3,4,5,7,8,9,10,11];
    %xlabels={'P2','P3','P6','P8','P9', 'P1','P4','P5','P7','P10'};
    xlabels={'2','3','6','8','9', '1','4','5','7','10'};
    for r=1:idr
        for l=1:idl
            xticksp=[xticksp,xpos0+get_x(r,l)];
            xticksl=[xticksl,xlabels];
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%