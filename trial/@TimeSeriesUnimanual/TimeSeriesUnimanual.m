classdef TimeSeriesUnimanual < handle
   properties
      peaks      
      IDef
      ID
      conf
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
            xraw = dunzip(obj.xraw_);
        end
        
        function vraw = get.vraw(obj)
            vraw = dunzip(obj.vraw_);
        end
        
        function araw = get.araw(obj)
            araw = dunzip(obj.araw_);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compressed Raw data storage
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function set.xraw(obj,value)
            obj.xraw_ = dzip(value);
        end   
        
        function set.vraw(obj,value)
            obj.vraw_ = dzip(value);
        end
        
        function set.araw(obj,value)
            obj.araw_ = dzip(value);
        end   
   
   
   
   
   
      function x = get.x(obj)
         x = filterdata(obj.xraw);
      end
      
      function v = get.v(obj)
         v = filterdata(obj.vraw);
      end
      
      function a = get.a(obj)
         a = filterdata(obj.araw);
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
            %Skip first 'skiposc' oscillations
            idx = skip_oscillations(data.Left_L2Ang-data.Left_L1Ang,info.skipOsc);
            %Compute left hand trial kinematic data
            ts.xraw = (data.Left_L2Ang(idx)-data.Left_L1Ang(idx))*info.scale + info.offset-info.origin;
            ts.vraw = (data.Left_L2Vel(idx)-data.Left_L1Vel(idx))*info.scale;
            ts.araw = (data.Left_L2Acc(idx)-data.Left_L1Acc(idx))*info.scale;
        else
            %Skip first 'skiposc' oscillations
            idx = skip_oscillations(data.Right_L2Ang-data.Right_L1Ang,info.skipOsc);
            info.offset = info.offset - 0.073;
            %Compute right hand trial kinematic data
            ts.xraw = (pi/4-(data.Right_L2Ang(idx)-data.Right_L1Ang(idx)))*info.scale + info.offset -info.origin;% - 0.095;
            ts.vraw = (-(data.Right_L2Vel(idx)-data.Right_L1Vel(idx)))*info.scale;
            ts.araw = (-(data.Right_L2Acc(idx)-data.Right_L1Acc(idx)))*info.scale;
            
        end
        %Get peaks for later processing
        [maxPeaks, minPeaks] = peakdet(ts.x, 0.00005);
        ts.peaks = sort([maxPeaks(:,1);minPeaks(:,1)]);
        ts.ID = info.ID;
        ts.IDef = get_ID_effective(ts.x,ts.peaks,info.A);
      end
   end % methods
end% classdef
