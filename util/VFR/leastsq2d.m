function s=leastsq2d(x,y,ind);
x(ind)=0;
y(ind)=0;
s=sum(sum((x-y).^2));
