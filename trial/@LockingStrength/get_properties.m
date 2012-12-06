function get_properties(ls,ts)
    %Local copy time series ls properties
    ls.Rph_=ts.Rph;
    ls.Lph_=ts.Lph;
    ls.Rf_=ts.Rf;
    ls.Lf_=ts.Lf;
    ls.RPxx_=ts.RPxx;
    ls.LPxx_=ts.LPxx;
    ls.freq_=ts.freq;
    
    %Basic coordination measures
    [ls.p_,ls.q_]=get_p_q(ls);
    [ls.p_MI_,ls.q_MI_]=get_p_q_MI(ls);
    ls.rho_=get_rho(ls);
    ls.MI_=get_MI(ls);

    %Tranformed power spectrums
    ls.SlowPxx_=get_SlowPxx(ls);
    ls.FastPxx_=get_FastPxx(ls);
    ls.SlowPxx_t_=get_SlowPxx_t(ls);
    ls.FastPxx_t_=get_FastPxx_t(ls);
    
    %Locking strengths
    ls.flsPC_=get_flsPC(ls);
    ls.flsAmp_=get_flsAmp(ls);
   
    %Phase differences
    ls.phDiff_=get_phDiff(ls);
    ls.phDiffMean_=get_phDiffMean(ls);
    ls.phDiffStd_=get_phDiffStd(ls);

    %Distances in several dimensional spaces
    ls.d4D_=get_d4D(ts);
    ls.d3D_=get_d3D(ts);
    ls.d2D_=get_d2D(ts);
    ls.d1D_=get_d1D(ls);
    
    %Peak delays, another approach for phase difference
    ls.minPeakDelay_=get_minPeakDelay(ts);
    ls.minPeakDelayNorm_=get_minPeakDelayNorm(ls,ts);
    
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Properties getters and setter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function flsPC = get_flsPC(ls)
%Compute FLS Pure Coordination
%with formula from Huys et al. (2004), HMS
%N=sqrt( (ls.rho^2+1) / ((ls.rho+1)*8) );
N=sqrt(1+ls.rho_^2)*(1/ls.rho_+1)*sqrt(1/8);
%N=sqrt( (ls.rho^2+1) / ((ls.rho+1)*8) );
flsPC = 2*N * trapz(ls.freq_,ls.SlowPxx_t_.*ls.FastPxx_) / trapz(ls.freq_,ls.SlowPxx_t_.^2+ls.FastPxx_.^2);
end


function flsAmp = get_flsAmp(ls)
%Compute FLS Amplitude
%with formula from Huys et al. (2004), HMS
%N=sqrt( (ls.rho^2+1) / ((ls.rho+1)*8) );
N=sqrt(1+ls.rho_^2)*(1/ls.rho_+1)*sqrt(1/8);
flsAmp = 2*N * trapz(ls.freq_,ls.FastPxx_t_.*ls.SlowPxx_t_) / trapz(ls.freq_,ls.FastPxx_t_.^2+ls.SlowPxx_t_.^2);
end

function phDiff = get_phDiff(ls)
%phDiff = ls.q*ls.Lph-ls.p*ls.Rph;
phDiff= ls.q_*ls.Lph_-ls.p_*ls.Rph_;
end

function phDiffMean = get_phDiffMean(ls)
%[phDiffMean,~]=circstat(ls.p_MI*ls.Lph-ls.q_MI*ls.Rph);
[phDiffMean,~]=circstat(ls.phDiff_);
end

function phDiffStd = get_phDiffStd(ls)
%[~, phDiffStd]=circstat(ls.p_MI*ls.Lph-ls.q_MI*ls.Rph);
[~, phDiffStd]=circstat(ls.phDiff_);
end

function rho = get_rho(ls)
q=ls.q_; p=ls.p_;
if q>p
    rho=q/p;
else
    rho=p/q;
end
end

function MI = get_MI(ls)
%Get Kulback-Leiber distance between phase difference and uniform distribution
[MI,~]=Kulback_Leibler_distance(ls.Lph_*ls.q_-ls.Rph_*ls.p_,ls.conf.KLD_bins);
end

function d4D = get_d4D(ts)
Rx=ts.Rxnorm;
Lx=ts.Lxnorm;
Lv=ts.Lvnorm;
Rv=ts.Rvnorm;
z=zeros(size(Lx));
l=[Lx,Lv,z,z];
r=[z,z,Rx,Rv];
d4D=sqrt( (l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2 + (l(:,3)-r(:,3)).^2 + (l(:,4)-r(:,4)).^2);
%d4D=d4D-mean(d4D);
end

function d3D = get_d3D(ts)
Rx=ts.Rxnorm;
Lx=ts.Lxnorm;
Lv=ts.Lvnorm;
Rv=ts.Rvnorm;
z=zeros(size(Lx));
l=[Lx,Lv,z];
r=[Rx,z,Rv];
d3D=sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2 + (l(:,3)-r(:,3)).^2);
%d3D=d3D-mean(d3D);
end

function d2D = get_d2D(ts)
Lx=ts.Lxnorm;
Rx=ts.Rxnorm;
z=zeros(size(Lx));
l=[Lx,z];
r=[z,Rx];
d2D=sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2);
%d2D=d2D-mean(d2D);
%d2D=zeros(length(ts.Lph),1);
end

function d1D = get_d1D(ls)
d1D=ls.phDiff;
end

function [p,q]=get_p_q(ls)
Lf=ls.Lf_;
Rf=ls.Rf_;
if abs(1-Lf/Rf)<0.05
    q=1;p=1;
elseif Lf>Rf
    if abs(1.5-Lf/Rf)<0.075
        p=3; q=2;
    elseif abs(2-Lf/Rf)<0.1
        p=2; q=1;
    elseif abs(2.5-Lf/Rf)<0.125
        p=5; q=2;
    elseif abs(3-Lf/Rf)<0.15
        p=3; q=1;
    elseif abs(3.5-Lf/Rf)<0.175
        p=7; q=2;
    elseif abs(4-Lf/Rf)<0.2
        p=7; q=2;
    elseif abs(4.5-Lf/Rf)<0.225
        p=9; q=2;
    elseif abs(5-Lf/Rf)<0.25
        p=5; q=1;
    else
        [p,q]=rat(Lf/Rf);
    end
else
    if abs(1.5-Rf/Lf)<0.075
        q=3; p=2;
    elseif abs(2-Rf/Lf)<0.1
        q=2; p=1;
    elseif abs(2.5-Rf/Lf)<0.125
        q=5; p=2;
    elseif abs(3-Rf/Lf)<0.15
        q=3; p=1;
    elseif abs(3.5-Rf/Lf)<0.175
        q=7; p=2;
    elseif abs(4-Rf/Lf)<0.2
        q=7; p=2;
    elseif abs(4.5-Rf/Lf)<0.225
        q=9; p=2;
    elseif abs(5-Rf/Lf)<0.25
        q=5; p=1;
    else
        [q,p]=rat(Rf/Lf);
    end    
end
end


function [p,q] = get_p_q_MI(ls)
best_pq = find_best_pq(ls);
p=best_pq(2);
q=best_pq(3);
end


function SlowPxx = get_SlowPxx(ls)
if ls.Lf_ > ls.Rf_
    SlowPxx=ls.RPxx_;
else
    SlowPxx=ls.LPxx_;
end
end

function FastPxx = get_FastPxx(ls)
if ls.Lf_ > ls.Rf_
    FastPxx=ls.LPxx_;
else
    FastPxx=ls.RPxx_;
end
end

function SlowPxx_t = get_SlowPxx_t(ls)
SlowPxx_t = ls.get_scaled_PSD(ls.SlowPxx_,ls.freq_,ls.rho_);
end

function FastPxx_t = get_FastPxx_t(ls)
FastPxx=ls.FastPxx_;
FastPxx_t = FastPxx / ls.freq(FastPxx==max(FastPxx));
end




function minPeakDelay = get_minPeakDelay(ts)
Rpeaks=ts.Rpeaks;
Lpeaks=ts.Lpeaks;
Rlen = length(Rpeaks)-1;  %Extreme are always zeros!
Llen = length(Lpeaks)-1;
if Llen<Rlen
    q=round(Rlen/Llen);
    minPeakDelay=zeros(Llen,1);
    for i=1:Llen
        L=Lpeaks(i);
        if q==1
            if i==1
                R=Rpeaks(1:i+1);
            else
                R=Rpeaks(i-1:i+1);
            end
        elseif (i*(q-1))<1
            R=Rpeaks(1:i*(q+1));
        elseif (i*(q+1))>Rlen
            R=Rpeaks(i*(q-1):Rlen);
        else
            R=Rpeaks(i*(q-1):i*(q+1));
        end
        abs(L-R);
        [d,j]=min(abs(L-R));
        minPeakDelay(i)=d*sign(L-R(j))/1000;
    end
else
    q=round(Llen/Rlen);
    minPeakDelay=zeros(Rlen,1);
    for i=1:Rlen
        R=Rpeaks(i);
        if q==1
            if i==1
                L=Lpeaks(1:i+1);
            else
                L=Lpeaks(i-1:i+1);
            end
        elseif (i*(q-1))<1
            L=Lpeaks(1:i*(q+1));
        elseif (i*(q+1))>Llen
            L=Lpeaks(i*(q-1):Llen);
        else
            L=Lpeaks(i*(q-1):i*(q+1));
        end
        [d,j]=min(abs(R-L));
        minPeakDelay(i)=d*sign(L(j)-R);
    end
end
minPeakDelay=minPeakDelay/1000;
end

function minPeakDelayNorm = get_minPeakDelayNorm(ls,ts)
Rpeaks=ts.Rpeaks;
Lpeaks=ts.Lpeaks;
if length(Lpeaks)<length(Rpeaks)
    MT=diff(Lpeaks)/1000;
else
    MT=diff(Rpeaks)/1000;
end
minPeakDelayNorm=ls.minPeakDelay_./MT;
end




