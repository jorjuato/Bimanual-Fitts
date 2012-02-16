function [m,u]=circstat(a,b)
%CIRCSTAT(a,b) compute mean and variance of angular variables
%
%   [m,v]=CIRCSTAT(x) x is an angle in radians!!!
%   [m,v]=CIRCSTAT(x,y) x,y are read/imaginary or sin/cos components
%
%                                   (c) 8/2000 A. Daffertshofer
%
%   See also MEAN, STD.
if nargin==1
   sa=sin(a);
   ca=cos(a);
else
   rr=sqrt(a.^2+b.^2);
   sa=a./rr;
   ca=b./rr;
end
sa=mean(sa);
ca=mean(ca);
m=atan2(sa,ca);
if nargout==2
  u=1-sqrt(sa^2+ca^2);
end
