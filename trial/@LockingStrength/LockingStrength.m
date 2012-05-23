classdef LockingStrength
    properties
        freqs
        Lf
        Rf
        Rph
        Lph
        LPxx
        RPxx
        SlowPxx
        FastPxx
        SlowPxx_t
        FastPxx_t
        p
        q
        conf
    end % properties
    
    properties (Dependent = true, SetAccess = private)
        flsPC
        flsAmp
        phDiffMean
        phDiffStd
        rho
        MI
    end

   %%%%%%%%%%%%%%%%%%
   % Public methods
   %%%%%%%%%%%%%%%%%%      
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Prototypes of Public methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot(obj,graphPath,rootname,ext)
        disp(obj)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Properties getters and setter
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function flsPC = get.flsPC(obj)
            %Compute FLS Pure Coordination
            %with formula from Huys et al. (2004), HMS
            N=sqrt( (obj.rho^2+1) ./ ((obj.rho+1)*8) );
            flsPC = N * trapz(obj.freqs,obj.SlowPxx_t.*obj.FastPxx) / trapz(obj.freqs,obj.SlowPxx_t.^2+obj.FastPxx.^2);
        end
        
        function flsAmp = get.flsAmp(obj)
            %Compute FLS Amplitude
            %with formula from Huys et al. (2004), HMS
            N=sqrt( (obj.rho^2+1) / ((obj.rho+1)*8) );
            flsAmp = N * trapz(obj.freqs,obj.FastPxx_t.*obj.SlowPxx_t) / trapz(obj.freqs,obj.FastPxx_t.^2+obj.SlowPxx_t.^2);
        end
        
        function phDiffMean = get.phDiffMean(obj)
            [phDiffMean,~]=circstat(obj.p*obj.Lph-obj.q*obj.Rph);
        end
        
        function phDiffStd = get.phDiffStd(obj)
            %Get Kramers-Moyal coefficients
            [~, phDiffStd]=circstat(obj.p*obj.Lph-obj.q*obj.Rph);
        end
        
        function rho = get.rho(obj)
            if obj.q>obj.p
                rho=obj.q/obj.p;
            else
                rho=obj.p/obj.q;
            end
        end

        function MI = get.MI(obj)
            %Get Kulback-Leiber distance between phase difference and uniform distribution
            [MI,~]=Kulback_Leibler_distance(obj.Lph*obj.q/obj.p-obj.Rph,obj.conf.KLD_bins);
        end        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function ls = LockingStrength(ts,conf)
            ls.conf=conf;
            %_Instantiate local variables from trial structure
            ls.Lph=ts.Lph;
            ls.Rph=ts.Rph;
            
            %Compute periodograms
            [ls.LPxx,~] = ls.get_welch_periodogram(ts.Lxnorm);
            [ls.RPxx,ls.freqs] = ls.get_welch_periodogram(ts.Rxnorm);
            
            %Get locking ratio as (p,q) pair, choose ratios
            %bigger than 1 and change arrays names acordingly
            [ls.p, ls.q, ls.Lf, ls.Rf]=ls.get_locking_ratio(ls.LPxx,ls.RPxx,ls.freqs,ls.conf.peak_delta);
            
            %Rescale the low frequency signal to have a dominant freq equal to the fast
            if ls.Lf > ls.Rf
                ls.SlowPxx=ls.RPxx;
                ls.FastPxx=ls.LPxx;
            else
                ls.SlowPxx=ls.LPxx;
                ls.FastPxx=ls.RPxx;
            end
            ls.SlowPxx_t = ls.get_scaled_PSD(ls.SlowPxx,ls.freqs,ls.rho);
            
            %Normalize higher frequency signal to unit variance for FLS Amp
            ls.FastPxx_t = ls.FastPxx / ls.freqs(ls.FastPxx==max(ls.FastPxx)); 
        
    
        end   
        function update_conf(obj,conf)
            obj.conf=conf;
        end
        
        function obj = update(obj)
            %Get locking ratio as (p,q) pair, choose ratios
            [obj.p, obj.q, obj.Lf, obj.Rf]=obj.get_locking_ratio(obj.LPxx,obj.RPxx,obj.freqs,obj.conf.peak_delta);
            
            %Rescale the low frequency signal to have a dominant freq equal to the fast
            if obj.Lf > obj.Rftr
                obj.SlowPxx=obj.RPxx;
                obj.FastPxx=obj.LPxx;
            else
                obj.SlowPxx=obj.LPxx;
                obj.FastPxx=obj.RPxx;
            end
            %Rescale the low frequency signal to have a dominant freq equal to the fast
            obj.SlowPxx_t = obj.get_scaled_PSD(obj.SlowPxx,obj.freqs,obj.rho);
            
            %Normalize higher frequency signal to unit variance for FLS Amp
            obj.FastPxx_t = obj.FastPxx / obj.freqs(obj.FastPxx==max(obj.FastPxx)); 
        end
    end

    methods(Static=true)
        Pxx_t = get_scaled_PSD(Pxx,f,rho)
        [p, q, Lf, Rf] = get_locking_ratio(LPxx,RPxx,freqs,peak_delta)
        [Pxx, f] = get_welch_periodogram(x)
        function anova_var = get_anova_variables()
            anova_var = { 'MI' 'Lf' 'Rf' 'rho' 'flsPC' 'flsAmp' 'phDiffMean' 'phDiffStd'};
        end
    end
end
        
        
        
        
