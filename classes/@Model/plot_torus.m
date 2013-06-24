function plot_torus (mdl,ax)
    if nargin<2, figure;ax=subplot(1,1,1); hold on; end
    
    torus(mdl.conf.r1,mdl.conf.r2,mdl.conf.n,mdl.conf.cm,ax);
    
end
