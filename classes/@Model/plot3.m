function plot3(mdl,run_name,no)
    if nargin<2, run_name=''; end
    if nargin<3, no=0; end

    if mdl.stype < 2
        error('Function not available for single dimensional models')
    end    
    
    %Parse options
    [trs, run_range, run_name, parval] = mdl.parse_options(run_name,no);   
    rr=length(run_range);

    %Plot trajectories on the torus
    figure; ax3d=subplot(1,1,1); hold 'on';
    for r=1:rr
        switch run_name
            case ''
                PH1=trs{r}.phmod(:,1);
                PH2=trs{r}.phmod(:,2);
                [Xc,Yc,Zc] = torus2cart(PH1,PH2,5.05,10.05); %##########################CHUNGOOOO
                scatter3(ax3d,Xc,Yc,Zc,'k.');                
            case 'IC'
                PH1=trs{r}.phmod(:,1);
                PH2=trs{r}.phmod(:,2);
                [Xc,Yc,Zc] = torus2cart(PH1,PH2,5.05,10.05); %##########################CHUNGOOOO
                scatter3(ax3d,Xc,Yc,Zc,'.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);                     
            otherwise
                ax3d=subplot(1,rr,r); hold on;
                PH1=trs{r}.phmod(:,1);
                PH2=trs{r}.phmod(:,2);
                [Xc,Yc,Zc] = torus2cart(PH1,PH2,5.05,10.05); %##########################CHUNGOOOO
                scatter3(ax3d,Xc,Yc,Zc,'.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
                title(sprintf('%s=%2.3f',run_name,run_range(r)))
                p0=mdl.params;
                mdl.load_params(parval);
                mdl.subs_param(run_name,run_range(r));
                mdl.plot_torus(ax3d);
                mdl.plot_torus_axes(ax3d);
                mdl.plot_torus_vf(ax3d);
                mdl.plot_torus_nc(ax3d);
                mdl.load_params(p0);
        end
    end
    
    if any(strcmp(run_name,{'','IC'}))     
        if strcmp(run_name,'IC')
            p0=mdl.params;
            mdl.load_params(parval);
        end        
        mdl.plot_legend(ax3d,run_name,run_range)
        mdl.plot_torus(ax3d);
        mdl.plot_torus_axes(ax3d);
        mdl.plot_torus_vf(ax3d);
        mdl.plot_torus_nc(ax3d);
        if strcmp(run_name,'IC')            
            mdl.load_params(p0);
        end            
    end
end
