function quiverKMcoef(xo,D,names,t,K)
ho=ishold;
switch length(xo)
case 1,
   stepsize1=round(length(t)/20);
   stepsize2=round(length(D{1})/20);
   tt=t(1:stepsize1:end);
   quiver(tt,xo{1}(1:stepsize2:end),...
	  zeros(length(xo{1}(1:stepsize2:end)),length(tt)),...
	  repmat(D{1}(1:stepsize2:end),1,length(tt)));
   if nargin>2
      l=[ '[' sprintf('D^{(1)}_{%s}',sprintf('%d',names{1})) ']' ];
   else
      l='D';
   end
   title(l);
   xlabel('t');
   ylabel('x_1');
   set(gca,'xlim',[tt(1),tt(end)],'ylim',[min(xo{1}),max(xo{1})]);
case 2,
   [X,Y]=meshgrid(xo{1},xo{2});
   i=isfinite(D{1}) & isfinite(D{2});
   if nargin>4,
      i1=find(isnan(D{1}));
      i2=find(isnan(D{2}));
      P1=polyval2d(K(:,1),X,Y);
      P2=polyval2d(K(:,2),X,Y);
      P1(i1)=NaN;
      P2(i2)=NaN;
      h2=quiver(X(i),Y(i),P1(i),P2(i),'r');
      hold on;
   end
   h1=quiver(X(i),Y(i),D{1}(i),D{2}(i));
   if nargin>2
      l=[ '[' sprintf('D^{(1)}_{%s}',sprintf('%d',names{1})) ',' ...
            sprintf('D^{(1)}_{%s}',sprintf('%d',names{2})) ']' ];
   else
      l='D';
   end
   xlabel('x_1');
   ylabel('x_2');
   if ho==0
      hold off;
   end
   if nargin>4,
      legend([h1(1),h2(1)],l,...
         sprintf('[%s,%s]',poly2str(K(:,1),{'x_1','x_2'}),...
         poly2str(K(:,2),{'x_1','x_2'})));
   else
%       title(l);
   end
   set(gca,'xlim',[min(xo{1}),max(xo{1})],...
      'ylim',[min(xo{2}),max(xo{2})]);
case 3,
   [X,Y,Z]=meshgrid(xo{1},xo{2},xo{3});
   i=isfinite(D{1}) & isfinite(D{2}) & isfinite(D{3});
   quiver3(X(i),Y(i),Z(i),D{1}(i),D{2}(i),D{3}(i));
   if nargin>2
      l=[ '[' sprintf('D^{(1)}_{%s}',sprintf('%d',names{1})) ',' ...
            sprintf('D^{(1)}_{%s}',sprintf('%d',names{2})) ',' ...
            sprintf('D^{(1)}_{%s}',sprintf('%d',names{3})) ']' ];
   else
      l='D';
   end
   title(l);
   xlabel('x_1');
   ylabel('x_2');
   zlabel('x_3');
   set(gca,'xlim',[min(xo{1}),max(xo{1})],...
      'ylim',[min(xo{2}),max(xo{2})],...
      'zlim',[min(xo{3}),max(xo{3})]);
end
