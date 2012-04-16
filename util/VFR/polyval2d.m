function p=polyval2d(coef,X,Y)
p=zeros(size(X));
n=length(coef);
ord=-3/2+1/2*sqrt(1+8*n);
l=0;
for k=0:ord
   Yk=Y.^k;
   for i=0:ord-k
      l=l+1;
      p=p+coef(l)*X.^i.*Yk;
   end
end
