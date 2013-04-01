classdef TimeSeriesUnimanual < handle
    properties
        conf
        info
        f
        Pxx
        freq
        idx_
        peaks_
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
    end
    
    properties (SetAccess = private, Hidden)
        xraw_
        vraw_
        araw_
    end
    
    methods%Prototypes
        concatenate(ts,ts1)
        plot(ts,graphPath,rootname,ext)
        [fcns, names,xlabels,ylabels] = get_plots(ts)
    end
   
   methods%Properties getters and setter
       
       function xraw = get.xraw(ts)
           if ts.conf.compress_ts==1
               xraw = dunzip(ts.xraw_);
           else
               xraw = ts.xraw_;
           end
       end
       
       
       function vraw = get.vraw(ts)
           if ts.conf.compress_ts==1
               vraw = dunzip(ts.vraw_);
           else
               vraw = ts.vraw_;
           end
       end
       
       
       function araw = get.araw(ts)
           if ts.conf.compress_ts==1
               araw = dunzip(ts.araw_);
           else
               araw = ts.araw_;
           end
       end
       
       
       function jerk = get.jerk(ts)
           jerk = [0;diff(ts.a)]*ts.conf.fs;
       end
       
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % Compressed Raw data storage
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       function set.xraw(ts,value)
           if ts.conf.compress_ts==1
               ts.xraw_ = dzip(value);
           else
               ts.xraw_ = value;
           end
       end
       
       
       function set.vraw(ts,value)
           if ts.conf.compress_ts==1
               ts.vraw_ = dzip(value);
           else
               ts.vraw_ = value;
           end
       end
       
       
       function set.araw(ts,value)
           if ts.conf.compress_ts==1
               ts.araw_ = dzip(value);
           else
               ts.araw_ = value;
           end
       end
       
       
       function x = get.x(ts)
           x = filterdata(ts.xraw(ts.idx),ts.conf.cutoff);
       end
       
       
       function v = get.v(ts)
           v = filterdata(ts.vraw(ts.idx),ts.conf.cutoff);
       end
       
       
       function a = get.a(ts)
           a = filterdata(ts.araw(ts.idx),ts.conf.cutoff);
       end
       
       
       function xnorm = get.xnorm(ts)
           xnorm = ts.x/max(abs(ts.x));
       end
       
       
       function vnorm = get.vnorm(ts)
           vnorm = ts.v/max(abs(ts.v));
       end
       
       
       function anorm = get.anorm(ts)
           anorm = ts.a/max(abs(ts.a));
       end
       
       
       function jerknorm = get.jerknorm(ts)
           jerknorm = ts.jerk/max(abs(ts.jerk));
       end
      
      
      function peaks = get.peaks(ts)
          if ts.conf.storeidx==1
              peaks=ts.peaks_;
          else
              [maxPeaks, minPeaks] = peakdet(ts.x, ts.conf.peak_size);
              %peaks = sort([1;maxPeaks(:,1);minPeaks(:,1)]);
              peaks = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.x)]);
          end
      end
      
      
      function idx = get.idx(ts)
          if ts.conf.storeidx==1
              idx=ts.idx_;
          else              
              [maxPeaks, minPeaks] = peakdet(ts.xraw, ts.conf.peak_size);
              peaks = sort([maxPeaks(:,1);minPeaks(:,1)]);
              %Skip first 'skiposc' oscillations
              if ts.conf.skip_osc == 0
                  idx=peaks(ts.info.skipOsc,1):peaks(end,1);
              else
                  idx=peaks(ts.conf.skip_osc,1):peaks(end,1);
              end
          end          
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
        
        %store idx and peaks
        if ts.conf.storeidx==1
            [maxPeaks, minPeaks] = peakdet(ts.xraw, ts.conf.peak_size);
            peaks = sort([maxPeaks(:,1);minPeaks(:,1)]);
            if ts.conf.skip_osc == 0
                ts.idx_=peaks(ts.info.skipOsc,1):peaks(end,1);
            else
                ts.idx_=peaks(ts.conf.skip_osc,1):peaks(end,1);
            end
            [maxPeaks, minPeaks] = peakdet(ts.x, ts.conf.peak_size);
            ts.peaks_ = sort([maxPeaks(:,1);minPeaks(:,1)]);
        end
        
        %Computation intensive variables
        [ts.Pxx,ts.freq] = get_welch_periodogram(ts.xnorm);
        ts.f=ts.freq(ts.Pxx==max(ts.Pxx));
        
      end
      
      function update_conf(ts,conf)
         ts.conf=conf;
      end
        
   end % methods
   
end% classdef
