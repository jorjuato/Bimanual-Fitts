function [x, y, z] = torus (r1,r2,n,cm)
% TORUS Generate a torus.
% torus (r, n, a) generates a plot of a
% torus with central radius a and
% lateral radius r.
% n controls the number of facets
% on the surface.
% These input variables are optional
% with defaults r = 0.5, n = 30, a = 1.
%
% [x, y, z] = torus(r, n, a) generates
% three (n + 1)-by-(n + 1) matrices so
% that surf (x, y, z) will produce the
% torus.
%
% See also SPHERE, CYLINDER
%
% MATLAB Primer, 6th Edition
% Kermit Sigmon and Timothy A. Davis
% Section 11.5, page 65.

if nargin < 4, cm=[1  1  0]; end
if nargin < 3, n = 30 ; end
if nargin < 2, r2 = 10 ; end
if nargin < 1, r1 = 5 ; end
theta = pi * (0:2:2*n)/n ;
phi = 2*pi* (0:2:n)'/n ;
xx = (r2 + r1*cos(phi)) * cos(theta) ;
yy = (r2 + r1*cos(phi)) * sin(theta) ;
zz = r1 * sin(phi) * ones(size(theta)) ;
if nargout == 0
    surf (xx, yy, zz, cm) ;
    ar = (r1 + r2)/sqrt(2) ;
    axis([-ar, ar, -ar, ar, -ar, ar]) ;
else
    x = xx ;
    y = yy ;
    z = zz ;
end
