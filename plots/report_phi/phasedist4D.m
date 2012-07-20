function dist=phasedist4D(tr)
z=zeros(length(tr.ts.Lxnorm),1);
l=[tr.ts.Lxnorm,tr.ts.Lvnorm,z,z];    
r=[z,z,tr.ts.Rxnorm,tr.ts.Rvnorm];
dist=sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2 + (l(:,3)-r(:,3)).^2) + (l(:,4)-r(:,4)).^2;
%dist=dist-mean(dist);
end