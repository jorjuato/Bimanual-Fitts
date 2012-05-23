function max_pq=find_best_pq(tr)
    max_pq=zeros(3,1);
    for p=1:10
        for q=1:10
            %phase_ls-based method
            %[m,~]=Kulback_Leibler_distance(tr.ts.Lph*p-tr.ts.Rph*q,20);
            %freq_ls-based method
            if p<q,continue;end
            rho=p/q;
            SlowPxx_t = LockingStrength.get_scaled_PSD(tr.ls.SlowPxx,tr.ls.freqs,rho);
            N=sqrt( (rho^2+1) ./ ((rho+1)*8) );
            fls = N * trapz(tr.ls.freqs,SlowPxx_t.*tr.ls.FastPxx) / trapz(tr.ls.freqs,SlowPxx_t.^2+tr.ls.FastPxx.^2);
            if fls>max_pq(1)
                max_pq=[fls,p,q];
            end
        end
    end

end