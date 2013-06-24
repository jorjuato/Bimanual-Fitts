function plot_cart_nc(mdl,ax)
    %Plot nullclines in 2D-plane
    if nargin<2, figure; ax=subplot(1,1,1); hold on; end
    
    scatter(ax,mdl.ph1nc(1,:),mdl.ph1nc(2,:),'r.');        
    scatter(ax,mdl.ph2nc(2,:),mdl.ph2nc(1,:),'b.');
    xlabel('ph1');
    ylabel('ph2');       
    xlim([-pi,pi]);
    ylim([-pi,pi]); 
end