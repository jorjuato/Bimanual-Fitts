classdef TimeSeriesBimanual < handle
    properties
        idx
        Lpeaks
        LIDef
        LID
        Rpeaks
        RIDef
        RID
        conf
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
        Lamp
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
        Ramp
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
            Lx = filterdata(obj.Lxraw(obj.idx),obj.conf.cutoff);
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
        function ts = TimeSeriesBimanual(data,info,conf)
            ts.conf=conf;            
            
            %Compute left hand trial kinematic data
            ts.Lxraw = (data.Left_L2Ang-data.Left_L1Ang)*info.scale + info.offset-info.origin;
            ts.Lvraw = (data.Left_L2Vel-data.Left_L1Vel)*info.scale;
            ts.Laraw = (data.Left_L2Acc-data.Left_L1Acc)*info.scale;
            
            %Compute right hand trial kinematic data
            ts.Rxraw = (pi/4-(data.Right_L2Ang-data.Right_L1Ang))*info.scale + info.offset -info.origin - 0.095;
            ts.Rvraw = (-(data.Right_L2Vel-data.Right_L1Vel))*info.scale;
            ts.Raraw = (-(data.Right_L2Acc-data.Right_L1Acc))*info.scale;
            
            %Skip first 'skiposc' oscillations
            if conf.skip_osc == 0
                idxL = skip_oscillations(ts.Lxraw,info.skipOsc);
                idxR = skip_oscillations(ts.Rxraw,info.skipOsc);
            else
                idxL = skip_oscillations(ts.Lxraw,conf.skip_osc);
                idxR = skip_oscillations(ts.Rxraw,conf.skip_osc);
            end
            
            %Pick the shortest time series
            if length(idxL) < length(idxR)
                ts.idx = idxL;
            else
                ts.idx = idxR;
            end
            
            
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
        
        function update_conf(obj,conf)
            obj.conf=conf;
        end
        
        function update_idx(obj)
        %Updates indexes of skipped oscillations based on conf.skip_osc
            if obj.conf.skip_osc==0
                obj.idx=1:length(obj.Lxraw);
            else
                idxL = skip_oscillations(obj.Lxraw,obj.conf.skip_osc);
                idxR = skip_oscillations(obj.Rxraw,obj.conf.skip_osc);
                %Pick the shortest time series
                if length(idxL) < length(idxR)
                    obj.idx = idxL;
                else
                    obj.idx = idxR;
                end
            end
        end
            
        [fcns, names, xlabels, ylabels] = get_plots(obj)
        
        plot(obj,graphPath,rootname,ext)
        
        concatenate(obj,obj2)
        
    end % methods
end% classdef
