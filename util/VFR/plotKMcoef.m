function [coef]=plotKMcoef(xo,D,names,fitorder)
coef={};
order=zeros(length(names),1);
for k=1:length(names)
   order(k)=sum(names{k});
end
[order,oi]=sort(order);
prec=0.1;
if nargin<4, fitorder=[]; end
bound=0.01;
switch length(xo)
case 1,
   for k=1:length(order)
      subplot(length(order),1,k);
      h=plot(xo{1},D{oi(k)},'o','markersize',4);
      le=sprintf('D^{(%d)}(x)',order(k));
      le0=[le ' ... {\it{numerical}}'];
      if isempty(fitorder)==0
         hold on;
         i=find(isfinite(D{k}));
         coef{k}=polyfit(xo{1}(i),D{k}(i),fitorder);
         coef{k}(find(abs(coef{k})<bound))=0;
         plot(xo{1}(i),polyval(coef{k},xo{1}(i)),'r');
         le=[le ' {\approx} ' poly2strg(round(coef{k}/prec)*prec,{'x'})];
         hold off;
         set(gca,'xlim',[xo{1}(1),xo{1}(end)],'ylim',[min(D{k}),max(D{k})]);
         le=legend(le0,le); set(le,'fontsize',8);
      else
         legend(le0);
      end
   end
case 2, 
   o=unique(order);
   if isempty(fitorder)==0
      [X,Y]=meshgrid(xo{1},xo{2});
   end
   for k=1:length(o)
      p=find(order==o(k));
      for n=1:length(p)
         i=oi(p(n));
         subplot(length(o),length(p),(k-1)*length(p)+n);
         surf(xo{1},xo{2},...
            D{i},D{i}/max(D{i}(:)),...
            'FaceColor','interp','EdgeColor','none',...
            'FaceLighting','phong','EdgeLighting','phong',...
            'BackFaceLighting','lit','facealpha',0.5); 
         axis tight;
         ti=sprintf('D^{(%d)}_{%s}(x_1,x_2)',o(k),sprintf('%d',names{i}));
         if isempty(fitorder)==0
            coef{i}=polyfit2d(X,Y,D{i},fitorder);
            DDp=polyval2d(coef{i},X,Y);
            coef{i}(find(abs(coef{i})<bound))=0;
            j=find(isnan(D{i}));
            DDp(j)=NaN;
            hold on;
            mesh(X,Y,DDp,'facecolor','none','edgecolor',[0.5,0.5,0.5]);
            hold off;
            axis tight;
            ti=[ti ' {\approx} ' ...
                  poly2strg(round(coef{i}/prec)*prec,{'x_1','x_2'})];
         end
         title(ti);
      end
   end
case 3, 
   o=unique(order);
   for k=1:length(o)
      p=find(order==o(k));
      for n=1:length(p)
         i=oi(p(n));
         subplot(length(o),length(p),(k-1)*length(p)+n);
         pa=patch(isosurface(xo{1},xo{2},xo{3},D{i}));
         isonormals(xo{1},xo{2},xo{3},D{i},pa);
         set(pa,'FaceColor','red','EdgeColor','none');
         daspect([1,1,1]);
         view(3)
         axis tight;
         ti=sprintf('D^{(%d)}_{%s}(x_1,x_2,x_3)',o(k),sprintf('%d',names{i}));
         title(ti);
      end
   end
end

