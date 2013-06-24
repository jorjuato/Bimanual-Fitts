function plot_hists(tr)
%     if nargin<4, ext='png';end
%     if nargin<3, rootname=[];end
%     if nargin<2, graphPath=[];end
    

    if isa(tr.ts,'TimeSeriesBimanual')
        figure; hold on;
        plot(tr.ts.Romega_hist,'r');  
        plot(tr.ts.Lomega_hist,'b'); 
        plot(tr.ts.Lxnorm_hist*10,'b'); 
        plot(tr.ts.Rxnorm_hist*10,'r');
        plot(tr.ts.Lvnorm_hist*10,'b--'); 
        plot(tr.ts.Rvnorm_hist*10,'r--');
        hline(0,'k');
        xlim([0,length(tr.ts.Rxnorm_hist)])        
    else
        figure; hold on;
        plot(tr.ts.omega_hist,'r');  
        plot(tr.ts.xnorm_hist*10,'b'); 
        plot(tr.ts.vnorm_hist*10,'k'); 
        hline(0,'k');
        xlim([0,length(tr.ts.xnorm_hist)])
    end
