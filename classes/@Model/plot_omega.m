function plot_omega(mdl)
    figure()
    ph=linspace(0,2*pi,mdl.conf.bins);
    if mdl.stype<2        
        phdot=abs(mdl.eq([],ph,[],mdl.params{:}));
        plot(ph, phdot);
        xlabel('Phase')
        ylabel('Phase Dot')
        xlim([0,2*pi])
    else      
        phdot=abs(mdl.eq([],ph,[],mdl.params{:}));
        subplot; hold on 
        size(phdot)
        plot(ph,phdot(1,:),'r');
        plot(ph,phdot(2,:),'b');
        legend({'Oscillator 1','Oscillator 2'});
        xlabel('Phase')
        ylabel('Phase Dot')
        xlim([0,2*pi])
    end
end