function [D,xo,names,p,pc,coef,K,Q,timestep,x]=...
    KMexample(dim,binnumber,samplenumber)
if nargin<3, samplenumber=10^6; end
if nargin<2, binnumber=60/dim; end
timestep=1/100;
switch dim
case 1, 
   Q=.2;
   K=1;
   %x=pitchfork_sde(K,Q,samplenumber,timestep,0);
   load subject1data.mat
   x=data(1).x;
   samplenumber=length(x);
   [p,xo,pc]=prob_1D(x,binnumber,1);
   [D,xo,names]=KMcoef_1D(xo,pc,0.01,[1,2]);
   x0=[-2:0.25:2]';
case 2,
   Q=.1;
   K=[0,-1,0,-0.5,1,0,-1,0,0,0];
   %x=osci_sde(K,Q,samplenumber,timestep,[2,0]);
   load subject1data.mat
   x1=filter_freqs(data(1).x,0.001,9,120,true);
   x2=[0; diff(x1)];
   %size(x1), size(x2)
   x=[x1 x2];
   samplenumber=length(x1);
   [p,xo,pc]=prob_2D(x,binnumber,1,10);
   [D,xo,names]=KMcoef_2D(xo,pc,0.01,[1,2]);
   x0=[[0,1];[-.5,-4]];
case 3,
   Q=5;
   K=[10,28,8/3];
   x=lorenz_sde(K,Q,samplenumber,timestep,[1,1,1]); 
   size(x)
   [p,xo,pc]=prob_3D(x,binnumber,1);
   save('tmp3d.mat','x','p');
   clear p; clear x; pack;
   [D,xo,names]=KMcoef_3D(xo,pc,0.01,[1,2]);
   load('tmp3d.mat','x','p');
   %x0=min(abs(x(:,1))); x0=x(x0,:);%[10,25,8/3];
   x0=[10,25,8/3];
end
figure(1);
coef=plotKMcoef(xo,D,names,3);
%hgsave(['KM_figure1_' num2str(dim) '.fig']);
figure(2);
%t=(0:timestep:25)';
t=1:samplenumber/1000:length(x(:,1))-1;
subplot(1,2,1);
plot(t, x(1:length(t),:)); axis tight;
xlabel('t'); 
for k=1:dim, le{k}=['x_{' num2str(k) '}']; end
legend(le);
subplot(1,2,2);
switch dim
case 1,
   plot(t,x(1:length(t)),'color',[1,.7,1]);
case 2,
   plot(x(1:length(t),1),x(1:length(t),2),'color',[1,.7,1]);
case 3,
   plot3(x(1:length(t),1),x(1:length(t),2),x(1:length(t),3),'color',[1,.7,1]);
end
hold on;
plotKMcoefTime(xo,t,D,names,x0);
hold off;
axis tight;
%hgsave(['KM_figure2_' num2str(dim) '.fig']);

