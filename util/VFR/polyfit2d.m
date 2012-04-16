function coef=polyfit2d(X,Y,Z,N)
numcoef=1/2*N^2+3/2*N+1;
me=mean(Z(isfinite(Z)));
if numcoef==1,
   coef=me;
   return;
end
opt=optimset('fminsearch');
opt=optimset(opt,'TolFun',1e-10,'TolX',1e-10,'MaxFunEvals',5000*N,'MaxIter',5000*N);
ind=find(isnan(Z));
if isempty(ind)
   f=inline('sum(sum((polyval2d(c,x,y)-z).^2))','c','x','y','z');
   coef=fminsearch(f,[me,zeros(1,numcoef-1)],opt,X,Y,Z);
else
   f=inline('leastsq2d(polyval2d(c,x,y),z,ind)','c','x','y','z','ind');
   coef=fminsearch(f,[me,zeros(1,numcoef-1)],opt,X,Y,Z,ind);
end
