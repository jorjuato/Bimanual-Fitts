function [PH1,PH2,dPH1,dPH2]=get_vector_fields(omega1,omega2,alpha,phirange,do_plot)
    if nargin<1, omega1=2; end
    if nargin<2, omega2=1; end
    if nargin<3, alpha=0.5; end
    if nargin<4, phirange={-pi:0.1:pi+0.1;-pi:0.1:pi+0.1}; end
    if nargin<5, do_plot=1; end
    
    [PH1,PH2]=meshgrid(phirange{1},phirange{2});
    dPH1=omega1+sin(2*PH1) + alpha*sin(PH1-PH2);
    dPH2=omega2+sin(2*PH2) + alpha*sin(PH2-PH1);
    
    %Get nullclines
    [phi1nc,phi2nc]=get_nullclines2(omega1,omega2,alpha,0);
    
    if do_plot
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot vector field and nullclines in 2D-plane
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        figure; subplot(1,1,1); hold on; 
        scatter(phi1nc(1,:),phi1nc(2,:),'b.');        
        scatter(phi2nc(2,:),phi2nc(1,:),'r.'); 
        xlabel('phi1');
        ylabel('phi2');
        legend(gca,{'phi1 nullcline','phi2 nullcline'});
        title(['\omega_1=' num2str(omega1) ' , \omega_2=' num2str(omega2) ', \alpha=' num2str(alpha)]);        
        quiver(PH1,PH2,dPH1,dPH2);
        xlim([-pi,pi]);
        ylim([-pi,pi]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot in 3D-sphere
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Tranform phases to cartesian coordinates of a (5,10) torus
        [Xc,Yc,Zc] = torus2cart(PH1,PH2,5,10);        
        %Transform derivative vectors to cartesian
        [Xt,Yt,Zt]=torus2cart(PH1+dPH1/20,PH2+dPH2/20,5,10);        
        %The difference between both estimates derivative in cartesian
        Vx=Xt-Xc;        
        Vy=Yt-Yc;
        Vz=Zt-Zc;
        %Transform nullcline toroidal coordinates to cartesian
        [Xph1null,Yph1null,Zph1null]=torus2cart(phi1nc(1,:),phi1nc(2,:),5,10);
        [Xph2null,Yph2null,Zph2null]=torus2cart(phi2nc(2,:),phi2nc(1,:),5,10);
        
        %Here we will plot vector, at 1.1 minor radius torus 
        [Xplt,Yplt,Zplt] = torus2cart(PH1,PH2,5.1,10);
        
        %Do the real plotting
        figure;
        %[Xtor,Ytor,Ztor]=torus(5,10,10);
        %surf(Xtor,Ytor,Ztor);
        surf(Xc,Yc,Zc);
        grid off;
        colormap([1  1  0]);
        hold on;
        quiver3(Xplt,Yplt,Zplt,Vx,Vy,Vz,3);
        plot3(Xph1null,Yph1null,Zph1null,'b.');
        plot3(Xph2null,Yph2null,Zph2null,'r.');
    end
end