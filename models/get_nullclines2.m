function [phi1nc,phi2nc]=get_nullclines2(omega1,omega2,alpha,do_plot)
    if nargin<1, omega1=2; end
    if nargin<2, omega2=omega1/2; end
    if nargin<3, alpha=0.5; end
    if nargin<4, do_plot=0; end

    phirange=-pi:0.001:pi;
    
    phi1nc=zeros(size(phirange)*2);
    phi2nc=zeros(size(phirange)*2);
    for i=1:length(phirange);
        phi=phirange(i);
        %Get arcsin argument and check validity to avoid complex solutions
        arg1=-(omega1+sin(2*phi))/alpha;
        arg2=-(omega2+sin(2*phi))/alpha;
        if abs(arg1)>1, arg1=NaN; end
        if abs(arg2)>1, arg2=NaN; end
        
        %compute nullcline values for phi1
        phi1nc(1,2*i-1)=phi;
        phi1nc(2,2*i-1)=phi-asin(arg1);        
        phi1nc(1,2*i)=phi;
        phi1nc(2,2*i)=phi+asin(arg1)+pi;
        
        %compute nullcline values for phi2
        phi2nc(1,2*i-1)=phi;
        phi2nc(2,2*i-1)=phi-asin(arg2);        
        phi2nc(1,2*i)=phi;
        phi2nc(2,2*i)=phi+asin(arg2)+pi;
    end    
    if do_plot
        figure; subplot(1,1,1); hold on;
        scatter(phi1nc(1,:),phi1nc(2,:),'b.');
        scatter(phi2nc(2,:),phi2nc(1,:),'r.'); 
        xlim([-pi,pi]);
        ylim([-pi,pi]);
        legend(gca,{'phi1 nullcline','phi2 nullcline'});
        title(['\omega_1=' num2str(omega1) ' , \omega_2=' num2str(omega2) ', \alpha=' num2str(alpha)]);
    end
end

