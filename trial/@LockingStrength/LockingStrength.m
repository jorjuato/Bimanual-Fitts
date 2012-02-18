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
        peak_delta=3;
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
        plot(obj)
        disp(obj)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Properties getters and setter
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function flsPC = get.flsPC(obj)
            %Compute FLS Pure Coordination
            %with formula from Huys et al. (2004), HMS
            N=sqrt( (obj.rho.^2+1) ./ ((obj.rho+1)*8) );
            flsPC = N * trapz(obj.freqs,obj.RPxx_t.*obj.LPxx) / trapz(obj.freqs,obj.RPxx_t.^2+obj.LPxx.^2);
        end
        
        function flsAmp = get.flsAmp(obj)
            %Compute FLS Amplitude
            %with formula from Huys et al. (2004), HMS
            N=sqrt( (obj.rho.^2+1) ./ ((obj.rho+1)*8) );
            flsAmp = N * trapz(obj.freqs,obj.RPxx_t.*obj.LPxx_t) / trapz(obj.freqs,obj.RPxx_t.^2+obj.LPxx_t.^2);
        end
        
        function phDiffMean = get.phDiffMean(obj)
            [phDiffMean,~]=circstat(obj.q.*obj.Rph-obj.p.*obj.Lph);
        end
        
        function phDiffStd = get.phDiffStd(obj)
            %Get Kramers-Moyal coefficients
            phDiffStd=circstat(obj.q.*obj.Rph-obj.p.*obj.Lph);
        end
        
        function rho = get.rho(obj)
            rho = obj.p./obj.q;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function ls = LockingStrength(ts)
            %_Instantiate local variables from trial structure
            Lx=ts.Lxnorm;
            Rx=ts.Rxnorm;
            ls.Lph=ts.Lph;
            ls.Rph=ts.Rph;
            
            %Compute periodograms
            [ls.LPxx,~] = ls.get_welch_periodogram(Lx);
            [ls.RPxx,ls.freqs] = ls.get_welch_periodogram(Rx);
            
            %Get locking ratio as (p,q) pair, choose ratios
            %bigger than 1 and change arrays names acordingly
            [ls.p, ls.q, ls.Lf, ls.Rf]=ls.get_locking_ratio(ls.LPxx,ls.RPxx,ls.freqs,ls.peak_delta);
            %ls.p=p; ls.q=q; ls.Lf=Lf; ls.Rf=Rf;
            if ls.q>ls.p
                rho=ls.q/ls.p;
                tmp=ls.RPxx;
                ls.RPxx=ls.LPxx;
                ls.LPxx=tmp;
                tmp=ls.Rph;
                ls.Rph=ls.Lph;
                ls.Lph=tmp;
                tmp=ls.Rf;
                ls.Rf=ls.Lf;
                ls.Lf=tmp;
            else
                rho=ls.p/ls.q;
            end
            
            %Rescale the low frequency signal to have a dominant freq equal to the fast
            ls.RPxx_t = ls.get_scaled_PSD(ls.RPxx,ls.freqs,rho);
            
            %Normalize higher frequency signal to unit variance for FLS Amp
            [Lmax, ~] = peakdet(ls.LPxx,ls.peak_delta);
            if isempty(Lmax)
                ls.LPxx_t = ls.LPxx/max(ls.LPxx);
            else
                ls.LPxx_t = ls.LPxx / Lmax(2);
            end            
        end   
    end
    
    methods(Static)
        RPxx_t = get_scaled_PSD(RPxx,f,rho)
        [p, q, Lf, Rf] = get_locking_ratio(LPxx,RPxx,freqs,peak_delta)
        [Pxx, f] = get_welch_periodogram(x)
    end
end
