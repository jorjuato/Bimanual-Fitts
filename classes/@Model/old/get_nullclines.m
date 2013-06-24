function [phi1_null,phi2_null]=get_nullclines(omega1,omega2,alpha,phirange,do_plot)
    if nargin<1, omega1=2; end
    if nargin<2, omega2=0.2; end
    if nargin<3, alpha=0.5; end
    if nargin<4, phirange=[-pi:0.01:pi;-pi:0.01:pi]; end
    if nargin<5, do_plot=0; end
    [phi1init,phi2init]=size(phirange);
    
    phi1_null=zeros(phi1init*phi2init,2);
    phi2_null=zeros(phi1init*phi2init,2);
    idx=0;
    for i=1:phi1init
        for j=1:phi2init
            idx=idx+1;
            phi_init=[phirange(1,i);phirange(2,j)];    
            
            [x,F]=fsolve(@phi1_nullcline,phi_init);
            phi1_null(idx,1)=x(1);
            phi1_null(idx,2)=x(2);
            
            [x,F]=fsolve(@phi2_nullcline,phi_init);            
            phi2_null(idx,1)=x(1);
            phi2_null(idx,2)=x(2);
        end
    end
    
    function y=phi1_nullcline(phi)
        y=sin(2*phi(1))+alpha*sin(phi(1)-phi(2))+omega1;
    end

    function y=phi2_nullcline(phi)
        y=sin(2*phi(2))-alpha*sin(phi(1)-phi(2))+omega2;
    end

    function nc = get_null(phi,omega,alpha)
        nc = phi - asin(-(omega+sin(2*phi))./alpha);
        %nc(~(~imag(nc(:))))=NaN;
    end

    if do_plot
        figure; 
        scatter(phi1_null(:,1),phi1_null(:,2),'b.');
        hold on; 
        scatter(phi2_null(:,1),phi2_null(:,2),'r.'); 
        xlim([-2*pi,2*pi]);
        ylim([-2*pi,2*pi]);
    end
    
end
