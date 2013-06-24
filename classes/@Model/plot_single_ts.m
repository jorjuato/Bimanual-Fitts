function plot_single_ts(mdl)
    if isempty(mdl.t)
        mdl.run()
    end
    
    %Temporal trajectories of phases
    if mdl.stype<2
        figure('name','Temporal Trayectories of cos(phi), -sen and phidot');
        hold on;
        v=[0;diff(mdl.phcos)./diff(mdl.t)];
        plot(mdl.t,mdl.phcos,'b')
        plot(mdl.t,v./max(abs(v)),'k')
        plot(mdl.t,mdl.phdot./min(mdl.phdot),'r')
        hline(0,'k')
        ylabel('cos(ph) | cosdot(ph) | phdot')
        xlabel('time')
        legend({'position','velocity','omega'})
    else
        %Temporal trajectories of phases
        figure('name','Temporal Trayectories of ph1/ph1dot and ph2/ph2dot');        
        
        subplot(2,1,1);hold on; 
        v=[0;diff(mdl.phcos(:,1))./diff(mdl.t)];
        plot(mdl.t, mdl.phcos(:,1),'b')        
        plot(mdl.t, v./max(abs(v)),'k')
        plot(mdl.t,mdl.phdot(:,1)./min(mdl.phdot(:,1)),'r')
        hline(0,'k')
        ylabel('cos(ph1) | cosdot(ph1) | ph1dot')
        xlabel('time')
        legend({'x1','v1','ph1dot'})
        
        subplot(2,1,2);hold on;        
        v=[0;diff(mdl.phcos(:,2))./diff(mdl.t)];
        plot(mdl.t, mdl.phcos(:,2),'b')
        plot(mdl.t, v./max(abs(v)),'k')
        plot(mdl.t,mdl.phdot(:,2)./min(mdl.phdot(:,2)),'r')
        hline(0,'k')
        ylabel('cos(ph2) | cosdot(ph2) | ph2dot')
        xlabel('time')
        legend({'x2','v2','ph2dot'})
    end
end