function plot_groups_var(ds,vname) 
    if ds.two_hands
        %One-handed variables: Iterate over both hands, one plot per hand
        for hand=1:length(ds.hnames)
            figname = [vname,' ',ds.hnames{hand}];
            data=squeeze(ds.data(hand,:,:,:,:,:));
            plot_(ds,data,figname);
        end
    else
        % Dual-handed variables       
        plot_(ds,ds.data,vname);
    end
end

function plot_(ds,data,figname)
    global do_legend
    global do_title
    
    ax={};
    legend_groups=zeros(1,ds.franges(3));
    
    create_figure(figname);
    for f1=1:ds.franges(1)
        create_subplots(ds.franges(1),f1,figname);
        ax{f1}=gca;
        if f1==1 && do_title, title(figname); end
        hold on
        for f2=1:ds.franges(2)
            for f3=1:ds.franges(3)
                gap=ds.get_gap(f2,f3);
                for s=1:ds.ss
                    %Plot bar and error bar
                    h=bar(s+gap,squeeze(data(f1,f2,f3,s,1)),'FaceColor', ds.colors{f3}(s,:), 'BarWidth', 1);
                    errorbar(s+gap,data(f1,f2,f3,s,1),data(f1,f2,f3,s,2),'k', 'linestyle','none', 'linewidth', 0.5);
                end
                %Store handle to generate legend
                if f2==1, legend_groups(f3)=h; end
            end
        end        
        plot_cosmetics(ds,f1);
    end
    if do_legend, legend(legend_groups,ds.legends,'Location','Best'); end
    hold off
    savefig(figname)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_cosmetics(ds,f1)
    global do_anotations
    global do_ylabel
    
    %remove useless ticks, box, and set y limits
    set(gca,'XTick',[]);
    set(gca,'ylim',ds.ylim);
    set(gca,'box','off');
    
    %only plot a line in y=1 if relative variables are being plotted
    if strfind(ds.vname,'rel}'), hline(1,'k-'); end
    
    %Plot y label if demanded
    if do_ylabel, ylabel(ds.vname); end
    
    %Plot anotations and grids if demanded by user
    if do_anotations
        %Plot grid and guiding lines  
        hline([0.5,1],{'k--','k--'}) %,{'0.5s','1s'})
        hline(1,'k-')
        grid on;
        %Plot anottation for 2nd factor
        for i=1:ds.franges(2)
            if f1==1 && ~isnan(ds.ymin) && ~isnan(ds.ymin) && ds.ymin+ds.ymax~=0
                text(ds.xlabels_pos(i,1),ds.xlabels_pos(i,2),ds.xlabels{i},...
                    'EdgeColor','black','BackgroundColor',[.7 .9 .7],'FontSize',12,'FontWeight','bold');        
            end
        end
        
        %Trick for a right handed 1st factor annotation
        text(ds.ylabels_pos(1),ds.ylabels_pos(2),ds.ylabels(f1),...
            'rot',0,'EdgeColor','black','BackgroundColor',[.7 .9 .7],'FontSize',12,'FontWeight','bold');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
function create_figure(rootname)
    global savepath
    global dpi
    global figsize
    
    if ~isempty(savepath)
        figure('name',rootname,'numbertitle','off','PaperUnits', 'inches', 'PaperPosition', figsize/dpi,'Visible','off');
    else
        figure('name',rootname,'numbertitle','off','PaperUnits', 'inches', 'PaperPosition', figsize/dpi);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_subplots(vno,v,rootname)
    global plot_type
    
    %Create subplots depending on configuration
    if ~isempty(strfind(plot_type,'tight')) 
        [c,r] = ind2sub([1 vno], v);
        subplot('Position', [(c-1)/1, 1-(r)/vno, 1/1, 1/vno])
    elseif ~isempty(strfind(plot_type,'subplot'))
        subplot(vno,1,v);
    elseif ~isempty(strfind(plot_type,'figure'))
        create_figure(rootname);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savefig(figname)
    global savepath
    global ext
    global dpi
    global figsize
    
    if strfind('\phi_{\sigma}',figname)
        figname='phasediffstd';
    end
    figname = joinpath(savepath,figname);
    if ~isempty(savepath) && exist(savepath,'dir')
        if strcmp(ext,'fig')
            hgsave(gcf,figname,'all');
        else
            set(gcf, 'PaperUnits', 'inches', 'PaperPosition', figsize/dpi);
            print(gcf,['-d',ext],sprintf('-r%d',dpi),figname);     
        end
           
    end
end
