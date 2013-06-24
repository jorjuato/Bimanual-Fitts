function plot_angphsp(obj,graphPath)
    if nargin<2, graphPath=obj.conf.plot_participant_path; end    
    
    if ~exist(graphPath,'dir') && obj.conf.interactive==0
        mkdir(graphPath);
    end 
    
    [IDL, IDR, ~] = size(obj.sessions(1).bimanual.data_set);
    for i=1:IDL
        for j=1:IDR
            fprintf('Plotting hist figure L=%d:R=%d',i,j)
            plot_phsp_hist(obj,i,j,graphPath);
            %fprintf('Plotting ts figure L=%d:R=%d',i,j)
            %plot_phsp_ts(obj,i,j,graphPath);
        end
    end
end

function plot_phsp_hist(obj,l,r,graphPath)
    lnames={'Easy','Diff'};
    rnames={'Easy','Med','Diff'};

    %Create figure and name it
    if obj.conf.interactive==0
        fig = figure('visible','off');
    else
        fig = figure();
    end

    ylimits=obj.get_ylimits(l,r,'omega');
    
    %Iterate over valid sessions
    for n=1:3
        fprintf('\t Session: %d',n)
        s=3*(n-1)+1;
        DSb = obj.sessions(s).bimanual.data_set;
        DSl = obj.sessions(s).uniLeft.data_set;
        DSr = obj.sessions(s).uniRight.data_set;
        
        %Plot Unimanual Left
        ax=subplot(3,4,(n-1)*4+1); hold on;
        scatter(DSl{l,1}.ts.ph_hist,DSl{l,1}.ts.xnorm_hist*pi+pi,'k.');
        scatter(DSl{l,1}.ts.ph_hist,DSl{l,1}.ts.omega_hist,'r.');
        scatter(DSl{l,2}.ts.ph_hist,DSl{l,2}.ts.omega_hist,'g.');
        scatter(DSl{l,3}.ts.ph_hist,DSl{l,3}.ts.omega_hist,'b.');
        ylabel(sprintf('S%d',n),'fontsize',9,'fontweight','b');
        set(get(gca,'YLabel'),'Rotation',0);
        ylim(ax,ylimits(1,:));
        xlim(ax,[-pi,pi]);
        if n==1, title('Unimanual Left','fontsize',9,'fontweight','b'); end
        
        %Plot Bimanual Left
        ax=subplot(3,4,(n-1)*4+2); hold on;
        scatter(DSb{l,r,1}.ts.Lph_hist,DSb{l,r,1}.ts.Lxnorm_hist*pi+pi,'k.');
        scatter(DSb{l,r,1}.ts.Lph_hist,DSb{l,r,1}.ts.Lomega_hist,'r.');
        scatter(DSb{l,r,2}.ts.Lph_hist,DSb{l,r,2}.ts.Lomega_hist,'g.');
        scatter(DSb{l,r,3}.ts.Lph_hist,DSb{l,r,3}.ts.Lomega_hist,'b.');
        ylim(ax,ylimits(2,:));
        xlim(ax,[-pi,pi]);        
        if n==1, title('Bimanual Left','fontsize',9,'fontweight','b'); end
        
        %Plot Bimanual Right
        ax=subplot(3,4,(n-1)*4+3); hold on;
        scatter(DSb{l,r,1}.ts.Rph_hist,DSb{l,r,1}.ts.Rxnorm_hist*pi+pi,'k.');
        scatter(DSb{l,r,1}.ts.Rph_hist,DSb{l,r,1}.ts.Romega_hist,'r.');
        scatter(DSb{l,r,2}.ts.Rph_hist,DSb{l,r,2}.ts.Romega_hist,'g.');
        scatter(DSb{l,r,3}.ts.Rph_hist,DSb{l,r,3}.ts.Romega_hist,'b.');
        ylim(ax,ylimits(3,:));
        xlim(ax,[-pi,pi]);        
        if n==1, title('Bimanual Right','fontsize',9,'fontweight','b'); end
        
        %Plot Unimanual Right
        ax=subplot(3,4,(n-1)*4+4);hold on;
        scatter(DSr{r,1}.ts.ph_hist,DSr{r,1}.ts.xnorm_hist*pi+pi,'k.');
        scatter(DSr{r,1}.ts.ph_hist,DSr{r,1}.ts.omega_hist,'r.');
        scatter(DSr{r,2}.ts.ph_hist,DSr{r,2}.ts.omega_hist,'g.');
        scatter(DSr{r,3}.ts.ph_hist,DSr{r,3}.ts.omega_hist,'b.');
        ylim(ax,ylimits(4,:));
        xlim(ax,[-pi,pi]);        
        if n==1, title('Unimanual Right','fontsize',9,'fontweight','b'); end
        
    end
   
    name=sprintf('Learning-PhaseSpace-hist_L-%s_R-%s',lnames{l},rnames{r});
    if obj.conf.interactive==1
        suplabel(name,'t',[.1 .1 .84 .84]);
    end
    if exist(graphPath,'dir') & obj.conf.interactive==0
        figname = joinpath(graphPath,name);
        saveas(fig,figname,obj.conf.ext);
        close(fig);
    end
    disp('...done with figure, quitting')
end


function plot_phsp_ts(obj,l,r,graphPath)
    lnames={'Easy','Diff'};
    rnames={'Easy','Med','Diff'};

    %Create figure and name it
    if obj.conf.interactive==0
        fig = figure('visible','off');
    else
        fig = figure();
    end

    ylimits=obj.get_ylimits(l,r,'omega');
    
    %Iterate over valid sessions
    for n=1:3
        fprintf('\t Session: %d',n)
        s=3*(n-1)+1;
        DSb = obj.sessions(s).bimanual.data_set;
        DSl = obj.sessions(s).uniLeft.data_set;
        DSr = obj.sessions(s).uniRight.data_set;
        
        %Plot Unimanual Left
        ax=subplot(3,4,(n-1)*4+1); hold on;
        scatter(abs(mod(DSl{l,1}.ts.ph,2*pi)),DSl{l,1}.ts.omega,'r.');
        scatter(abs(mod(DSl{l,2}.ts.ph,2*pi)),DSl{l,2}.ts.omega,'g.');
        scatter(abs(mod(DSl{l,3}.ts.ph,2*pi)),DSl{l,3}.ts.omega,'b.');
        ylabel(sprintf('S%d',n),'fontsize',9,'fontweight','b');
        set(get(gca,'YLabel'),'Rotation',0);
        ylim(ax,ylimits(1,:));
        xlim(ax,[0,2*pi]);
        if n==1, title('Unimanual Left','fontsize',9,'fontweight','b'); end
        
        %Plot Bimanual Left
        ax=subplot(3,4,(n-1)*4+2); hold on;
        scatter(abs(mod(DSb{l,r,1}.ts.Lph,2*pi)),DSb{l,r,1}.ts.Lomega,'r.');
        scatter(abs(mod(DSb{l,r,2}.ts.Lph,2*pi)),DSb{l,r,2}.ts.Lomega,'g.');
        scatter(abs(mod(DSb{l,r,3}.ts.Lph,2*pi)),DSb{l,r,3}.ts.Lomega,'b.');
        ylim(ax,ylimits(2,:));
        xlim(ax,[0,2*pi]);
        if n==1, title('Bimanual Left','fontsize',9,'fontweight','b'); end
        
        %Plot Bimanual Right
        ax=subplot(3,4,(n-1)*4+3); hold on;
        scatter(abs(mod(DSb{l,r,1}.ts.Rph,2*pi)),DSb{l,r,1}.ts.Romega,'r.');
        scatter(abs(mod(DSb{l,r,2}.ts.Rph,2*pi)),DSb{l,r,2}.ts.Romega,'g.');
        scatter(abs(mod(DSb{l,r,3}.ts.Rph,2*pi)),DSb{l,r,3}.ts.Romega,'b.');
        ylim(ax,ylimits(3,:));
        xlim(ax,[0,2*pi]);
        if n==1, title('Bimanual Right','fontsize',9,'fontweight','b'); end
        
        %Plot Unimanual Right
        ax=subplot(3,4,(n-1)*4+4);hold on;
        scatter(abs(mod(DSr{r,1}.ts.ph,2*pi)),DSr{r,1}.ts.omega,'r.');
        scatter(abs(mod(DSr{r,2}.ts.ph,2*pi)),DSr{r,2}.ts.omega,'g.');
        scatter(abs(mod(DSr{r,3}.ts.ph,2*pi)),DSr{r,3}.ts.omega,'b.');
        ylim(ax,ylimits(4,:));
        xlim(ax,[0,2*pi]);
        if n==1, title('Unimanual Right','fontsize',9,'fontweight','b'); end
        
    end
    %name=sprintf('LearningVectorAnglesIDL%1dIDR%1d',round(DSl{i,1}.info.ID),round(DSr{j,1}.info.ID));
    name=sprintf('Learning-PhaseSpace-ts_L-%s_R-%s',lnames{l},rnames{r});
    if obj.conf.interactive==1
        suplabel(name,'t',[.1 .1 .84 .84]);
    end
    if exist(graphPath,'dir') & obj.conf.interactive==0
        figname = joinpath(graphPath,name);
        disp('about to save figure...')
        saveas(fig,figname,obj.conf.ext);
        close(fig);
    end
    disp('done with figure, quitting')
end
