function torus2()
a=1;
c=2;
[u,v]=meshgrid(-pi-0.1:0.1:pi);
x=(c+a*cos(v)).*cos(u);
y=(c+a*cos(v)).*sin(u);
z=a*sin(v);
surfl(x,y,z)
axis equal;