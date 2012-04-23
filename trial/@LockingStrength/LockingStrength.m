classdef LockingStrength
    properties
        freqs
        Lf
        Rf
        Rph
        Lph
        LPxx
        LPxx_t
        RPxx
        RPxx_t
        p
        q
        peak_delta=2;
        conf
    end % properties
    
    properties (Dependent = true, SetAccess = private)
        flsPC
        flsAmp
        phDiffMean
        phDiffStd
        rho
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
            flsPC = N * trapz(obj.freqs,obj.RPxx_t.*obj.LPxx) / trapz(obj.freqs,obj.RPxx_t.^2+obj.LPxx.^2);
        end
        
        function flsAmp = get.flsAmp(obj)
            %Compute FLS Amplitude
            %with formula from Huys et al. (2004), HMS
            N=sqrt( (obj.rho^2+1) / ((obj.rho+1)*8) );
            flsAmp = N * trapz(obj.freqs,obj.RPxx_t.*obj.LPxx_t) / trapz(obj.freqs,obj.RPxx_t.^2+obj.LPxx_t.^2);
        end
        
        function phDiffMean = get.phDiffMean(obj)
            [phDiffMean,~]=circstat(obj.p*obj.Rph-obj.q*obj.Lph);
        end
        
        function phDiffStd = get.phDiffStd(obj)
            %Get Kramers-Moyal coefficients
            [~, phDiffStd]=circstat(obj.p*obj.Rph-obj.q*obj.Lph);
        end
        
        function rho = get.rho(obj)
            if obj.q>obj.p
                rho=obj.q/obj.p;
            else
                rho=obj.p/obj.q;
            end
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
            ls.RPxx_t = ls.get_scaled_PSD(ls.RPxx,ls.freqs,ls.rho);
            
            %Normalize higher frequency signal to unit variance for FLS Amp
            ls.LPxx_t = ls.LPxx / ls.freqs(ls.LPxx==max(ls.LPxx)); 
    
        end   
        function update_conf(obj,conf)
            obj.conf=conf;
        end
        
        function update(obj)
            %Get locking ratio as (p,q) pair, choose ratios
            [obj.p, obj.q, obj.Lf, obj.Rf]=obj.get_locking_ratio(obj.LPxx,obj.RPxx,obj.freqs,obj.conf.peak_delta);
            
            %Rescale the low frequency signal to have a dominant freq equal to the fast
            obj.RPxx_t = obj.get_scaled_PSD(obj.RPxx,obj.freqs,obj.rho);
            
            %Normalize higher frequency signal to unit variance for FLS Amp
            obj.LPxx_t = obj.LPxx / obj.freqs(obj.LPxx==max(obj.LPxx)); 
        end
    end

    methods(Static=true)
        RPxx_t = get_scaled_PSD(RPxx,f,rho)
        [p, q, Lf, Rf] = get_locking_ratio(LPxx,RPxx,freqs,peak_delta)
        [Pxx, f] = get_welch_periodogram(x)
        function anova_var = get_anova_variables()
            anova_var = { 'Lf' 'Rf' 'rho' 'flsPC' 'flsAmp' 'phDiffMean' 'phDiffStd'};
        end
    end
end
        
        
        
        
