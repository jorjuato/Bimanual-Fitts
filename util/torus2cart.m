function [x,y,z]=torus2cart(phi1,phi2,r1,r2)
if nargin<3, r1=5; r2=10; end

%[u,v]=meshgrid(phi1,phi2);
%x=(r2+r1*cos(v)).*cos(u);
%y=(r2+r1*cos(v)).*sin(u);
%z=r1*sin(v);

x=(r2+r1*cos(phi2)).*cos(phi1);
y=(r2+r1*cos(phi2)).*sin(phi1);
z=r1*sin(phi2);