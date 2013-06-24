function plot_4paper(mdl,trs,mdls)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   trs  = tr_e,  tr_ml,  tr_me,   tr_d                        
%   mdls = mdl_e, mdl_ml, mdl_me,  mdl_d 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin < 3 || length(trs)<4 || length(mdls)<4
        error('Wrong input parameters')
    end
    
    global close_figs
    global mnames
    close_figs=1;
    mnames={'lowID','latemediumID','earlymediumID','highID'};
    
    plot_fig1(mdl,trs{1});
    plot_fig2(mdl,trs);
    plot_fig3(mdl);
    plot_fig4(mdl,trs,mdls);
end

function plot_fig1(mdl,tr)    
    global close_figs
    %Panel 1: Time-based Histograms: Experimental and simulated
    figure; subplot(1,1,1);hold on;
    plot(tr.ts.xnorm_hist,'r');
    plot(tr.ts.vnorm_hist,'b');
    plot(tr.ts.anorm_hist,'m');
    xlabel('movement time (%)')
    legend({'x_{norm}','v_{norm}','a_{norm}'});
    hline(0,'k');grid on;
    mdl.savefig('fig1panel1');
    if close_figs, close; end
    
    %Panel 2: PH-based Histograms: Experimental and simulated ????
    figure; subplot(1,1,1);hold on;
    plot(tr.ts.ph_hist./pi,'r--');
    plot(tr.ts.ampnorm_hist,'b');
    plot(tr.ts.omeganorm_hist,'m');
    xlabel('movement time (%)')
    legend({'\theta_{norm}','A_{norm}','\theta`_{norm}'});
    hline(0,'k');grid on;
    mdl.savefig('fig1panel2');
    if close_figs, close; end
     
    %PANEL 3. Experimental position/velocity phase plane
    figure; subplot(1,1,1);hold on;
    %title('Experimental phase plane and vector field');
    %plot(tr.ts.xnorm,tr.ts.vnorm,'color',[1,.7,1]);
    scatter(tr.ts.xnorm_hist,tr.ts.vnorm_hist,'r.');
    xlabel('x_{norm}');ylabel('v_{norm}')    
    xlim([-1,1]);ylim([-1, 1]);
    hline(0,'k');vline(0,'k');grid on;
    mdl.savefig('fig1panel3');
    if close_figs, close; end
     
    %PANEL 4. Experimental theta/amplitude phase plane
    figure; subplot(1,1,1);hold on;
    %title('Simulated phase plane and vector field');
    scatter(tr.ts.ph_phhist,tr.ts.ampnorm_phhist,'b.');
    scatter(tr.ts.ph_phhist,tr.ts.omeganorm_phhist,'r.');
    legend({'A_{norm}','\theta`_{norm}'});
    xlabel('\theta`');ylabel('A')  
    xlim([-pi,pi]);ylim([0, 1]);
    hline(0,'k');vline(0,'k');grid on;
    mdl.savefig('fig1panel4');
    if close_figs, close; end
end


function plot_fig2(mdl,trs)
    global close_figs
    global mnames
    for i=1:length(mnames)
        tr=trs{i};
        figure; subplot(1,1,1);hold on;
        plot(tr.ts.ph_phhist,tr.ts.xnorm_phhist,'r--');
        plot(tr.ts.ph_phhist,tr.ts.vnorm_phhist,'b--');
        plot(tr.ts.ph_phhist,tr.ts.anorm_phhist,'m--');
        plot(tr.ts.ph_phhist,tr.ts.omeganorm_phhist,'k');
        legend({'x_{norm}','v_{norm}','a_{norm}','\theta`'});
        xlabel('\theta');
        xlim([-pi,pi]);ylim([-1,1]);
        hline(0,'k');grid on;        
        mdl.savefig(['fig2_',mnames{i}]);
        if close_figs, close; end
    end    
end


function plot_fig3(mdl)
    global close_figs
    p=mdl.params;
    
    mdl.params={1,0,0,0,0};    
    mdl.plot_param_omega2D('a',0.5:0.1:3);
    mdl.savefig('fig3_a');
    if close_figs, close; end
    
    mdl.params={1,0,0,0,0};
    mdl.plot_param_omega2D('b',0.5:0.1:3);
    mdl.savefig('fig3_b');
    if close_figs, close; end
    
    mdl.params={1,1,1,0,0};
    mdl.plot_param_omega2D('c',-pi:pi/64:pi);
    mdl.savefig('fig3_c');
    if close_figs, close; end
    
    mdl.params={1,1,1,0,0};
    mdl.plot_param_omega2D('d',-pi:pi/64:pi);
    mdl.savefig('fig3_d');
    if close_figs, close; end
    
    mdl.load_param(p);
end


function plot_fig4(mdl,trs,mdls)
    global close_figs
    global mnames
    for i=1:length(mnames)
        plot_fig4_tsfcn(trs{i},mdls{i})
        mdl.savefig(['fig4_ts_',mnames{i}]);
        if close_figs, close; end
%         
%         plot_fig4_phfcn(trs{i},mdls{i})
%         mdl.savefig(['fig4_ph_',mnames{i}]);
%         if close_figs, close; end
        
        plot_fig4_phspfcn(trs{i},mdls{i})
        mdl.savefig(['fig4_',mnames{i}]);
        if close_figs, close; end
    end
end

function plot_fig4_tsfcn(tr,mdl)
    %Time-based Histograms: Experimental and simulated
    ds=get_data_4plots(tr,mdl);
    
    figure('name','Plot of trial fitting 2: simulated vs experimental phidot and vector field');
    subplot(1,2,[1,2]);hold on;
    %title('TS-based histograms');
    
    plot(ds.t,ds.xnorm_hist,'r');
    plot(ds.t,ds.vnorm_hist,'b');
    %plot(ax_tshist,t,anorm_hist,'y');
    plot(ds.t,ds.omeganorm_hist,'m');
    
    plot(ds.t,ds.mdlxnorm,'r--');
    plot(ds.t,ds.mdlvnorm,'b--');
    %plot(ax_tshist,t,mdl.anorm_hist,'m--');
    plot(ds.t,mdl.omeganorm_hist,'m--');
    
    legend({'xp x_{norm}','xp v_{norm}','xp \theta`_{norm}','mdl x_{norm}','mdl v_{norm}','mdl \theta_{norm}'});
    hline(0,'k');grid on;
end

function plot_fig4_phfcn(tr,mdl)
    %Phase-based Histograms: Experimental and simulated
    ds=get_data_4plots(tr,mdl);
    
    figure('name','Plot of trial fitting 3: simulated vs experimental phidot and vector field');
    subplot(1,2,[1,2]);hold on;
    %title('PH-based histograms');
    
    scatter(linspace(-pi,pi,ds.phL),ds.xnorm_phhist,'r+');
    scatter(linspace(-pi,pi,ds.phL),ds.vnorm_phhist,'b+');
    scatter(linspace(-pi,pi,ds.phL),ds.omeganorm_phhist,'m+');
    
    scatter(mdl.ph_phhist,ds.mdlxnormph,'r.');
    scatter(mdl.ph_phhist,ds.mdlvnormph,'b.');
    scatter(mdl.ph_phhist,mdl.omeganorm_phhist,'m.');
    
    legend({'xp x_{norm}','xp v_{norm}','xp omega_{norm}','mdl x_{norm}','mdl v_{norm}','mdl omega_{norm}'});
    xlim([-pi,pi]);
    hline(0,'k');vline(0,'k');
    grid on;    
end

function plot_fig4_phspfcn(tr,mdl)
    %Phase-Spaces: Experimental and simulated
    ds=get_data_4plots(tr,mdl);
    
    %PANEL 1: Phdot vs ph: experimental and simulated data
    figure('name','Plot of trial fitting 1: simulated vs experimental phidot and vector field');
    subplot(2,2,[1,3]);hold on;
    %title('Angular phase plane');
    scatter(linspace(-pi,pi,ds.phL),-ds.fitfcn(ds.pfit,-linspace(-pi,pi,ds.phL)),'b.');
    scatter(linspace(-pi,pi,ds.phL),-mdl.omega_phhist,'m.');
    scatter(linspace(-pi,pi,ds.phL),-ds.omega_phhist,'r.');
    legend({'theorethical','simulated','experimental'});
    xlabel('phase');ylabel('phase_dot');
    xlim([-pi,pi]);
    hline(0,'k');grid on;

    %PANEL 2.B. Experimental Cartesian phase planes: vector fields and trajectories
    subplot(2,2,[2]);hold on;
    title('Avg experimental trajectory on state space');
    %i=isfinite(ds.vf{1}) & isfinite(ds.vf{2});
    %[X,Y]=meshgrid(ds.vf{end}{1},ds.vf{end}{2});
    plot(ds.xnorm_hist,ds.vnorm_hist)%,'color',[1,.7,1]);
    %quiver(X(i),Y(i),ds.vf{1}(i),ds.vf{2}(i));
    xlabel('xnorm');ylabel('vnorm')
    xlim([-1,1]);ylim([-1, 1]);
    hline(0,'k');vline(0,'k');grid on;
    
    
    %PANEL 2.A. Simulated Cartesian phase planes: vector fields and trajectories
    subplot(2,2,[4]);hold on;
    title('Avg simulated trajectory on state space');
    plot(ds.mdlxnorm,ds.mdlvnorm)%,'color',[1,.7,1])
    %quiver(mdl.vfcart{:});
    xlabel('xnorm');ylabel('vnorm')
    xlim([-1,1]);ylim([-1, 1]);
    hline(0,'k');vline(0,'k');grid on;
end


function ds=get_data_4plots(tr,mdl)
    %Get simulated sizes to rescale experimental vectors
    ds.h='';
    ds.tsL=length(mdl.ph_hist);
    ds.phL=length(mdl.ph_phhist);
    ds.t=1:ds.tsL;
    ds.ph=tr.ts.([ds.h,'ph']);
    ds.pfit=cell2mat(mdl.params);
    
    %Get experimental time series and scaled histograms 
    ds.ph_phhist=resize_vector(tr.ts.([ds.h,'ph_phhist']),ds.phL);
    ds.omega_phhist=resize_vector(tr.ts.([ds.h,'omega_phhist']),ds.phL);
    ds.omeganorm_phhist=resize_vector(tr.ts.([ds.h,'omeganorm_phhist']),ds.phL);
    ds.amp_phhist=resize_vector(tr.ts.([ds.h,'amp_phhist']),ds.phL);
    ds.ampnorm_phhist=resize_vector(tr.ts.([ds.h,'ampnorm_phhist']),ds.phL);
    ds.xnorm_phhist=resize_vector(tr.ts.([ds.h,'xnorm_phhist']),ds.phL);
    ds.vnorm_phhist=resize_vector(tr.ts.([ds.h,'vnorm_phhist']),ds.phL);
    ds.anorm_phhist=resize_vector(tr.ts.([ds.h,'anorm_phhist']),ds.phL);
    ds.ph_hist=resize_vector(tr.ts.([ds.h,'ph_phhist']),ds.tsL);
    ds.omega_hist=resize_vector(tr.ts.([ds.h,'omega_hist']),ds.tsL);
    ds.omeganorm_hist=resize_vector(tr.ts.([ds.h,'omeganorm_hist']),ds.tsL);
    ds.amp_hist=resize_vector(tr.ts.([ds.h,'amp_hist']),ds.tsL);
    ds.ampnorm_hist=resize_vector(tr.ts.([ds.h,'ampnorm_hist']),ds.tsL);
    ds.xnorm_hist=resize_vector(tr.ts.([ds.h,'xnorm_hist']),ds.tsL);
    ds.vnorm_hist=resize_vector(tr.ts.([ds.h,'vnorm_hist']),ds.tsL);
    ds.anorm_hist=resize_vector(tr.ts.([ds.h,'anorm_hist']),ds.tsL);
    ds.vf=tr.(['vf',ds.h]).vectors;

  
    ds.xnorm=tr.ts.([ds.h,'xnorm_hist']);
    ds.vnorm=tr.ts.([ds.h,'vnorm_hist']);
    
    phcos_phhist=get_ph_histogram(mdl.phcos,mdl.phpeaks,mdl.conf.bins);
    phcos_hist=get_ts_histogram(mdl.phcos,mdl.xpeaks,mdl.conf.bins);    
    phsin_phhist=get_ph_histogram(mdl.phsin,mdl.phpeaks,mdl.conf.bins);
    phsin_hist=get_ts_histogram(mdl.phsin,mdl.xpeaks,mdl.conf.bins);
    
    ds.mdlxnorm=phcos_hist.*ds.amp_hist';
    ds.mdlvnorm=phsin_hist.*ds.amp_hist';
%     a=diff(ds.mdlvnorm)./diff(mdl.t);
%     anorm=a/max(abs(a));
%     ds.mdlanorm=[anorm(1),anorm];
    ds.mdlxnormph=phcos_phhist.*ds.amp_phhist';
    ds.mdlvnormph=phsin_phhist.*ds.amp_phhist';
%     a=diff(ds.mdlvnormph)./diff(mdl.t);
%     anorm=a/max(abs(a));
%     ds.mdlanormph=[anorm(1),anorm];    
    
    if mdl.stype==1
        ds.fitfcn=mdl.conf.fit1D;
    elseif mdl.stype==1.1
        ds.fitfcn=mdl.conf.fit11D;
    elseif mdl.stype==1.2
        ds.fitfcn=mdl.conf.fit12D;
    elseif mdl.stype==1.3
        ds.fitfcn=mdl.conf.fit13D;  
    elseif mdl.stype==1.4
        ds.fitfcn=mdl.conf.fit14D;  
    elseif mdl.stype==1.5
        ds.fitfcn=mdl.conf.fit15D;
    elseif mdl.stype==1.6
        ds.fitfcn=mdl.conf.fit16D;
    elseif mdl.stype==1.7
        ds.fitfcn=mdl.conf.fit17D;    
    elseif mdl.stype==2
        ds.fitfcn=mdl.conf.fit2D;
    end
end