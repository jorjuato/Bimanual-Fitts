function plot_rose(tr)
Lx=tr.ts.Lxnorm;
Rx=tr.ts.Rxnorm;
Lv=tr.ts.Lvnorm;
Rv=tr.ts.Rvnorm;
p=tr.ls.p;
q=tr.ls.q;
rose(Lx-Rx,Lv-Rv);