function plot_trfit(mdl,tr,h,pfit,do_run)
if nargin<5, do_run=1; end
if nargin==3, pfit=h; h=''; end
if nargin==2, pfit=mdl.params; h=''; end
if ~iscell(pfit)
    pfit=num2cell(pfit);
end
if do_run
    mdl.load_param(pfit);
    mdl.run();
elseif isempty(mdl.t)
    mdl.load_param(pfit);
    mdl.run();
end

if iscell(pfit)
    pfit=cell2mat(pfit);
end

%Get simulated sizes to rescale experimental vectors
tsL=length(mdl.ph_hist);
phL=length(mdl.ph_phhist);
t=1:tsL;

%Get experimental time series and scaled histograms 
ph_phhist=resize_vector(tr.ts.([h,'ph_phhist']),phL);
omega_phhist=abs(resize_vector(tr.ts.([h,'omega_phhist']),phL));
xnorm_phhist=resize_vector(tr.ts.([h,'xnorm_phhist']),phL);
vnorm_phhist=resize_vector(tr.ts.([h,'vnorm_phhist']),phL);
anorm_phhist=resize_vector(tr.ts.([h,'anorm_phhist']),phL);
ph_hist=resize_vector(tr.ts.([h,'ph_phhist']),tsL);
omega_hist=abs(resize_vector(tr.ts.([h,'omega_hist']),tsL));
xnorm_hist=resize_vector(tr.ts.([h,'xnorm_hist']),tsL);
vnorm_hist=resize_vector(tr.ts.([h,'vnorm_hist']),tsL);
anorm_hist=resize_vector(tr.ts.([h,'anorm_hist']),tsL);
vf=tr.(['vf',h]).vectors;

ph=tr.ts.([h,'ph']);
xnorm=cos(ph);
vnorm=[0;diff(xnorm)*1000];
vnorm=vnorm/max(abs(vnorm));
%xnorm=tr.ts.([h,'xnorm']);
%vnorm=tr.ts.([h,'vnorm']);

if mdl.stype==1
    fitfcn=mdl.conf.fit1D;
elseif mdl.stype==1.1
    fitfcn=mdl.conf.fit11D;
elseif mdl.stype==1.2
    fitfcn=mdl.conf.fit12D;
elseif mdl.stype==1.3
    fitfcn=mdl.conf.fit13D;  
elseif mdl.stype==1.4
    fitfcn=mdl.conf.fit14D;  
elseif mdl.stype==1.5
    fitfcn=mdl.conf.fit15D;
elseif mdl.stype==1.6
    fitfcn=mdl.conf.fit16D;
elseif mdl.stype==1.7
    fitfcn=mdl.conf.fit17D;    
elseif mdl.stype==2
    fitfcn=mdl.conf.fit2D;
end
    

%FIGURE 1. PANEL 1: Phdot vs ph: experimental and simulated data
figure('name','Plot of trial fitting 1: simulated vs experimental phidot and vector field');
ax_omg=subplot(2,2,[1,3]);hold on;
title('Angular phase plane');
scatter(ax_omg,linspace(-pi,pi,phL),abs(fitfcn(pfit,-linspace(-pi,pi,phL))),'b.');
scatter(ax_omg,linspace(-pi,pi,phL),abs(mdl.omega_phhist),'m.');
scatter(ax_omg,linspace(-pi,pi,phL),omega_phhist,'r.');
legend(ax_omg,{'theorethical','simulated','experimental'});
xlabel('phase');ylabel('phase_dot');
xlim([-pi,pi]);
hline(0,'k');grid on;

%FIGURE 1. PANEL 2.A. Simulated Cartesian phase planes: vector fields and trajectories
ax_vfsim=subplot(2,2,[4]);hold on;
title('Simulated phase plane and vector field');
plot(ax_vfsim,mdl.xnorm,mdl.vnorm,'color',[1,.7,1])
quiver(ax_vfsim,mdl.vfcart{:});
xlabel('xnorm');ylabel('vnorm')
xlim(ax_vfsim,[-1,1]);ylim(ax_vfsim,[-1, 1]);
hline(0,'k');vline(0,'k');grid on;

%FIGURE 1. PANEL 2.B. Experimental Cartesian phase planes: vector fields and trajectories
ax_vfexp=subplot(2,2,[2]);hold on;
title('Experimental phase plane and vector field');
i=isfinite(vf{1}) & isfinite(vf{2});
[X,Y]=meshgrid(vf{end}{1},vf{end}{2});
plot(ax_vfexp,xnorm,vnorm,'color',[1,.7,1]);
quiver(ax_vfexp,X(i),Y(i),vf{1}(i),vf{2}(i));
xlabel('xnorm');ylabel('vnorm')
xlim(ax_vfexp,[-1,1]);ylim(ax_vfexp,[-1, 1]);
hline(0,'k');vline(0,'k');grid on;

%FIGURE 2: Time-based Histograms: Experimental and simulated
figure('name','Plot of trial fitting 2: simulated vs experimental phidot and vector field');
ax_tshist=subplot(1,2,[1,2]);hold on;
title('TS-based histograms');
plot(ax_tshist,t,xnorm_hist,'r');
plot(ax_tshist,t,vnorm_hist,'b');
%plot(ax_tshist,t,anorm_hist,'y');
plot(ax_tshist,t,ph_hist./pi,'k');
plot(ax_tshist,t,omega_hist./max(omega_hist),'m');
plot(ax_tshist,t,mdl.xnorm_hist,'r--');
plot(ax_tshist,t,mdl.vnorm_hist,'b--');
%plot(ax_tshist,t,mdl.anorm_hist,'m--');
plot(ax_tshist,t,mdl.ph_hist./pi,'k--');
plot(ax_tshist,t,mdl.omega_hist./min(mdl.omega_hist),'m--');
legend(ax_tshist,{'xp xnorm','xp vnorm','xp ph','xp omega','mdl xnorm','mdl vnorm','mdl ph','mdl omega'});
hline(0,'k');grid on;

%FIGURE 3: Phase-based Histograms: Experimental and simulated
figure('name','Plot of trial fitting 3: simulated vs experimental phidot and vector field');
ax_phhist=subplot(1,2,[1,2]);hold on;
title('PH-based histograms');
scatter(ax_phhist,linspace(-pi,pi,phL),xnorm_phhist,'r.');
scatter(ax_phhist,linspace(-pi,pi,phL),vnorm_phhist,'b.');
scatter(ax_phhist,linspace(-pi,pi,phL),omega_phhist./max(omega_phhist),'m.');
scatter(ax_phhist,mdl.ph_phhist,mdl.xnorm_phhist,'rx');
scatter(ax_phhist,mdl.ph_phhist,mdl.vnorm_phhist,'bx');
scatter(ax_phhist,mdl.ph_phhist,mdl.omega_phhist./min(mdl.omega_phhist),'mx');
legend(ax_phhist,{'xp xnorm','xp vnorm','xp omega','mdl xnorm','mdl vnorm','mdl omega'});
xlim([-pi,pi]);
hline(0,'k');vline(0,'k');
grid on;

end
