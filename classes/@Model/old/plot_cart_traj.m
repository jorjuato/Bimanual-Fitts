function plot_cart_traj(mdl,run_name,ax2d)
    if nargin<2, run_name=''; end
    if nargin<3, figure; ax2d=subplot(1,1,1); hold 'on'; end
    
    %Parse options
    [trs, run_range, run_name, parval] = parse_options(mdl,run_name,no);
    rr=length(run_range);

    
    %Plot in 2D-plane
    for r=1:rr
        switch run_name
            case {'','IC'}
                PH1=mod(trs{r}.ph(:,1),2*pi)-pi;
                PH2=mod(trs{r}.ph(:,2),2*pi)-pi;
                scatter(ax2d,PH1,PH2,'.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
            otherwise
                ax2d=subplot(1,rr,r); hold on;
                PH1=mod(trs{r}.ph(:,1),2*pi)-pi;
                PH2=mod(trs{r}.ph(:,2),2*pi)-pi;
                scatter(ax2d,PH1,PH2,'.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
                title(sprintf('%s=%2.3f',run_name,run_range(r)))
                mdl.subs_param(run_name,run_range(r));
                mdl.plot_cart_nc(ax2d);
                mdl.plot_cart_vf(ax2d);
                mdl.plot_cart_axes(ax2d);
        end
    end
    
    if any(strcmp(run_name,{'','IC'}))
        if strcmp(run_name,'IC')
            p0=mdl.params;
            mdl.load_params(parval);
        end
        mdl.plot_legend(ax2d,run_name,run_range)
        mdl.plot_cart_nc(ax2d);
        mdl.plot_cart_vf(ax2d);
        mdl.plot_cart_axes(ax2d);
        if strcmp(run_name,'IC')            
            mdl.load_params(p0);
        end        
    end    
end

