function plot_phhists(tr)
    if isa(tr.ts,'TimeSeriesBimanual')
        figure; hold on;
        ph=linspace(-pi,pi,length(tr.ts.Romega_phhist));
        plot(ph,tr.ts.Romega_phhist,'r');  
        plot(ph,tr.ts.Lomega_phhist,'r--'); 
        plot(ph,tr.ts.Rxnorm_phhist*10,'k'); 
        plot(ph,tr.ts.Lxnorm_phhist*10,'k--');
        plot(ph,tr.ts.Rvnorm_phhist*10,'m'); 
        plot(ph,tr.ts.Lvnorm_phhist*10,'m--');
        legend({'Romega','Lomega','Rxnorm','Lxnorm','Rvnorm','Lvnorm'});
        hline(0,'k');
        vline(ph(round(end/2)),'k');
        xlim([-pi,pi]);  
        ylim([-10,10]);
    else
        figure; hold on;
        ph=linspace(-pi,pi,length(tr.ts.omega_phhist));
        plot(ph,tr.ts.omega_phhist,'r');  
        plot(ph,tr.ts.xnorm_phhist*10,'b'); 
        plot(ph,tr.ts.vnorm_phhist*10,'k'); 
        legend({'omega','xnorm','vnorm'});
        hline(0,'k');
        vline(ph(round(end/2)),'k');
        xlim([-pi,pi]);
        ylim([-10,10]);
    end