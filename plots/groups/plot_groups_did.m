function plot_groups_did(biData,biNames,factors)
    if nargin<2
        error('Not enough input arguments');
    elseif nargin==2
        factors={'grp','did'};
    end
    
    %Define or fetch some globals
    global do_legend
    global plot_type
    
    do_legend=1;
    plot_type='subplot'; %'tight' 'figure' 'subplot'
    vars={'rho','flsPC','phDiffStd','MI','minPeakDelay','minPeakDelayNorm','D3D','D4D'};
    titles={'rho','flsPC','phDiffStd','MI','minPeakDelay','minPeakDelayNorm','D3D','D4D'};
    
    %Rearrange data matrices by group if needed
    if size(biData,3)==10
        biData=group_participant_data(biData);
    end
    
    %PLOT IT ALL
    for v=1:length(vars)    
        %Get index for variable in data arrays
        v1=strcmp(vars{v}, biNames);
        
        %Prepare matrices
        bi=squeeze(biData(v1,1,:,:,:,:));

        %Absolute plots
        plot_bars(DataSeriesDID(bi,factors),titles{v});
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_bars(ds,vname)
    global do_legend
    ax={};
    
    %Each of the groups in 3rd factor is a different coloured data-series    
    if do_legend==1
        legend_groups=zeros(1,ds.franges(2));
    end
    
    set_figtype(vname);
    
    for f1=1:ds.franges(1)
        %create_subplots(ds.franges(1),f1,vname);
        %ax{f1}=gca;
        hold on
        for f2=1:ds.franges(2)
            gap=ds.get_gap(f1,f2);
            for s=1:ds.ss
                h=bar(s+gap,squeeze(ds.data(f1,f2,s,1)),'FaceColor', ds.colors{f2}(s,:), 'BarWidth', 1);
                errorbar(s+gap,ds.data(f1,f2,s,1),ds.data(f1,f2,s,2),'k', 'linestyle','none', 'linewidth', 0.5);
            end
            %Store handle for later generate legend
            if do_legend==1 && f1==1
                legend_groups(f2)=h;
            end
        end
    end
    
    do_cosmetics(ds);
    
    if do_legend
        legend(legend_groups,get_legend(ds),'Location','Best');
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
    scrsz = get(0,'ScreenSize');
    if ~isempty(strfind(plot_type,'subplot')) || ~isempty(strfind(plot_type,'tight'))
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
function do_cosmetics(ds)
    %Plot guiding lines and remove useless ticks      
    hline([0.5,1],{'k--','k--'}) %,{'0.5s','1s'})
    hline(1,'k-')
    set(gca,'XTick',[]);
    set(gca,'ylim',[ds.ymin-abs(ds.ymin/10),ds.ymax+abs(ds.ymax/10)]);
    set(gca,'box','off');
    grid on;
    for i=1:ds.franges(1)
        xlabh=text(ds.xlabels_pos(i,1),ds.ymax,ds.xlabels{i},'EdgeColor','black','BackgroundColor',[.7 .9 .7],'FontSize',12,'FontWeight','bold');
        s = struct(handle(xlabh));
        s.Position=s.Position - [0 1 0 ];
    end
end
                    