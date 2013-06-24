function [phi1_null,phi2_null,phirange]=get_nullclines3(omega1,omega2,alpha,do_plot)
    if nargin<1, omega1=2; end
    if nargin<2, omega2=omega1/2; end
    if nargin<3, alpha=0.5; end
    if nargin<4, do_plot=1; end

    phirange=0:0.01:2*pi;
    phi1_null=phi1_nullcline(phirange);
    phi2_null=phi2_nullcline(phirange);
    
    function y=phi1_nullcline(phi)
        y=phi-asin(-(omega1+sin(2*phi))/alpha);
    end

    function y=phi2_nullcline(phi)
        y=phi-asin(-(omega2+sin(2*phi))/alpha);
    end

    if do_plot
        figure; 
        scatter(phi1_null,phirange,'b.');
        hold on; 
        scatter(phirange,phi2_null,'r.'); 
        xlim([-2*pi,2*pi]);
        ylim([-2*pi,2*pi]);
    end
    

end
