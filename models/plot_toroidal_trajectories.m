function plot_toroidal_trajectories(trs,omegas)
    
    if ~iscell(trs)
        trs={trs};
    end
    
    %Some global stuff
    phaseaxe1=0:0.1:2*pi+0.1;
    phaseaxe2=zeros(size(phaseaxe1));         
    figure; ax2d=subplot(1,1,1); hold 'on'    
    figure; ax3d=subplot(1,1,1); hold 'on'

    for tr=1:length(trs)
        data=trs{tr};
        PH1=data(:,1);
        PH2=data(:,2);
        %T=data(:,3);
        colors=[1,1,1/sqrt(tr)];

        %Plot in 2D-plane
        scatterhndl2D{tr}=scatter(ax2d,PH1,PH2,'.','MarkerFaceColor',colors);

        %Plot in 3D-sphere
        [Xc,Yc,Zc] = torus2cart(PH1,PH2,5.05,10.05);
        scatterhndl3D{tr}=scatter3(ax3d,Xc,Yc,Zc,'.','MarkerFaceColor',colors);
    end
    
    %Legend related stuff
    legtxts={size(omegas)};
    for i=1:length(omegas)
        legtxts{i}=['\omega=' num2str(omegas(i))];
    end
    legend(ax2d,legtxts);
    legend(ax3d,legtxts);
    
    % plot axes and labels to compare with 3d torus
    plot(ax2d,phaseaxe1,phaseaxe2,'r','LineWidth',2);
    plot(ax2d,phaseaxe2,phaseaxe1,'b','LineWidth',2);
    xlabel('phi1');
    ylabel('phi2');
    
    % plot torus some axes to understand who is who    
    [Xax1,Yax1,Zax1] = torus2cart(phaseaxe1,phaseaxe2,5,10);
    [Xax2,Yax2,Zax2] = torus2cart(phaseaxe2,phaseaxe1,5,10);
    plot3(ax3d,Xax1,Yax1,Zax1,'r','LineWidth',3);
    plot3(ax3d,Xax2,Yax2,Zax2,'b','LineWidth',3);
    
    %Plot torus and vector field on the torus
    torus(5,10); %colormap([1  1  0]);
    plot_toroidal_vector_field(ax3d);
    
end

function plot_toroidal_vector_field(ax)
    %Get vector field matrices
    [PH1,PH2,dPH1,dPH2]=get_vector_fields();
    
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