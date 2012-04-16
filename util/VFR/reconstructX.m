function x=reconstructX(xo,D,t,x0)
i_method='*linear';
if length(xo)==3, g_method='nearest'; else, g_method='nearest'; end
  
x=ones(length(t),length(xo))*NaN;
x(1,:)=x0;
switch length(xo),
case 1,
   i=isfinite(D{1});
   for k=2:length(t)
      dx=interp1(xo{1}(i),D{1}(i),x(k-1),i_method);
      if isnan(dx), break; end
      x(k)=x(k-1)+dx*(t(k)-t(k-1));
end
case 2,
   [X,Y]=meshgrid(xo{1},xo{2});
   i1=isfinite(D{1}); D1=griddata(X(i1),Y(i1),D{1}(i1),X,Y,g_method);
   i2=isfinite(D{2}); D2=griddata(X(i2),Y(i2),D{2}(i2),X,Y,g_method);
   for k=2:length(t)
      dx1=interp2(X,Y,D1,x(k-1,1),x(k-1,2),i_method);
      dx2=interp2(X,Y,D2,x(k-1,1),x(k-1,2),i_method);
      if isnan(dx1) | isnan(dx2), break; end
      dt=t(k)-t(k-1);
      x(k,1)=x(k-1,1)+dx1*dt;
      x(k,2)=x(k-1,2)+dx2*dt;
   end
case 3,
   [X,Y,Z]=meshgrid(xo{1},xo{2},xo{3});
   i1=isfinite(D{1}); D1=griddata3(X(i1),Y(i1),Z(i1),D{1}(i1),X,Y,Z,g_method);
   i2=isfinite(D{2}); D2=griddata3(X(i2),Y(i2),Z(i2),D{2}(i2),X,Y,Z,g_method);
   i3=isfinite(D{3}); D3=griddata3(X(i3),Y(i3),Z(i3),D{3}(i3),X,Y,Z,g_method);
   for k=2:length(t)
      dx1=interp3(X,Y,Z,D1,x(k-1,1),x(k-1,2),x(k-1,3),i_method);
      dx2=interp3(X,Y,Z,D2,x(k-1,1),x(k-1,2),x(k-1,3),i_method);
      dx3=interp3(X,Y,Z,D3,x(k-1,1),x(k-1,2),x(k-1,3),i_method);
      if isnan(dx1) | isnan(dx2) | isnan(dx3), break; end
      dt=t(k)-t(k-1);
      x(k,1)=x(k-1,1)+dx1*dt;
      x(k,2)=x(k-1,2)+dx2*dt;
      x(k,3)=x(k-1,3)+dx3*dt;
   end
end