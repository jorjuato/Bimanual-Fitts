function dist=phasedist2D(tr)
z=zeros(length(tr.ts.Lph),1);
l=[tr.ts.Lph*tr.ls.q,z];
r=[z,tr.ts.Rph*tr.ls.p];
size(l)
size(r)
dist=sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2);
dist=dist-mean(dist);
end