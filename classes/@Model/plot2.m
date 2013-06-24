function plot2(mdl,run_name,no)
    if nargin<2, run_name=''; end
    if nargin<3, no=0; end
    
    if mdl.stype < 2
        error('Function not available for single dimensional models')
    end
    
    %Parse options
    [trs, run_range, run_name, parval] = mdl.parse_options(run_name,no);
    size(trs)
    rr=length(run_range);

    figure; ax2d=subplot(1,1,1); hold 'on';
    %Plot in 2D-plane
    for r=1:rr
        mdl.load_sim(trs{r,1});
        switch run_name
            case ''
                if mdl.stype<2
                    PH=mdl.phmod;            
                    PHd=abs(mdl.phdot);
                    scatter(ax2d,PH,PHd,'k.');
                else
                    PH=mdl.phmod;
                    scatter(ax2d,PH(:,1),PH(:,2),'k.');
                end
            case 'IC'
                if mdl.stype<2
                    PH=mdl.phmod;
                    PHd=abs(mdl.phdot);
                    scatter(ax2d,PH,PHd,'.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
                else
                    PH1=mdl.phmod(:,1);
                    PH2=mdl.phmod(:,2);
                    scatter(ax2d,PH1,PH2,'.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
                end                
            otherwise
                ax2d=subplot(1,rr,r); hold on;
                if mdl.stype<2
                    PH=mdl.phmod;                    
                    PHd=abs(mdl.phdot);
                    scatter(ax2d,PH,PHd,'.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
                else
                    PH1=mdl.phmod(:,1);
                    PH2=mdl.phmod(:,2);
                    scatter(ax2d,PH1,PH2,'.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
                    title(sprintf('%s=%2.3f',run_name,run_range(r)))
                    p0=mdl.params;
                    mdl.load_params(parval);
                    mdl.subs_param(run_name,run_range(r));
                    mdl.plot_cart_nc(ax2d);
                    mdl.plot_cart_vf(ax2d);
                    mdl.plot_cart_axes(ax2d);
                    mdl.load_params(p0);
                end
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

