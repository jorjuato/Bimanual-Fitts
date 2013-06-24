function plot_torus_vf(mdl, ax)
    if nargin<2, figure; ax=subplot(1,1,1);hold on; end
    
    %Get vector field matrices
    [PH1,PH2,dPH1,dPH2]=mdl.vf{:};
    
    %Tranform phases to cartesian coordinates of a (5,10) torus
    [Xc,Yc,Zc] = torus2cart(PH1,PH2,5,10);
    
    %Here we will plot vector, at 1.1 minor radius torus
    [Xplt,Yplt,Zplt] = torus2cart(PH1,PH2,5.05,10.05);
    
    %Transform 'time-forward' phase vectors to cartesian
    [Xt,Yt,Zt]=torus2cart(PH1+dPH1/20,PH2+dPH2/20,5,10);
    
    %Obtain the vector directions in cartesian coordinate by substraction
    %of position vectors on the manifold.
    Vx=Xt-Xc;
    Vy=Yt-Yc;
    Vz=Zt-Zc;
    quiver3(ax,Xplt,Yplt,Zplt,Vx,Vy,Vz,3);
end