function [Lf,Rf,phi]=get_phi_byMT(tr)
    Lf=zeros(size(tr.ts.Lx));
    Rf=zeros(size(tr.ts.Lx));
    LMT=tr.oscL.MT;
    RMT=tr.oscR.MT;
    Lpeaks=tr.ts.Lpeaks;
    Rpeaks=tr.ts.Rpeaks;
    for i=1:length(LMT)
        idx=Lpeaks(i):Lpeaks(i+1);
        Lf(idx)=ones(size(idx))./(2*LMT(i));
    end
    %Lf=filterdata(Lf,8);    
    for i=1:length(RMT)
        idx=Rpeaks(i):Rpeaks(i+1);
        Rf(idx)=ones(size(idx))./(2*RMT(i));
    end
    %Rf=filterdata(Rf,8);
    phi=tr.ts.Lph.*Rf-tr.ts.Rph.*Lf;
end