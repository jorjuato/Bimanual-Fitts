function plot_groups(biData,unData,biNames,unNames,factors,savepath_)
    if nargin<6, savepath_='';end
    if nargin<4, error('Not enough input arguments'); end
    if nargin==4, factors={'idr','idl','grp'}; end
    
    %Define or fetch some globals
    global do_legend
    global plot_type
    global savepath
    savepath=savepath_;
    do_legend=1;
    plot_type='subplot'; %'tight' 'figure' 'subplot'    
    
    vars={'MT','accTime','decTime','accQ','IPerfEf',...
          'maxangle','d3D','d4D','Circularity',...
          'vfCircularity','vfTrajCircularity','Harmonicity',...
          'rho','flsPC','phDiffStd','MI','minPeakDelay','minPeakDelayNorm'};
      
    titles={'MovementTime','Acceleration Time','Deceleration Time','Acc Quotient','IPerfEf',...
            'maxangle','d3D','d4D','Circularity',...
            'vfCircularity','vfTrajCircularity','Harmonicity',...
            'rho','flsPC','phDiffStd','MI','minPeakDelay','minPeakDelayNorm'};
        
    %idx=[14,15];
    %vars=vars(idx);
    %titles=titles(idx);
    %Rearrange data matrices by group if needed
    if size(biData,3)==10
        biData=group_participant_data(biData);
        unData=group_participant_data(unData);
    end
    
    if ~isempty(savepath) && ~exist(savepath,'dir') 
        mkdir(savepath);
    end
    
    %PLOT IT ALL
    for v=1:length(vars)    
        %Get index for variable in data arrays
        v1=strcmp(vars{v}, biNames);
        v2=strcmp(vars{v}, unNames);
        
        %Prepare matrices
        if any(v2)
            bi=squeeze(biData(v1,:,:,:,:,:,:));
            un=squeeze(unData(v2,:,:,:,:,:)); 
        else
            bi=squeeze(biData(v1,1,:,:,:,:,:));
        end

        %Absolute plots
        plot_bars(DataSeries(bi,factors),titles{v});

        %Relative plots
        if any(v2)
            plot_bars(DataSeries(bi,un,factors),['Relative',titles{v}]);
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_bars(ds,vname)
    global do_legend
    global savepath
    ax={};
    ext='png';
    %Each of the groups in 3rd factor is a different coloured data-series    
    if do_legend==1
        legend_groups=zeros(1,ds.franges(3));
    end
    
    if ds.two_hands
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %One-handed variables
        %Iterate over both hands, one plot per hand
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for hand=1:length(ds.hnames)
            set_figtype(strcat(vname,ds.hnames{hand}));
            for f1=1:ds.franges(1)
                create_subplots(ds.franges(1),f1,strcat(vname,ds.hnames{hand}));
                ax{f1}=gca;
                hold on
                for f2=1:ds.franges(2)            
                    for f3=1:ds.franges(3)
                        gap=ds.get_gap(f2,f3);
                        for s=1:ds.ss
                            %Plot bar and error bar
                            h=bar(s+gap,squeeze(ds.data(hand,f1,f2,f3,s,1)),'FaceColor', ds.colors{f3}(s,:), 'BarWidth', 1);
                            errorbar(s+gap,ds.data(hand,f1,f2,f3,s,1),ds.data(hand,f1,f2,f3,s,2),'k', 'linestyle','none', 'linewidth', 0.5);
                        end
                        %Store handle to generate legend
                        if do_legend==1 && f2==1
                            legend_groups(f3)=h; 
                        end
                    end
                end
                do_cosmetics(ds,f1);
            end
            if do_legend==1
                legend(legend_groups,get_legend(ds),'Location','Best'); 
            end
            hold off
            if ~isempty(savepath) && exist(savepath,'dir')
                title([vname,ds.hnames{hand}]);
                figname = joinpath(savepath,[vname,ds.hnames{hand}]);
                if strcmp(ext,'fig')
                    hgsave(gcf,figname,'all');
                else
                    saveas(gcf,figname,ext); close(gcf);
                end
            end   
        end
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Dual-handed variables
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        set_figtype(vname);
        for f1=1:ds.franges(1)
            create_subplots(ds.franges(1),f1,vname);
            ax{f1}=gca;
            hold on
            for f2=1:ds.franges(2)
                for f3=1:ds.franges(3)
                    gap=ds.get_gap(f2,f3);
                    for s=1:ds.ss
                        h=bar(s+gap,squeeze(ds.data(f1,f2,f3,s,1)),'FaceColor', ds.colors{f3}(s,:), 'BarWidth', 1);
                        errorbar(s+gap,ds.data(f1,f2,f3,s,1),ds.data(f1,f2,f3,s,2),'k', 'linestyle','none', 'linewidth', 0.5);
                    end
                    %Store handle for later generate legend
                    if do_legend==1 && f2==1
                        legend_groups(f3)=h;
                    end
                end
            end
            do_cosmetics(ds,f1);
        end
        if do_legend
            legend(legend_groups,get_legend(ds),'Location','Best');
        end
        if ~isempty(savepath) && exist(savepath,'dir')
            title(vname)
            figname = joinpath(savepath,vname);
            if strcmp(ext,'fig')
                hgsave(gcf,figname,'all');
            else
                saveas(gcf,figname,ext); close(gcf);
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_subplots(vno,v,name)
    global plot_type
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
function set_figtype(rootname)
    global plot_type
    global savepath
    scrsz = get(0,'ScreenSize');
    if ~isempty(savepath)
        figure('name',rootname,'visible','off')
    elseif ~isempty(strfind(plot_type,'subplot')) || ~isempty(strfind(plot_type,'tight'))
        figure('Position',[1 scrsz(4)/2 scrsz(3)/1 scrsz(4)/3])
        set(gcf,'name',rootname);
    else
        figure('Position',[1 scrsz(4)/2 scrsz(3)/1 scrsz(4)/3],'name',rootname);
    end
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
function do_cosmetics(ds,f1)
    %Plot guiding lines and remove useless ticks      
    hline([0.5,1],{'k--','k--'}) %,{'0.5s','1s'})
    hline(1,'k-')
    set(gca,'XTick',[]);
    set(gca,'ylim',[ds.ymin-abs(ds.ymin/10),ds.ymax+abs(ds.ymax/10)]);
    set(gca,'box','off');
    grid on;
    ylabh=ylabel(ds.ylabels(f1),'rot',0,'EdgeColor','black','BackgroundColor',[.7 .9 .7],'FontSize',12,'FontWeight','bold');
    s = struct(handle(ylabh));
    s.Position=s.Position - [1 0 0 ];
    for i=1:ds.franges(2)
        xlabh=text(ds.xlabels_pos(i,1),ds.ymax,ds.xlabels{i},'EdgeColor','black','BackgroundColor',[.7 .9 .7],'FontSize',12,'FontWeight','bold');
        s = struct(handle(xlabh));
        s.Position=s.Position - [0 1 0 ];
    end
end
                    
