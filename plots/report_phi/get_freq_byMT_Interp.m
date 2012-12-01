function [Lf_I,Rf_I,phi]=get_freq_byMT_Interp(tr)    
    len=length(tr.ts.Lx);
    Lpeaks=tr.ts.Lpeaks;
    Lpeaks=round(Lpeaks(1:end-1)+diff(Lpeaks)/2);
    Rpeaks=tr.ts.Rpeaks;
    Rpeaks=round(Rpeaks(1:end-1)+diff(Rpeaks)/2);
    Lf=1./(2*tr.oscL.MT);
    Rf=1./(2*tr.oscR.MT);
    Lf_I=interp1(Lpeaks,Lf,1:len,'spline')';
    Rf_I=interp1(Rpeaks,Rf,1:len,'spline')';
    phi=tr.ts.Lph.*Rf_I-tr.ts.Rph.*Lf_I;
end