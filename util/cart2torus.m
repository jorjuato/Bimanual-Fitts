function [phi1,phi2]=cart2torus(x,y,z,r1,r2)
%TODO!!!!
x=(r2+r1*cos(phi2)).*cos(phi1);
y=(r2+r1*cos(phi2)).*sin(phi1);
z=r1*sin(phi2);