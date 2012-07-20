classdef LockingStrength < handle
    properties
        conf
        ts
    end % properties
    
    properties (Dependent = true, SetAccess = private)        
        flsPC
        flsAmp
        phDiff
        phDiffMean
        phDiffStd
        rho
        MI
        d4D
        d3D
        d2D
        d1D
        Lph
        Rph
        Lf
        Rf
        LPxx
        RPxx
        freq
        SlowPxx
        FastPxx
        SlowPxx_t
        FastPxx_t
        p
        q
        p_MI
        q_MI
        minPeakDelayNorm
        minPeakDelay
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
            %N=sqrt( (obj.rho^2+1) / ((obj.rho+1)*8) );
            N=sqrt(1+obj.rho^2)*(1/obj.rho+1)*sqrt(1/8);
            %N=sqrt( (obj.rho^2+1) / ((obj.rho+1)*8) );
            flsPC = 2*N * trapz(obj.freq,obj.SlowPxx_t.*obj.FastPxx) / trapz(obj.freq,obj.SlowPxx_t.^2+obj.FastPxx.^2);
        end
        
        function flsAmp = get.flsAmp(obj)
            %Compute FLS Amplitude
            %with formula from Huys et al. (2004), HMS
            %N=sqrt( (obj.rho^2+1) / ((obj.rho+1)*8) );
            N=sqrt(1+obj.rho^2)*(1/obj.rho+1)*sqrt(1/8);
            flsAmp = 2*N * trapz(obj.freq,obj.FastPxx_t.*obj.SlowPxx_t) / trapz(obj.freq,obj.FastPxx_t.^2+obj.SlowPxx_t.^2);
        end
        
        function phDiff = get.phDiff(obj)
            %phDiff = obj.q*obj.Lph-obj.p*obj.Rph;
            phDiff= obj.q*obj.Lph-obj.p*obj.Rph;
        end
        
        function phDiffMean = get.phDiffMean(obj)
            %[phDiffMean,~]=circstat(obj.p_MI*obj.Lph-obj.q_MI*obj.Rph);
            [phDiffMean,~]=circstat(obj.phDiff);
        end
        
        function phDiffStd = get.phDiffStd(obj)
            %[~, phDiffStd]=circstat(obj.p_MI*obj.Lph-obj.q_MI*obj.Rph);
            [~, phDiffStd]=circstat(obj.phDiff);
        end
        
        function rho = get.rho(obj)
            q=obj.q; p=obj.p;
            if q>p
                rho=q/p;
            else
                rho=p/q;
            end
        end

        function MI = get.MI(obj)
            %Get Kulback-Leiber distance between phase difference and uniform distribution
            [MI,~]=Kulback_Leibler_distance(obj.Lph*obj.q-obj.Rph*obj.p,obj.conf.KLD_bins);
        end
        
      function d4D = get.d4D(obj)
        z=zeros(length(obj.ts.Lxnorm),1);
        l=[obj.ts.Lxnorm,obj.ts.Lvnorm,z,z];    
        r=[z,z,obj.ts.Rxnorm,obj.ts.Rvnorm];
        d4D=sqrt( (l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2 + (l(:,3)-r(:,3)).^2 + (l(:,4)-r(:,4)).^2);
        d4D=d4D-mean(d4D);
      end
      
      function d3D = get.d3D(obj)
        l=[obj.ts.Lxnorm,obj.ts.Lvnorm,zeros(length(obj.ts.Lxnorm),1)];    
        r=[obj.ts.Rxnorm,zeros(length(obj.ts.Rxnorm),1),obj.ts.Rvnorm];
        d3D=sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2 + (l(:,3)-r(:,3)).^2);
        d3D=d3D-mean(d3D);
      end
      
      function d2D = get.d2D(obj)
        %z=zeros(length(ts.Lph),1);
        %l=[tr.ts.Lph*tr.ls.q,z];
        %r=[z,tr.ts.Rph*tr.ls.p];
        %d2D=sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2);
        %d2D=d2D-mean(d2D);
        d2D=zeros(length(obj.ts.Lph),1);
      end
      
      function d1D = get.d1D(obj)
          d1D=obj.phDiff;
      end

      function Rph = get.Rph(obj)
        Rph=obj.ts.Rph;
      end
      
      function Lph = get.Lph(obj)
        Lph=obj.ts.Lph;
      end

      function Rf = get.Rf(obj)
        Rf=obj.ts.Rf;
      end
      
      function Lf = get.Lf(obj)
        Lf=obj.ts.Lf;
      end
      
      function RPxx = get.RPxx(obj)
        RPxx=obj.ts.RPxx;
      end
      
      function LPxx = get.LPxx(obj)
        LPxx=obj.ts.LPxx;
      end      
      
      function freq = get.freq(obj)
        freq=obj.ts.freq;
      end

      function p = get.p(obj)
        [p,~]=rat(obj.Lf/obj.Rf);
      end

      function q = get.q(obj)
        [~,q]=rat(obj.Lf/obj.Rf);
      end
      
      function SlowPxx = get.SlowPxx(obj)
          if obj.Lf > obj.Rf
              SlowPxx=obj.RPxx;
          else
              SlowPxx=obj.LPxx;
          end
      end
      
      function FastPxx = get.FastPxx(obj)
          if obj.Lf > obj.Rf
              FastPxx=obj.LPxx;
          else
              FastPxx=obj.RPxx;
          end
      end
      
      function SlowPxx_t = get.SlowPxx_t(obj)
        SlowPxx_t = obj.get_scaled_PSD(obj.SlowPxx,obj.freq,obj.rho);
      end      
      
      function FastPxx_t = get.FastPxx_t(obj)
        FastPxx=obj.FastPxx;
        FastPxx_t = FastPxx / obj.freq(FastPxx==max(FastPxx)); 
      end      
      
      
      function p_MI = get.p_MI(obj)
        best_pq = find_best_pq(obj);
        p_MI=best_pq(2);
      end
      
      function q_MI = get.q_MI(obj)
        best_pq = find_best_pq(obj);
        q_MI=best_pq(3);
      end      
      
      function minPeakDelay = get.minPeakDelay(obj)
          Rpeaks=obj.ts.Rpeaks;
          Lpeaks=obj.ts.Lpeaks;
          Rlen = length(Rpeaks)-1;  %Extreme are always zeros!
          Llen = length(Lpeaks)-1;  
          if Llen<Rlen
              q=round(Rlen/Llen);
              minPeakDelay=zeros(Llen-1,1);              
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
                  minPeakDelay(i)=d*sign(L-R(j));
              end
          else
              q=round(Llen/Rlen);
              minPeakDelay=zeros(Rlen-1,1);
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
      end
      
      function minPeakDelayNorm = get.minPeakDelayNorm(obj)
          Rpeaks=obj.ts.Rpeaks;
          Lpeaks=obj.ts.Lpeaks;
          Rlen = length(Rpeaks)-1;  %Extreme are always zeros!
          Llen = length(Lpeaks)-1;  
          if Llen<Rlen
              q=round(Rlen/Llen);
              minPeakDelayNorm=zeros(Llen-1,1);              
              for i=2:Llen
                  L=Lpeaks(i);
                  if q==1
                      R=Rpeaks(i-1:i+1);
                  elseif (i*(q-1))<1
                      R=Rpeaks(1:i*(q+1));                     
                  elseif (i*(q+1))>Rlen
                      R=Rpeaks(i*(q-1):Rlen);
                  else
                      R=Rpeaks(i*(q-1):i*(q+1));
                  end
                  omega=obj.ts.Lomega(i);
                  [d,j]=min(abs(L-R)/omega);
                  minPeakDelayNorm(i-1)=d*sign(L-R(j));
              end
          else
              q=round(Llen/Rlen);
              minPeakDelayNorm=zeros(Rlen-1,1);
              for i=2:Rlen
                  R=Rpeaks(i);
                  if q==1
                      L=Lpeaks(i-1:i+1);
                  elseif (i*(q-1))<1
                      L=Lpeaks(1:i*(q+1));
                  elseif (i*(q+1))>Llen
                      L=Lpeaks(i*(q-1):Llen);
                  else
                      L=Lpeaks(i*(q-1):i*(q+1));
                  end
                  omega=obj.ts.Romega(i);
                  [d,j]=min(abs(R-L)/omega);
                  minPeakDelayNorm(i-1)=d*sign(L(j)-R);
              end
          end          
      end      
      
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function ls = LockingStrength(ts,conf)
            ls.conf=conf;
            ls.ts=ts;    
        end
        
        function update_conf(obj,conf)
            obj.conf=conf;
        end
        
    end

    methods(Static=true)
        Pxx_t = get_scaled_PSD(Pxx,f,rho)
        function anova_var = get_anova_variables()
            anova_var = { 'MI' 'rho' 'flsPC' 'flsAmp' 'phDiffMean' 'phDiffStd' 'd4D' 'd3D' 'd2D' 'd1D' 'minPeakDelay' 'minPeakDelayNorm'};
        end
    end
end
        
        
        
        
