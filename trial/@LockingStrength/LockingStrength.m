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
          Rx=obj.ts.Rxnorm;
          Lx=obj.ts.Lxnorm;
          Lv=obj.ts.Lvnorm;
          Rv=obj.ts.Rvnorm;
          z=zeros(size(Lx));
          l=[Lx,Lv,z,z];
          r=[z,z,Rx,Rv];
          d4D=sqrt( (l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2 + (l(:,3)-r(:,3)).^2 + (l(:,4)-r(:,4)).^2);
          %d4D=d4D-mean(d4D);
      end
      
      function d3D = get.d3D(obj)
          Rx=obj.ts.Rxnorm;
          Lx=obj.ts.Lxnorm;
          Lv=obj.ts.Lvnorm;
          Rv=obj.ts.Rvnorm;
          z=zeros(size(Lx));          
          l=[Lx,Lv,z];
          r=[Rx,z,Rv];
          d3D=sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2 + (l(:,3)-r(:,3)).^2);
          %d3D=d3D-mean(d3D);
      end
      
      function d2D = get.d2D(obj)
        Lx=obj.ts.Lxnorm;
        Rx=obj.ts.Rxnorm;
        z=zeros(size(Lx));
        l=[Lx,z];
        r=[z,Rx];
        d2D=sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2);
        %d2D=d2D-mean(d2D);
        %d2D=zeros(length(obj.ts.Lph),1);
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
          [p,~]=obj.get_p_q();
      end

      function q = get.q(obj)
          [~,q]=obj.get_p_q();
      end
      function [p,q]=get_p_q(obj)
          Lf=obj.Lf;
          Rf=obj.Rf;
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
      
      function minPeakDelayNorm = get.minPeakDelayNorm(obj)
          Rpeaks=obj.ts.Rpeaks;
          Lpeaks=obj.ts.Lpeaks;
          if length(Lpeaks)<length(Rpeaks)
              MT=diff(Lpeaks)/1000;
          else
              MT=diff(Rpeaks)/1000;
          end
          minPeakDelayNorm=obj.minPeakDelay./MT;     
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
        
        
        
        
