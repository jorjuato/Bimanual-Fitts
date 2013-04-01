classdef TimeSeriesBimanual < handle
    properties
        conf
        info
        Lf
        LPxx
        Lfreq
        Rf
        RPxx
        Rfreq
        Lpeaks_
        Lvpeaks_
        Rpeaks_
        Rvpeaks_
        idx_
    end % properties
    
    properties (Dependent = true, SetAccess = private)
        %Move IDef and Harmonicities to oscillations, (and add Rf and Lf)
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
        Lalpha
        Lamp
        Lpeaks
        Lvpeaks
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
        Ralpha
        Ramp
        Rpeaks
        Rvpeaks
        idx
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
        function Lxraw = get.Lxraw(ts)
            if ts.conf.compress_ts==1
                Lxraw = dunzip(ts.Lxraw_);
            else
                Lxraw = ts.Lxraw_;
            end
        end
        
        function Lvraw = get.Lvraw(ts)
            if ts.conf.compress_ts==1
                Lvraw = dunzip(ts.Lvraw_);
            else
                Lvraw = ts.Lvraw_;
            end
        end
                
        function Laraw = get.Laraw(ts)
            if ts.conf.compress_ts==1
                Laraw = dunzip(ts.Laraw_);
            else
                Laraw = ts.Laraw_;
            end
        end
        
        function Rxraw = get.Rxraw(ts)
            if ts.conf.compress_ts==1
                Rxraw = dunzip(ts.Rxraw_);
            else
                Rxraw = ts.Rxraw_;
            end
        end
        
        function Rvraw = get.Rvraw(ts)
            if ts.conf.compress_ts==1
                Rvraw = dunzip(ts.Rvraw_);
            else
                Rvraw = ts.Rvraw_;
            end
        end
        
        function Raraw = get.Raraw(ts)
            if ts.conf.compress_ts==1
                Raraw = dunzip(ts.Raraw_);
            else
                Raraw = ts.Raraw_;
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compressed Raw data storage
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function set.Lxraw(ts,value)
            if ts.conf.compress_ts==1
                ts.Lxraw_ = dzip(value);
            else
                ts.Lxraw_ = value;
            end
        end   
        
        function set.Lvraw(ts,value)
            if ts.conf.compress_ts==1
                ts.Lvraw_ = dzip(value);
            else
                ts.Lvraw_ = value;
            end
        end
        
        function set.Laraw(ts,value)
            if ts.conf.compress_ts==1
                ts.Laraw_ = dzip(value);
            else
                ts.Laraw_ = value;
            end
        end
        
        function set.Rxraw(ts,value)
            if ts.conf.compress_ts==1
                ts.Rxraw_ = dzip(value);
            else
                ts.Rxraw_ = value;
            end
        end
        
        function set.Rvraw(ts,value)
            if ts.conf.compress_ts==1
                ts.Rvraw_ = dzip(value);
            else
                ts.Rvraw_ = value;
            end
        end
        
        function set.Raraw(ts,value)
            if ts.conf.compress_ts==1
                ts.Raraw_ = dzip(value);
            else
                ts.Raraw_ = value;
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compressed Raw data storage
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function Lx = get.Lx(ts)
            Lx = filterdata(ts.Lxraw(ts.idx),ts.conf.cutoff);
        end
        
        
        function Lv = get.Lv(ts)
            Lv = filterdata(ts.Lvraw(ts.idx),ts.conf.cutoff);
        end
        
        
        function La = get.La(ts)
            La = filterdata(ts.Laraw(ts.idx),ts.conf.cutoff);
        end
        
        
        function Ljerk = get.Ljerk(ts)
            Ljerk = [0;diff(ts.La)]*ts.conf.fs;
        end
        
        
        function Rx = get.Rx(ts)
            Rx = filterdata(ts.Rxraw(ts.idx),ts.conf.cutoff);
        end
        
        
        function Rv = get.Rv(ts)
            Rv = filterdata(ts.Rvraw(ts.idx),ts.conf.cutoff);
        end
        
        
        function Ra = get.Ra(ts)
            Ra = filterdata(ts.Raraw(ts.idx),ts.conf.cutoff);
        end
        
        
        function Rjerk = get.Rjerk(ts)
            Rjerk = [0;diff(ts.Ra)]*ts.conf.fs;
        end
        
        
        function Lxnorm = get.Lxnorm(ts)
            Lxnorm = ts.Lx/max(abs(ts.Lx));
        end
        
        
        function Lvnorm = get.Lvnorm(ts)
            Lvnorm = ts.Lv/max(abs(ts.Lv));
        end
        
        
        function Lanorm = get.Lanorm(ts)
            Lanorm = ts.La/max(abs(ts.La));
        end
        
        
        function Ljerknorm = get.Ljerknorm(ts)
            Ljerknorm = ts.Ljerk/max(abs(ts.Ljerk));
        end
        
        
        function Rxnorm = get.Rxnorm(ts)   
            Rxnorm = ts.Rx/max(abs(ts.Rx));
        end
        
        
        function Rvnorm = get.Rvnorm(ts)
            Rvnorm = ts.Rv/max(abs(ts.Rv));
        end
        
        
        function Ranorm = get.Ranorm(ts)
            Ranorm = ts.Ra/max(abs(ts.Ra));
        end
        
        
        function Rjerknorm = get.Rjerknorm(ts)
            Rjerknorm = ts.Rjerk ./ max(abs(ts.Rjerk));
        end
        
        
        function Rph = get.Rph(ts)
            %Rph = filterdata(unwrap(angle(hilbert(ts.Rx))),ts.conf.cutoff);
            Rph = (atan2(ts.Rvnorm,ts.Rxnorm));
        end
        
        
        function Lph = get.Lph(ts)
            %Lph = filterdata(unwrap(angle(hilbert(ts.Lx))),ts.conf.cutoff);
            Lph = (atan2(ts.Lvnorm,ts.Lxnorm));
        end
        
        
        function Romega = get.Romega(ts)
            %Romega = filterdata(diff(ts.Rph)*1000,ts.conf.cutoff);
            %Romega = diff(filterdata(ts.Rph,ts.conf.cutoff)*1000);
            Romega = diff(unwrap(ts.Rph)*1000);
            Romega(end+1)=Romega(end);
            %mo=median(Romega);
            %Romega(1:500)=mo;
            %Romega(end-500:end)=mo;
        end
        
        
        function Lomega = get.Lomega(ts)
            %Lomega = filterdata(diff(ts.Lph)*1000,ts.conf.cutoff);
            Lomega = diff(unwrap(ts.Lph)*1000);
            %Lomega = diff(filterdata(ts.Lph,ts.conf.cutoff)*1000);
            Lomega(end+1)=Lomega(end);
            %mo=median(Lomega);
            %Lomega(1:500)=mo;
            %Lomega(end-500:end)=mo;
        end
        
        
        function Ralpha = get.Ralpha(ts)
            Ralpha=diff(ts.Romega*1000);
            Ralpha(end+1)=Ralpha(end);
        end
        
        
        function Lalpha = get.Lalpha(ts)
            Lalpha=diff(ts.Lomega*1000);
            Lalpha(end+1)=Lalpha(end);
        end
        
        
        function Ramp = get.Ramp(ts)
            Ramp = abs(hilbert(ts.Rx));
        end
        
        
        function Lamp = get.Lamp(ts)
            Lamp = abs(hilbert(ts.Lx));
        end
        
        
        function Lpeaks = get.Lpeaks(ts)
            if ts.conf.storeidx==1
                Lpeaks=ts.Lpeaks_;
            else
                [maxPeaks, minPeaks] = peakdet(ts.Lx, ts.conf.peak_size);
                Lpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Lx)]);
            end
            %Lpeaks = sort([1;maxPeaks(:,1);minPeaks(:,1)]);
        end
        
        
        function Rpeaks = get.Rpeaks(ts)
            if ts.conf.storeidx==1
                Rpeaks=ts.Rpeaks_;
            else
                [maxPeaks, minPeaks] = peakdet(ts.Rx, ts.conf.peak_size);
                Rpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Rx)]);
                %Rpeaks = sort([1;maxPeaks(:,1);minPeaks(:,1)]);
            end
        end
        
        
        function Lvpeaks = get.Lvpeaks(ts)
            if ts.conf.storeidx==1
                Lvpeaks=ts.Lvpeaks_;
            else
                [maxPeaks, minPeaks] = peakdet(ts.Lv, ts.conf.peak_size);
                Lvpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Lv)]);
            end
        end
        
        
        function Rvpeaks = get.Rvpeaks(ts)
            if ts.conf.storeidx==1
                Rvpeaks=ts.Rvpeaks_;
            else
                [maxPeaks, minPeaks] = peakdet(ts.Rv, ts.conf.peak_size);
                Rvpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Rv)]);
            end
        end
        
        
        function idx = get.idx(ts)
            if ts.conf.storeidx==1
                idx=ts.idx_;
            else
                %Skip first 'skiposc' oscillations from the slowest one
                if ts.conf.skip_osc == 0
                    sk=ts.info.skipOsc;
                else
                    sk=ts.conf.skip_osc;
                end
                [maxRPeaks, minRPeaks] = peakdet(ts.Rxraw, ts.conf.peak_size);
                Rpeaks = sort([maxRPeaks(:,1);minRPeaks(:,1)]);
                [maxLPeaks, minLPeaks] = peakdet(ts.Lxraw, ts.conf.peak_size);
                Lpeaks = sort([maxLPeaks(:,1);minLPeaks(:,1)]);
                if length(Lpeaks) < length(Rpeaks)
                    idx=Lpeaks(sk,1):Lpeaks(end,1);
                else
                    idx=Rpeaks(sk,1):Rpeaks(end,1);
                end
            end
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
            
            %store idx and peaks
            if ts.conf.storeidx==1
                %Prefetch peaks to discard boundaries for idx
                [maxPeaks, minPeaks] = peakdet(ts.Lxraw, ts.conf.peak_size);
                Lpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Lxraw)]);

                [maxPeaks, minPeaks] = peakdet(ts.Rxraw, ts.conf.peak_size);
                Rpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Rxraw)]);
                
                %Number of skipped oscillations for data analysis
                if ts.conf.skip_osc == 0
                    sk=ts.info.skipOsc;
                else
                    sk=ts.conf.skip_osc;
                end
                
                %Define indexes
                if length(Lpeaks) < length(Rpeaks)
                    ts.idx_=Lpeaks(sk,1):Lpeaks(end,1);
                else
                    ts.idx_=Rpeaks(sk,1):Rpeaks(end,1);
                end
                
                %Get peaks on filtered and cutted signals
                [maxPeaks, minPeaks] = peakdet(ts.Lx, ts.conf.peak_size);
                ts.Lpeaks_ = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Lx)]);

                [maxPeaks, minPeaks] = peakdet(ts.Rx, ts.conf.peak_size);
                ts.Rpeaks_ = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Rx)]);
                
                [maxPeaks, minPeaks] = peakdet(ts.Lv, ts.conf.peak_size);
                ts.Lvpeaks_ = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Lv)]);
                
                [maxPeaks, minPeaks] = peakdet(ts.Rv, ts.conf.peak_size);
                ts.Rvpeaks_ = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Rv)]);
            end
            
            %Computation intensive variables
            [ts.LPxx,ts.Lfreq] = get_welch_periodogram(ts.Lxnorm);
            ts.Lf=ts.Lfreq(ts.LPxx==max(ts.LPxx));
            [ts.RPxx,ts.Rfreq] = get_welch_periodogram(ts.Rxnorm);
            ts.Rf=ts.Rfreq(ts.RPxx==max(ts.RPxx));
            
            
        end
        
        function update_conf(ts,conf)
            ts.conf=conf;
        end
            
        plot(ts,graphPath,rootname,ext)
        
        [fcns, names, xlabels, ylabels] = get_plots(ts)
        
        concatenate(ts,ts2)
        
    end % methods
    
end% classdef
