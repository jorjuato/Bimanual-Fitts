function plot_cart_vf(mdl,ax)
    %Plot vector field in 2D-plane
    if nargin<2, figure; ax=subplot(1,1,1); hold on; end
    
    xlabel('ph1');
    ylabel('ph2');  
    quiver(ax,mdl.vf{:},'b');
    xlim([-pi,pi]);
    ylim([-pi,pi]); 
end