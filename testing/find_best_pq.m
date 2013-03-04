function max_pq=find_best_pq(ls,method)
    if nargin==1,method=1;end
    max_pq=zeros(3,1); 
%     if method==1
%         figure;
%         hold on;
%     end
    for p=1:20
        for q=1:20
            if method==1
                %phase_ls-based method
                [m,~]=Kulback_Leibler_distance(ls.Lph*p-ls.Rph*q,20);
                if m>max_pq(1)
                    max_pq=[m,p,q];
                end 
            else
                %freq_ls-based method
                if p<q,continue;end
                rho=p/q;
                SlowPxx_t = LockingStrength.get_scaled_PSD(ls.SlowPxx,ls.freq,rho);
                N=sqrt( (rho^2+1) ./ ((rho+1)*8) );
                fls = N * trapz(ls.freq,SlowPxx_t.*ls.FastPxx) / trapz(ls.freq,SlowPxx_t.^2+ls.FastPxx.^2);
                if fls>max_pq(1)
                    max_pq=[fls,p,q];
                end
%                 if nargout==0
%                     plot(ls.freqs,SlowPxx_t,'b');
%                     plot(ls.freqs,ls.SlowPxx,'r');
%                     plot(ls.freqs,ls.FastPxx,'g');
%                     plot(ls.freqs,ls.FastPxx_t,'k');
%                 end
            end
        end
    end
    %hold off;
end