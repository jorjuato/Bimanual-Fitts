function plot_ts(mdl)
    if isempty(mdl.t)
        mdl.run()
    end
    %Temporal trajectories of phases
    if mdl.stype==1
        figure('name','Temporal Trayectories of cos(phi), sen(phi) and phidot');
        hold on;
        plot(mdl.t,mdl.phcos,'b')
        plot(mdl.t,mdl.phsin,'k')
        plot(mdl.td,mdl.phdot,'r')
        hline(0,'k')
        ylabel('cos(ph) | sen(ph) | phdot')
        xlabel('time')
    else
        %Temporal trajectories of phases
        figure('name','Temporal Trayectories of ph1/ph1dot and ph2/ph2dot');        
        
        subplot(2,1,1);hold on;        
        plot(mdl.t, mdl.phcos(:,1),'b')
        plot(mdl.t, mdl.phsin(:,1),'k')
        plot(mdl.td,mdl.phdot(:,1),'r')
        hline(0,'k')
        ylabel('cos(ph1) | sen(ph1) | ph1dot')
        xlabel('time')
        legend({'cos(ph1)','sen(ph1)','ph1dot'})
        
        subplot(2,1,2);hold on;        
        plot(mdl.t, mdl.phcos(:,2),'b')
        plot(mdl.t, mdl.phsin(:,2),'k')
        plot(mdl.td,mdl.phdot(:,2),'r')
        hline(0,'k')
        ylabel('cos(ph2) | sen(ph2) | ph2dot')
        xlabel('time')
        legend({'cos(ph2)','sen(ph2)','ph2dot'})
    end
end