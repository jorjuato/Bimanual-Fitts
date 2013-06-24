function show_model_byinitconditions(phi0,w1,w2,alpha,tspan,intType)
    if nargin<6, intType='stochastic'; end
    if nargin<5, tspan=[0,12*pi]; end
    if nargin<4, alpha=0.5; end
    if nargin<3, w2=0.5; end
    if nargin<2, w1=1; end
    if nargin<1, phi0=[-1,1]; end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % GET ALL DATA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Get vector fields and nullclines for this system
    [phi1nc,phi2nc]=get_nullclines2(w1,w2,alpha,0);
    [PH1vf,PH2vf,dPH1,dPH2]=get_vector_fields(w1,w2,alpha,{-pi:0.1:pi+0.1;-pi:0.1:pi+0.1},0);

    %Get trayectories for this systems.
    phi_tr=cell(length(phi0));
    for i=1:length(phi0)
        params={w1,w2,alpha};
        initcond=[phi0(i),phi0(i)];
        if strcmp(intType,'stochastic')
            [t,phi] = solve_phiosc_stoc(params,initcond,tspan);
        else
            [t,phi] = solve_phiosc_det(params,initcond,tspan);
        end
        phi_tr{i}=[phi, t];
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PLOTTING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Some global stuff
    phaseaxe1=-pi:0.2:pi+0.2;
    phaseaxe2=zeros(size(phaseaxe1));         
    figure; ax2d=subplot(1,1,1); hold 'on'    
    figure; ax3d=subplot(1,1,1); hold 'on'
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot vector field and nullclines in 2D-plane
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    scatter(ax2d,phi1nc(1,:),phi1nc(2,:),'b.');
    scatter(ax2d,phi2nc(2,:),phi2nc(1,:),'r.');
    xlabel('phi1');
    ylabel('phi2');
    legend(ax2d,{'phi1 nullcline','phi2 nullcline'});
    title(['\omega_1=' num2str(w1) ' , \omega_2=' num2str(w2) ', \alpha=' num2str(alpha)]);
    quiver(ax2d,PH1vf,PH2vf,dPH1,dPH2,'k');
    xlim([-pi,pi]);
    ylim([-pi,pi]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot vector field and nullclines in 3D-torus
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %TRANSFORM TOROIDAL COORDINATES TO CARTESIAN    
    %Tranform phases, one for plotting vector field, other for torus
    [Xc,Yc,Zc] = torus2cart(PH1vf,PH2vf,5,10);
    [Xplt,Yplt,Zplt] = torus2cart(PH1vf,PH2vf,5.1,10);
    
    %Transform derivative vectors
    [Xt,Yt,Zt] = torus2cart(PH1vf+dPH1/20,PH2vf+dPH2/20,5,10);
    
    %The difference between both estimates derivative
    Vx=Xt-Xc; Vy=Yt-Yc; Vz=Zt-Zc;
    
    %Transform nullclineS
    [Xph1null,Yph1null,Zph1null]=torus2cart(phi1nc(1,:),phi1nc(2,:),5,10);
    [Xph2null,Yph2null,Zph2null]=torus2cart(phi2nc(2,:),phi2nc(1,:),5,10);
    
    %Do the real plotting
    plot3(ax3d,Xph1null,Yph1null,Zph1null,'b.');
    plot3(ax3d,Xph2null,Yph2null,Zph2null,'r.');
    legend(gca,{'phi1 nullcline','phi2 nullcline'});
    surf(ax3d,Xc,Yc,Zc);
    grid off;
    colormap([1  1  0]);
    hold on;
    quiver3(ax3d,Xplt,Yplt,Zplt,Vx,Vy,Vz,3);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot trayectories
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure;
    ax=subplot(1,1,1)
    hold on;
    for tr=1:length(phi_tr)
        data=phi_tr{tr};
        PH1=data(:,1);
        PH2=data(:,2);
        t=data(:,3);
        colors=[1,1,1/tr];
        %Plot in 2D-plane
        scatter(ax2d,mod(PH1,2*pi),mod(PH2,2*pi),'.','MarkerFaceColor',colors);
        plot(ax,t,cos(PH1),'r');
        plot(ax,t,cos(PH2),'b');
        %Plot in 3D-sphere
        %[Xc,Yc,Zc] = torus2cart(PH1,PH2,5.05,10.05);
        %scatter3(ax3d,Xc,Yc,Zc,'.','MarkerFaceColor',colors);
    end
    set(ax2d,'XLim',[-pi,pi]);
    set(ax2d,'YLim',[-pi,pi]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PLOT AXES IN PHI1=0,PHI2=0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot axes and labels in 2d plane
    plot(ax2d,phaseaxe1,phaseaxe2,'r','LineWidth',2);
    plot(ax2d,phaseaxe2,phaseaxe1,'b','LineWidth',2);
    xlabel('phi1');
    ylabel('phi2');    
    % plot axes on the torus
    [Xax1,Yax1,Zax1] = torus2cart(phaseaxe1,phaseaxe2,5,10);
    [Xax2,Yax2,Zax2] = torus2cart(phaseaxe2,phaseaxe1,5,10);
    plot3(ax3d,Xax1,Yax1,Zax1,'r','LineWidth',3);
    plot3(ax3d,Xax2,Yax2,Zax2,'b','LineWidth',3);    
    %Plot torus and vector field on the torus
    torus(5,10); colormap([1  1  0]);
    %plot_toroidal_vector_field(ax3d);
    
end