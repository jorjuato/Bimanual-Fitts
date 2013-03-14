classdef TimeSeriesUnimanual < handle
   properties     
      conf
      info
   end
   
   properties (Dependent = true, SetAccess = private)
      x
      v
      a
      jerk
      xraw
      vraw
      araw
      xnorm
      vnorm
      anorm
      jerknorm
      peaks
      idx
      ID
      IDef
      Harmonicity
      HarmonicityDown
      HarmonicityUp
      Circularity
      f
      Pxx
      freq
   end
   
    properties (SetAccess = private, Hidden)
        xraw_
        vraw_
        araw_
    end
   
   methods%Prototypes
      concatenate(obj,obj1)
      
      plot(obj,graphPath,rootname,ext)
      
      [fcns, names,xlabels,ylabels] = get_plots(obj) 
   end
   
   methods%Properties getters and setter
   
        function xraw = get.xraw(obj)
            if obj.conf.compress_ts==1
                xraw = dunzip(obj.xraw_);
            else
                xraw = obj.xraw_;
            end
        end
        
        function vraw = get.vraw(obj)
            if obj.conf.compress_ts==1
                vraw = dunzip(obj.vraw_);
            else
                vraw = obj.vraw_;
            end
        end
        
        function araw = get.araw(obj)
            if obj.conf.compress_ts==1
                araw = dunzip(obj.araw_);
            else
                araw = obj.araw_;
            end
        end
        
        function jerk = get.jerk(obj)
            jerk = [0;diff(obj.a)]*obj.conf.fs;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compressed Raw data storage
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function set.xraw(obj,value)
            if obj.conf.compress_ts==1
                obj.xraw_ = dzip(value);
            else
                obj.xraw_ = value;
            end
        end   
        
        function set.vraw(obj,value)
            if obj.conf.compress_ts==1
                obj.vraw_ = dzip(value);
            else
                obj.vraw_ = value;
            end
        end
        
        function set.araw(obj,value)
            if obj.conf.compress_ts==1
                obj.araw_ = dzip(value);
            else
                obj.araw_ = value;
            end
        end   
   
      function x = get.x(obj)
         x = filterdata(obj.xraw(obj.idx),obj.conf.cutoff);
      end
      
      function v = get.v(obj)
         v = filterdata(obj.vraw(obj.idx),obj.conf.cutoff);
      end
      
      function a = get.a(obj)
         a = filterdata(obj.araw(obj.idx),obj.conf.cutoff);
      end
      
      function xnorm = get.xnorm(obj)
         xnorm = obj.x/max(abs(obj.x));
      end
      
      function vnorm = get.vnorm(obj)
         vnorm = obj.v/max(abs(obj.v));
      end
      
      function anorm = get.anorm(obj)
         anorm = obj.a/max(abs(obj.a));
      end
      
      function jerknorm = get.jerknorm(obj)
            jerknorm = obj.jerk/max(abs(obj.jerk));
      end
      
      function peaks = get.peaks(obj)
          [maxPeaks, minPeaks] = peakdet(obj.x, obj.conf.peak_size);
          %peaks = sort([1;maxPeaks(:,1);minPeaks(:,1)]);
          peaks = sort([maxPeaks(:,1);minPeaks(:,1);length(obj.x)]);
      end
      
      function idx = get.idx(obj)
          [maxPeaks, minPeaks] = peakdet(obj.xraw, obj.conf.peak_size);
          peaks = sort([maxPeaks(:,1);minPeaks(:,1)]);
          %Skip first 'skiposc' oscillations
          if obj.conf.skip_osc == 0
              idx=peaks(obj.info.skipOsc,1):peaks(end,1);
          else
              idx=peaks(obj.conf.skip_osc,1):peaks(end,1);
          end
          
      end
      
      function IDef = get.IDef(obj)
          %Formula from McKenzie 1992
          %endpts = abs(x(peaks));
          %Wef = std(endpts)*4.133;
          %IDef = log2(2*A/Wef);
          IDef = log2(2*obj.info.A/(std(abs(obj.x(obj.peaks)))*4.133));
      end
      
      function ID = get.ID(obj)
          ID = obj.info.ID;
      end
      
      function Harmonicity = get.Harmonicity(obj)
          %Harmonicity = harmonicity_index(obj);
          x=obj.xnorm;
          %a=filterdata(obj.Lanorm,8);
          a=obj.anorm;
          xc=crossings(x);
          Harmonicity=zeros(length(xc)-1,1);
          for i=1:length(xc)-1
              [Harmonicity(i),~]=get_Harmonicity(x,a,xc(i):xc(i+1));
          end
      end

      function HarmonicityDown = get.HarmonicityDown(obj)
          x=obj.xnorm;
          a=obj.anorm;
          xc=crossings(x);
          HarmonicityDown=[0];
          for i=1:length(xc)-1
              if x(i+5)<0
                  HarmonicityDown(i)=get_Harmonicity(x,a,xc(i):xc(i+1));
              end
          end
      end
      
      function HarmonicityUp = get.HarmonicityUp(obj)
          x=obj.xnorm;
          a=obj.anorm;
          xc=crossings(x);
          HarmonicityUp=[0];
          for i=1:length(xc)-1
              if x(i+5)>0
                  HarmonicityUp(i)=get_Harmonicity(x,a,xc(i):xc(i+1));
              end
          end
      end
      
      function Circularity = get.Circularity(obj)
          %This method imposes a circle of R=1 and center=(0,0)
          [~,modulus] = cart2pol(obj.xnorm,obj.vnorm);
          Circularity = nanmean(modulus);
      end
      
      function f = get.f(obj)
          Pxx=obj.Pxx;
          f=obj.freq(Pxx==max(Pxx));
      end
      
      function Pxx = get.Pxx(obj)
        [Pxx,~] = get_welch_periodogram(obj.xnorm);
      end
           
      
      function freq = get.freq(obj)
        [~,freq] = get_welch_periodogram(obj.xnorm);
      end         
      
      %Constructor
      function ts = TimeSeriesUnimanual(data,info,conf)
        
        ts.conf=conf;
        ts.info=info;
        
        if ~isempty(strfind(ts.conf.hand,'L'))
            %Compute left hand trial kinematic data
            ts.xraw = (data.Left_L2Ang-data.Left_L1Ang)*info.scale + info.offset-info.origin;
            ts.vraw = (data.Left_L2Vel-data.Left_L1Vel)*info.scale;
            ts.araw = (data.Left_L2Acc-data.Left_L1Acc)*info.scale;
        else            
            %Compute right hand trial kinematic data
            info.offset = info.offset - 0.073;
            ts.xraw = (pi/4-(data.Right_L2Ang-data.Right_L1Ang))*info.scale + info.offset -info.origin;
            ts.vraw = (-(data.Right_L2Vel-data.Right_L1Vel))*info.scale;
            ts.araw = (-(data.Right_L2Acc-data.Right_L1Acc))*info.scale;
        end
      end
      
      function update_conf(obj,conf)
         obj.conf=conf;
      end
        
   end % methods
   
    methods(Static=true)  
        function anova_var = get_anova_variables()
            anova_var = { 'Harmonicity','Circularity','IDef','f'};
        end        
    end   
end% classdef
