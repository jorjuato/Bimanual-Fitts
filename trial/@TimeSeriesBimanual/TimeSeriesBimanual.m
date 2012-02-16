classdef TimeSeriesBimanual
    properties
        Lxraw
        Lvraw
        Laraw
        Lpeaks
        LIDef
        LID
        Rxraw
        Rvraw
        Raraw
        Rpeaks
        RIDef
        RID
    end % properties
    
    properties (Dependent = true, SetAccess = private)
        Lx
        Lv
        La
        Lxnorm
        Lvnorm
        Lanorm
        Lph
        Lamp
        Rx
        Rv
        Ra
        Rxnorm
        Rvnorm
        Ranorm
        Rph
        Ramp
    end
    
    methods
        %Properties getters and setter
        %function obj = set.Material(obj,material)
        %   obj.Material = material;
        %end % set.Material
        
        function Lx = get.Lx(obj)
            Lx = filterdata(obj.Lxraw);
        end
        
        function Lv = get.Lv(obj)
            Lv = filterdata(obj.Lvraw);
        end
        
        function La = get.La(obj)
            La = filterdata(obj.Laraw);
        end
        
        function Rx = get.Rx(obj)
            Rx = filterdata(obj.Rxraw);
        end
        
        function Rv = get.Rv(obj)
            Rv = filterdata(obj.Rvraw);
        end
        
        function Ra = get.Ra(obj)
            Ra = filterdata(obj.Raraw);
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
        function Rxnorm = get.Rxnorm(obj)
            Rxnorm = obj.Rx/max(abs(obj.Rx));
        end
        
        function Rvnorm = get.Rvnorm(obj)
            Rvnorm = obj.Rv/max(abs(obj.Rv));
        end
        
        function Ranorm = get.Ranorm(obj)
            Ranorm = obj.Ra/max(abs(obj.Ra));
        end
        
        function Rph = get.Rph(obj)
            Rph = unwrap(angle(hilbert(obj.Rx)));
        end
        
        function Lph = get.Lph(obj)
            Lph = unwrap(angle(hilbert(obj.Lx)));
        end
        
        function Ramp = get.Ramp(obj)
            Ramp = abs(hilbert(obj.Rx));
        end
        
        function Lamp = get.Lamp(obj)
            Lamp = abs(hilbert(obj.Lx));
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function ts = TimeSeriesBimanual(data,info)
            %Skip first 'skiposc' oscillations
            idx = skip_oscillations(data.Left_L2Ang-data.Left_L1Ang,info.skipOsc);
            
            %Compute left hand trial kinematic data
            ts.Lxraw = (data.Left_L2Ang(idx)-data.Left_L1Ang(idx))*info.scale + info.offset-info.origin;
            ts.Lvraw = (data.Left_L2Vel(idx)-data.Left_L1Vel(idx))*info.scale;
            ts.Laraw = (data.Left_L2Acc(idx)-data.Left_L1Acc(idx))*info.scale;
            
            %Compute right hand trial kinematic data
            ts.Rxraw = (pi/4-(data.Right_L2Ang(idx)-data.Right_L1Ang(idx)))*info.scale + info.offset -info.origin - 0.095;
            ts.Rvraw = (-(data.Right_L2Vel(idx)-data.Right_L1Vel(idx)))*info.scale;
            ts.Raraw = (-(data.Right_L2Acc(idx)-data.Right_L1Acc(idx)))*info.scale;
            
            %Get peaks for later processing
            [maxPeaksL, minPeaksL] = peakdet(ts.Lx, 0.00005);
            [maxPeaksR, minPeaksR] = peakdet(ts.Rx, 0.00005);
            ts.Lpeaks = sort([maxPeaksL(:,1);minPeaksL(:,1)]);
            ts.Rpeaks = sort([maxPeaksR(:,1);minPeaksR(:,1)]);
            ts.LIDef = get_ID_effective(ts.Lx,ts.Lpeaks,info.LA);
            ts.RIDef = get_ID_effective(ts.Rx,ts.Rpeaks,info.RA);
            ts.LID = info.LID;
            ts.RID = info.RID;
        end
        
        [fcns, names, xlabels, ylabels] = get_plots(obj)
        plot(obj,graphPath,ext)
        concatenate(obj,obj2)
        
    end % methods
end% classdef
