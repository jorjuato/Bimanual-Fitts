function plot_torus_axes (mdl,ax)
    if nargin<2, figure;ax=subplot(1,1,1); hold on; end
    
    phaseaxe1=-pi:0.1:pi+0.1;
    phaseaxe2=zeros(size(phaseaxe1)); 
    % plot torus some axes to understand who is who    
    [Xax1,Yax1,Zax1] = torus2cart(phaseaxe1,phaseaxe2,5,10);
    [Xax2,Yax2,Zax2] = torus2cart(phaseaxe2,phaseaxe1,5,10);
    plot3(ax,Xax1,Yax1,Zax1,'r','LineWidth',3);
    plot3(ax,Xax2,Yax2,Zax2,'b','LineWidth',3);
    % plot torus some axes to understand who is who    
    [Xax1,Yax1,Zax1] = torus2cart(phaseaxe1+pi/2,phaseaxe2,5,10);
    [Xax2,Yax2,Zax2] = torus2cart(phaseaxe2,phaseaxe1+pi/2,5,10);
    plot3(ax,Xax1,Yax1,Zax1,'r','LineWidth',3);
    plot3(ax,Xax2,Yax2,Zax2,'b','LineWidth',3);
end
