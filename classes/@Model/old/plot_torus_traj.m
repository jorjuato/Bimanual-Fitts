function plot_torus_traj(mdl,run_name,no)
    if nargin<2, run_name=''; end
    if nargin<3, no=0; end
    
    %Parse options
    [trs, run_range, run_name, parval] = parse_options(mdl,run_name,no);   
    rr=length(run_range);

    %Plot trajectories on the torus
    figure; ax3d=subplot(1,1,1); hold 'on'; 
    for r=1:rr
        switch run_name
            case {'','IC'}
                PH1=mod(trs{r}.ph(:,1),2*pi);
                PH2=mod(trs{r}.ph(:,2),2*pi);
                [Xc,Yc,Zc] = torus2cart(PH1,PH2,5.05,10.05); %##########################
                scatter3(ax3d,Xc,Yc,Zc,'.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);                
            otherwise
                ax3d=subplot(1,rr,r); hold on;
                PH1=mod(trs{r}.ph(:,1),2*pi);
                PH2=mod(trs{r}.ph(:,2),2*pi);
                [Xc,Yc,Zc] = torus2cart(PH1,PH2,5.05,10.05); %##########################
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