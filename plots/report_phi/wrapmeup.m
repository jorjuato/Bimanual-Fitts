function ph  = wrapmeup(ph)
    if max(ph) > 2*pi || min(ph)<-2*pi
        ph=rem(ph,2*pi);
    end
    idx1=ph>pi;
    ph(idx1)=ph(idx1)-2*pi;
    idx2=ph<-pi;
    ph(idx2)=ph(idx2)+2*pi;
end