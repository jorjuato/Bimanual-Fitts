function dist=phasedist1D(tr)
    %dist=tr.ts.Lph*tr.ls.q-tr.ts.Rph*tr.ls.p;
    dist=tr.ls.phDiff;
    %dist=dist-mean(dist);
end