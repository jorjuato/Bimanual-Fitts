function plot_cart_axes (mdl,ax)
    if mdl.stype < 2
        phaseaxe1=-pi:0.1:pi+0.1;
        phaseaxe2=0:0.1:15; 
        % plot axes and labels to compare with 3d torus
        plot(ax,phaseaxe1,zeros(size(phaseaxe1)),'r','LineWidth',2);
        plot(ax,phaseaxe2,zeros(size(phaseaxe2)),'b','LineWidth',2);
        % plot axes and labels to compare with 3d torus
        plot(ax,phaseaxe1+pi,phaseaxe2,'r','LineWidth',2);
        plot(ax,phaseaxe2,phaseaxe1+pi,'b','LineWidth',2);    
        xlabel('ph');
        ylabel('phdot');
    else
        phaseaxe1=-pi:0.1:pi+0.1;
        phaseaxe2=zeros(size(phaseaxe1)); 
        % plot axes and labels to compare with 3d torus
        plot(ax,phaseaxe1,phaseaxe2,'r','LineWidth',2);
        plot(ax,phaseaxe2,phaseaxe1,'b','LineWidth',2);
        % plot axes and labels to compare with 3d torus
        plot(ax,phaseaxe1+pi,phaseaxe2,'r','LineWidth',2);
        plot(ax,phaseaxe2,phaseaxe1+pi,'b','LineWidth',2);    
        xlabel('ph1');
        ylabel('ph2');
    end
end
