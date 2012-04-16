function plotKMcoefTime(x,t,D,names,x0);
if nargin<5, x0=[]; end
ho=ishold;
h=findobj(gca,'Type','Line'); 
for k=1:length(h)
   c{k}=get(h(k),'color');
end
quiverKMcoef(x,D,names,t);
set(findobj(gca,'Type','Line'),'color',[.5 .5 .5]);
for k=1:length(h)
   if ishandle(h(k))
      set(h(k),'color',c{k});
   end
end
hold on;
for k=1:size(x0,1)
   y=reconstructX(x,D,t,x0(k,:));
   switch size(x,2)
   case 1, plot(t,y);
      if k==1, ylabel('x_{reconstruct}^{(deterministic)}'); xlabel('t'); end
   case 2, plot(y(:,1),y(:,2));
   case 3, plot3(y(:,1),y(:,2),y(:,3));
   end
   hold on;
end
if ho==0;
   hold off;
end
