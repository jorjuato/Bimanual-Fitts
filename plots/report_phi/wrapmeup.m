function ph  = wrapmeup(ph)
    k=pi;
    if max(ph) > k || min(ph)<-k
        ph=rem(ph,k);
    end
    idx1=ph>pi;
    ph(idx1)=ph(idx1)-k;
    idx2=ph<-pi;
    ph(idx2)=ph(idx2)+k;
end