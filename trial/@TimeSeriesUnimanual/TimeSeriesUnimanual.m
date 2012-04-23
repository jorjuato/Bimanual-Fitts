classdef TimeSeriesUnimanual < handle
   properties
      peaks      
      IDef
      ID
      conf
      idx
   end
   
   properties (Dependent = true, SetAccess = private)
      x
      v
      a
      xraw
      vraw
      araw
      xnorm
      vnorm
      anorm
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

      %Constructor
      function ts = TimeSeriesUnimanual(data,info,conf)
        ts.conf=conf;
        if ~isempty(strfind(ts.conf.hand,'L'))
            %Compute left hand trial kinematic data
            ts.xraw = (data.Left_L2Ang(idx)-data.Left_L1Ang(idx))*info.scale + info.offset-info.origin;
            ts.vraw = (data.Left_L2Vel(idx)-data.Left_L1Vel(idx))*info.scale;
            ts.araw = (data.Left_L2Acc(idx)-data.Left_L1Acc(idx))*info.scale;
            
        else            
            %Compute right hand trial kinematic data
            info.offset = info.offset - 0.073;
            ts.xraw = (pi/4-(data.Right_L2Ang(idx)-data.Right_L1Ang(idx)))*info.scale + info.offset -info.origin;
            ts.vraw = (-(data.Right_L2Vel(idx)-data.Right_L1Vel(idx)))*info.scale;
            ts.araw = (-(data.Right_L2Acc(idx)-data.Right_L1Acc(idx)))*info.scale;
        end
        
        %Skip first 'skiposc' oscillations
        if conf.skip_osc == 0
            ts.idx = skip_oscillations(ts.xraw,info.skipOsc);
        else
            ts.idx = skip_oscillations(ts.xraw,conf.skip_osc);
        end
     
        %Get peaks for later processing
        [maxPeaks, minPeaks] = peakdet(ts.x, 0.00005);
        ts.peaks = sort([maxPeaks(:,1);minPeaks(:,1)]);
        ts.ID = info.ID;
        ts.IDef = get_ID_effective(ts.x,ts.peaks,info.A);
      end
      
      function update_conf(obj,conf)
         obj.conf=conf;
      end

   end % methods
end% classdef
