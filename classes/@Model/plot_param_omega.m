function plot_param_omega(mdl,pname,prange)
    
    %Prepare figures, axis et al
    figtit=sprintf('Parametrization of variable %s: Cosinus Phase Space', pname);
    figure('name',figtit);    
    ph=linspace(-pi,pi,1000);    
    if mdl.stype<2
        hold on
    else
        ax1=subplot(1,2,1); hold on;
        ax2=subplot(1,2,2); hold on;
    end    
    legnames=cell(length(prange),1);
    
    %Do ploting
    for i=1:length(prange)
        mdl.subs_param(pname,prange(i));
        if mdl.stype<2        
            phdot=abs(mdl.eq([],ph,[],mdl.params{:}));
            scatter(ph, phdot,'.');
        else      
            phdot=abs(mdl.eq([],[ph;ph],[],mdl.params{:}));
            scatter(ax1,ph,phdot(1,:));
            scatter(ax2,ph,phdot(2,:));
        end
        legnames{i}=sprintf('%s=%1.3f',pname,prange(i));
    end
    %Do cosmetics
    legend(legnames);
    if mdl.stype<2
        hline(0,'k-')
        xlabel('Phase')
        ylabel('Phase Dot')
        xlim([-pi,pi])
    else
        hline(ax1,0,'k-')
        xlabel(ax1,'Phase')
        ylabel(ax1,'Phase Dot')
        xlim(ax1,[-pi,pi])
        hline(ax2,0,'k-')
        xlabel(ax2,'Phase')
        ylabel(ax2,'Phase Dot')
        xlim(ax2,[-pi,pi])
    end
        
end



