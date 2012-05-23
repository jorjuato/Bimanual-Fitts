function dist=phasedist3D(tr)
l=[tr.ts.Lxnorm,tr.ts.Lvnorm,zeros(length(tr.ts.Lxnorm),1)];    
r=[tr.ts.Rxnorm,zeros(length(tr.ts.Rxnorm),1),tr.ts.Rvnorm];
dist=sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2 + (l(:,3)-r(:,3)).^2);
end