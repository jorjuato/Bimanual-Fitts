classdef TimeSeriesBimanual < handle
    properties
        conf
        info
    end % properties
    
    properties (Dependent = true, SetAccess = private)
        Lxraw
        Lvraw
        Laraw
        Lx
        Lv
        La
        Lxnorm
        Lvnorm
        Lanorm
        Ljerk
        Ljerknorm
        Lph
        Lomega
        Lamp
        Lpeaks
        LID
        LIDef
        Rxraw
        Rvraw
        Raraw
        Rx
        Rv
        Ra
        Rjerk
        Rxnorm
        Rvnorm
        Ranorm
        Rjerknorm
        Rph
        Romega
        Ramp
        Rpeaks
        RID
        RIDef
        idx
        LHarmonicity
        RHarmonicity
        LCircularity
        RCircularity
        LSpecgram
        RSpecgram
        minPeakDistance
        minPeakDistanceNorm
        d4D
        d3D
        d2D
    end
    
    properties (SetAccess = private, Hidden)
        Lxraw_
        Lvraw_
        Laraw_
        Rxraw_
        Rvraw_
        Raraw_
    end
        
    methods
        %Properties getters and setter

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compressed Raw data retrieval
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function Lxraw = get.Lxraw(obj)
            if obj.conf.compress_ts==1
                Lxraw = dunzip(obj.Lxraw_);
            else
                Lxraw = obj.Lxraw_;
            end
        end
        
        function Lvraw = get.Lvraw(obj)
            if obj.conf.compress_ts==1
                Lvraw = dunzip(obj.Lvraw_);
            else
                Lvraw = obj.Lvraw_;
            end
        end
                
        function Laraw = get.Laraw(obj)
            if obj.conf.compress_ts==1
                Laraw = dunzip(obj.Laraw_);
            else
                Laraw = obj.Laraw_;
            end
        end
        
        function Rxraw = get.Rxraw(obj)
            if obj.conf.compress_ts==1
                Rxraw = dunzip(obj.Rxraw_);
            else
                Rxraw = obj.Rxraw_;
            end
        end
        
        function Rvraw = get.Rvraw(obj)
            if obj.conf.compress_ts==1
                Rvraw = dunzip(obj.Rvraw_);
            else
                Rvraw = obj.Rvraw_;
            end
        end
        
        function Raraw = get.Raraw(obj)
            if obj.conf.compress_ts==1
                Raraw = dunzip(obj.Raraw_);
            else
                Raraw = obj.Raraw_;
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compressed Raw data storage
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function set.Lxraw(obj,value)
            if obj.conf.compress_ts==1
                obj.Lxraw_ = dzip(value);
            else
                obj.Lxraw_ = value;
            end
        end   
        
        function set.Lvraw(obj,value)
            if obj.conf.compress_ts==1
                obj.Lvraw_ = dzip(value);
            else
                obj.Lvraw_ = value;
            end
        end
        
        function set.Laraw(obj,value)
            if obj.conf.compress_ts==1
                obj.Laraw_ = dzip(value);
            else
                obj.Laraw_ = value;
            end
        end
        
        function set.Rxraw(obj,value)
            if obj.conf.compress_ts==1
                obj.Rxraw_ = dzip(value);
            else
                obj.Rxraw_ = value;
            end
        end
        
        function set.Rvraw(obj,value)
            if obj.conf.compress_ts==1
                obj.Rvraw_ = dzip(value);
            else
                obj.Rvraw_ = value;
            end
        end
        
        function set.Raraw(obj,value)
            if obj.conf.compress_ts==1
                obj.Raraw_ = dzip(value);
            else
                obj.Raraw_ = value;
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compressed Raw data storage
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function Lx = get.Lx(obj)
            x=obj.Lxraw;
            Lx = filterdata(x(obj.idx),obj.conf.cutoff);
        end
        
        function Lv = get.Lv(obj)
            Lv = filterdata(obj.Lvraw(obj.idx),obj.conf.cutoff);
        end
        
        function La = get.La(obj)
            La = filterdata(obj.Laraw(obj.idx),obj.conf.cutoff);
        end
        
        function Ljerk = get.Ljerk(obj)
            Ljerk = [0;diff(obj.La)]*obj.conf.fs;
        end
        
        function Rx = get.Rx(obj)
            Rx = filterdata(obj.Rxraw(obj.idx),obj.conf.cutoff);
        end
        
        function Rv = get.Rv(obj)
            Rv = filterdata(obj.Rvraw(obj.idx),obj.conf.cutoff);
        end
        
        function Ra = get.Ra(obj)
            Ra = filterdata(obj.Raraw(obj.idx),obj.conf.cutoff);
        end
        
        function Rjerk = get.Rjerk(obj)
            Rjerk = [0;diff(obj.Ra)]*obj.conf.fs;
        end
        
        function Lxnorm = get.Lxnorm(obj)
            Lxnorm = obj.Lx/max(abs(obj.Lx));
        end
        
        function Lvnorm = get.Lvnorm(obj)
            Lvnorm = obj.Lv/max(abs(obj.Lv));
        end
        
        function Lanorm = get.Lanorm(obj)
            Lanorm = obj.La/max(abs(obj.La));
        end
        
        function Ljerknorm = get.Ljerknorm(obj)
            Ljerknorm = obj.Ljerk/max(abs(obj.Ljerk));
        end
        
        function Rxnorm = get.Rxnorm(obj)   
            Rxnorm = obj.Rx/max(abs(obj.Rx));
        end
        
        function Rvnorm = get.Rvnorm(obj)
            Rvnorm = obj.Rv/max(abs(obj.Rv));
        end
        
        function Ranorm = get.Ranorm(obj)
            Ranorm = obj.Ra/max(abs(obj.Ra));
        end
        
        function Rjerknorm = get.Rjerknorm(obj)
            Rjerknorm = obj.Rjerk ./ max(abs(obj.Rjerk));
        end
        
        function Rph = get.Rph(obj)
            Rph = filterdata(unwrap(angle(hilbert(obj.Rx))),obj.conf.cutoff);
        end
        
        function Lph = get.Lph(obj)
            Lph = filterdata(unwrap(angle(hilbert(obj.Lx))),obj.conf.cutoff);
        end
        
        function Romega = get.Romega(obj)
            %Romega = filterdata(diff(obj.Rph)*1000,obj.conf.cutoff);
            %Romega = diff(filterdata(obj.Rph,obj.conf.cutoff)*1000);
            Romega = diff(obj.Rph*1000);
            Romega(end+1)=Romega(end);
        end
        
        function Lomega = get.Lomega(obj)
            %Lomega = filterdata(diff(obj.Lph)*1000,obj.conf.cutoff);
            Lomega = diff(obj.Lph*1000);
            %Lomega = diff(filterdata(obj.Lph,obj.conf.cutoff)*1000);
            Lomega(end+1)=Lomega(end);
        end
        
        function Ramp = get.Ramp(obj)
            Ramp = abs(hilbert(obj.Rx));
        end
        
        function Lamp = get.Lamp(obj)
            Lamp = abs(hilbert(obj.Lx));
        end
        
        function Lpeaks = get.Lpeaks(obj)
            [maxPeaks, minPeaks] = peakdet(obj.Lx, obj.conf.peak_size);
            Lpeaks = sort([1;maxPeaks(:,1);minPeaks(:,1);length(obj.Lx)]);
            %Lpeaks = sort([1;maxPeaks(:,1);minPeaks(:,1)]);
        end
        
        function Rpeaks = get.Rpeaks(obj)            
            [maxPeaks, minPeaks] = peakdet(obj.Rx, obj.conf.peak_size);
            Rpeaks = sort([1;maxPeaks(:,1);minPeaks(:,1);length(obj.Rx)]);
            %Rpeaks = sort([1;maxPeaks(:,1);minPeaks(:,1)]);
        end
        
        function idx = get.idx(obj)
            %Skip first 'skiposc' oscillations from the slowest one
            if obj.conf.skip_osc == 0
                sk=obj.info.skipOsc;                
            else
                sk=obj.conf.skip_osc;
            end
            [maxRPeaks, minRPeaks] = peakdet(obj.Rxraw, obj.conf.peak_size);
            Rpeaks = sort([maxRPeaks(:,1);minRPeaks(:,1)]);
            [maxLPeaks, minLPeaks] = peakdet(obj.Lxraw, obj.conf.peak_size);
            Lpeaks = sort([maxLPeaks(:,1);minLPeaks(:,1)]);
            if length(Lpeaks) < length(Rpeaks)
                idx=Lpeaks(sk,1):Lpeaks(end,1);
            else
                idx=Rpeaks(sk,1):Rpeaks(end,1);
            end
        end
        
      function LIDef = get.LIDef(obj)
          %Formula from McKenzie 1992
          %endpts = abs(x(peaks));
          %Wef = std(endpts)*4.133; 
          %IDef = log2(2*A/Wef);
          LIDef = log2(2*obj.info.A/(std(abs(obj.Lx(obj.Lpeaks)))*4.133));
      end
      
      function RIDef = get.RIDef(obj)
          %Formula from McKenzie 1992
          %endpts = abs(x(peaks));
          %Wef = std(endpts)*4.133; 
          %IDef = log2(2*A/Wef);
          RIDef = log2(2*obj.info.A/(std(abs(obj.Rx(obj.Rpeaks)))*4.133));
      end
      
      function LID = get.LID(obj)
          LID = obj.info.LID;
      end           
      
      function RID = get.RID(obj)
          RID = obj.info.RID;
      end  
      
      function LHarmonicity = get.LHarmonicity(obj)
          LHarmonicity = harmonicity_index(obj,'L');
      end 
      
      function RHarmonicity = get.RHarmonicity(obj)
          RHarmonicity = harmonicity_index(obj,'R');
      end
      
      function RCircularity = get.RCircularity(obj)
          %This method imposes a circle of R=1 and center=(0,0)
          [~,modulus] = cart2pol(obj.Rxnorm,obj.Rvnorm);
          RCircularity = nanmean(modulus);
      end
      
      function LCircularity = get.LCircularity(obj)
          %This method imposes a circle of R=1 and center=(0,0)
          [~,modulus] = cart2pol(obj.Lxnorm,obj.Lvnorm);
          LCircularity = nanmean(modulus);
      end
      
      function minPeakDistance = get.minPeakDistance(ts)
          Rpeaks=ts.Rpeaks;
          Lpeaks=ts.Lpeaks;
          Rlen = length(Rpeaks)-1;  %Extreme are always zeros!
          Llen = length(Lpeaks)-1;  
          if Llen<Rlen
              q=round(Rlen/Llen);
              minPeakDistance=zeros(Llen-1,1);              
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
                  abs(L-R);
                  [d,j]=min(abs(L-R));
                  minPeakDistance(i-1)=d*sign(L-R(j));
              end
          else
              q=round(Llen/Rlen);
              minPeakDistance=zeros(Rlen-1,1);
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
                  [d,j]=min(abs(R-L));
                  minPeakDistance(i-1)=d*sign(L(j)-R);
              end
          end          
      end
      
      function minPeakDistanceNorm = get.minPeakDistanceNorm(ts)
          Rpeaks=ts.Rpeaks;
          Lpeaks=ts.Lpeaks;
          Rlen = length(Rpeaks)-1;  %Extreme are always zeros!
          Llen = length(Lpeaks)-1;  
          if Llen<Rlen
              q=round(Rlen/Llen);
              minPeakDistanceNorm=zeros(Llen-1,1);              
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
                  omega=ts.Lomega(i);
                  [d,j]=min(abs(L-R)/omega);
                  minPeakDistanceNorm(i-1)=d*sign(L-R(j));
              end
          else
              q=round(Llen/Rlen);
              minPeakDistanceNorm=zeros(Rlen-1,1);
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
                  omega=ts.Romega(i);
                  [d,j]=min(abs(R-L)/omega);
                  minPeakDistanceNorm(i-1)=d*sign(L(j)-R);
              end
          end          
      end          
      
      function d4D = get.d4D(ts)
        z=zeros(length(ts.Lxnorm),1);
        l=[ts.Lxnorm,ts.Lvnorm,z,z];    
        r=[z,z,ts.Rxnorm,ts.Rvnorm];
        d4D=sqrt( (l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2 + (l(:,3)-r(:,3)).^2 + (l(:,4)-r(:,4)).^2);
        d4D=d4D-mean(d4D);
      end
      
      function d3D = get.d3D(ts)
        l=[ts.Lxnorm,ts.Lvnorm,zeros(length(ts.Lxnorm),1)];    
        r=[ts.Rxnorm,zeros(length(ts.Rxnorm),1),ts.Rvnorm];
        d3D=sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2 + (l(:,3)-r(:,3)).^2);
        d3D=d3D-mean(d3D);
      end
      
      function d2D = get.d2D(ts)
        %z=zeros(length(ts.Lph),1);
        %l=[tr.ts.Lph*tr.ls.q,z];
        %r=[z,tr.ts.Rph*tr.ls.p];
        %d2D=sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2);
        %d2D=d2D-mean(d2D);
        d2D=zeros(length(ts.Lph),1);
      end      
      
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function ts = TimeSeriesBimanual(data,info,conf)
            ts.conf=conf;
            ts.info=info;
            
            %Compute left hand trial kinematic data
            ts.Lxraw = (data.Left_L2Ang-data.Left_L1Ang)*info.scale + info.offset-info.origin;
            ts.Lvraw = (data.Left_L2Vel-data.Left_L1Vel)*info.scale;
            ts.Laraw = (data.Left_L2Acc-data.Left_L1Acc)*info.scale;
            
            %Compute right hand trial kinematic data
            ts.Rxraw = (pi/4-(data.Right_L2Ang-data.Right_L1Ang))*info.scale + info.offset -info.origin - 0.095;
            ts.Rvraw = (-(data.Right_L2Vel-data.Right_L1Vel))*info.scale;
            ts.Raraw = (-(data.Right_L2Acc-data.Right_L1Acc))*info.scale;
        end
        
        function update_conf(obj,conf)
            obj.conf=conf;
        end
            
        plot(obj,graphPath,rootname,ext)
        
        [fcns, names, xlabels, ylabels] = get_plots(obj)
        
        concatenate(obj,obj2)
        
    end % methods
    
    methods(Static=true)  
        function anova_var = get_anova_variables()
            anova_var = { 'Harmonicity' 'Circularity' ...
                          'minPeakDistance' 'minPeakDistanceNorm'};
        end        
    end
end% classdef
