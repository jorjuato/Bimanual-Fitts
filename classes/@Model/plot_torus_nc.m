function plot_torus_nc(mdl, ax)
    if nargin<2, figure; ax=subplot(1,1,1); hold on; end
     
    %Tranform phases to cartesian coordinates of a (5,10) torus
    [Xnc1,Ync1,Znc1] = torus2cart(mdl.ph1nc(1,:),mdl.ph1nc(2,:),5,10);
    [Xnc2,Ync2,Znc2] = torus2cart(mdl.ph2nc(2,:),mdl.ph2nc(1,:),5,10);
    
    %Plot both
    scatter3(ax,Xnc1,Ync1,Znc1,'r.');
    scatter3(ax,Xnc2,Ync2,Znc2,'b.');
end    