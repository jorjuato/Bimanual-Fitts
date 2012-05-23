function dist=phasedist2D(tr)
z=zeros(length(tr.ts.Lph),1);
l=[tr.ts.Lph,z];
r=[z,tr.ts.Rph];
dist=mod(sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2),2*pi);
end