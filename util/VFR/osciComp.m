function [D,xo,names,p,pc,coef,K,Q,timestep,x]=...
    osciComp(binnumber,samplenumber,trialnumber)
if nargin<3, trialnumber=100; end
if nargin<2, samplenumber=10^5; end
if nargin<1, binnumber=20; end
timestep=0.001;
%[D,xo,names,p,pc,coef,K,Q,timestep,x]=osciComp(40,5*10^4,200);

Q=1/50;
K=[0,-1,0,-0.5,1,0,-1,0,0,0];
maX=-Inf; miX=Inf;
maY=-Inf; miY=Inf;
y=osci_sde(K,Q,samplenumber*trialnumber+10/timestep,timestep,[0,0]);
y=y(10/timestep+1:end,:);

rx=max(abs(y(:,1)));
ry=max(abs(y(:,2)));
r=[0.1,1.3];
n=trialnumber/4;
for k=1:trialnumber
   if k<n
      phi=(k-1)*2*pi/(n); R=r(1);
   else
      phi=(k-n)*2*pi/(trialnumber-n); R=r(2);
   end
   x0=R*[rx*cos(phi),ry*sin(phi)];
   x{k}=osci_sde(K,Q,samplenumber,timestep,x0);
%subplot(1,2,2); plot(x{k}(:,1),x{k}(:,2),'r'); hold on;
   maX=max(maX,max(x{k}(:,1))); miX=min(miX,min(x{k}(:,1))); 
   maY=max(maY,max(x{k}(:,2))); miY=min(miY,min(x{k}(:,2))); 
end
%return
b{1}=binset(miX,maX,binnumber);
b{2}=binset(miY,maY,binnumber);

[p,xo,pc]=prob_2D(y,b,1,10);
[D,xo,names]=KMcoef_2D(xo,pc,0.01,[1]);
x0=y(end,:);
t=(0:0.001:200)';
subplot(1,2,1);
plotKMcoefTime(xo,t,D,names,x0);
xlabel('\it{x}'); ylabel('\it{y}'); title('single trial');
drawnow;

pc=zeros(binnumber,binnumber,binnumber,binnumber);
ii=pc;
for k=1:trialnumber
   [p,xo,pcc]=prob_2D(x{k},b,1,10);
   j=find(isfinite(pcc)); 
   ii(j)=ii(j)+1;
   pc(j)=pc(j)+pcc(j);
   fprintf('.');
end
fprintf('\n');
j=find(ii);
pc(j)=pc(j)./ii(j);
j=find(ii==0);
pc(j)=NaN;
[D,xo,names]=KMcoef_2D(xo,pc,0.01,[1]);
subplot(1,2,2);
plotKMcoefTime(xo,t,D,names,[[0,5];[.3,0]]);
xlabel('\it{x}'); ylabel('\it{y}'); title('average'); 
set(gcf,'position',[ 120   603   612   274]);
set(findobj(gcf,'type','axes'),'FontName','Times New Roman','FontAngle','Italic');
hgsave('osciComp.fig');

function b=binset(xmin,xmax,N)
b=(xmin:(xmax-xmin)/N:xmax)';
