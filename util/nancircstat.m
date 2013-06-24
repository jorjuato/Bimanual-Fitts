function [m,u]=nancircstat(a,b)
%CIRCSTAT(a,b) compute mean and variance of angular variables
%
%   [m,v]=CIRCSTAT(x) x is an angle in radians!!!
%   [m,v]=CIRCSTAT(x,y) x,y are read/imaginary or sin/cos components
%
%                                   (c) 8/2000 A. Daffertshofer
%
%   See also MEAN, STD.
if nargin==1
   i=~isnan(a);
   sa=sin(a(i));
   ca=cos(a(i));
else
   i=~isnan(a);
   j=~isnan(b);
   if i~=j
       error('Nans have to be simmetrically distributed in both signals');
   else
       rr=sqrt(a(i).^2+b(j).^2);
       sa=a(i)./rr;
       ca=b(j)./rr;
   end
end
sa=mean(sa);
ca=mean(ca);
m=atan2(sa,ca);
if nargout==2
  u=1-sqrt(sa^2+ca^2);
end
