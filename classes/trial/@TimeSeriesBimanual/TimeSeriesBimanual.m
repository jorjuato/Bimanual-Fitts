classdef TimeSeriesBimanual < handle
    %Static properties, set on creation, not meant to change except conf
    properties
        %General setup of experiment and data analysis
        conf
        info
        %Precomputed harmonic analysis
        Lf
        LPxx
        Lfreq
        Rf
        RPxx
        Rfreq
    end % properties
    
    %Dynamic properties, set on the fly
    properties (Dependent = true, SetAccess = private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%     LEFT HAND    %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Time series
        Lxraw
        Lvraw
        Laraw
        Lx
        Lv
        La
        Ljerk
        Lxnorm
        Lvnorm
        Lanorm
        Ljerknorm
        Lph
        Lomega
        Lalpha
        Lamp
        %ts-based histograms
        Lxraw_hist
        Lvraw_hist
        Laraw_hist
        Lx_hist
        Lv_hist
        La_hist
        Ljerk_hist
        Lxnorm_hist
        Lvnorm_hist
        Lanorm_hist
        Ljerknorm_hist
        Lph_hist
        Lomega_hist
        Lalpha_hist
        Lamp_hist
        %phase-based histograms
        Lxraw_phhist
        Lvraw_phhist
        Laraw_phhist
        Lx_phhist
        Lv_phhist
        La_phhist
        Ljerk_phhist
        Lxnorm_phhist
        Lvnorm_phhist
        Lanorm_phhist
        Ljerknorm_phhist
        Lph_phhist
        Lomega_phhist
        Lalpha_phhist
        Lamp_phhist
        %peaks
        Lpeaks
        Lphpeaks
        Lvpeaks
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%    RIGHT HAND    %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Time series
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
        %ts-based histograms
        Rxraw_hist
        Rvraw_hist
        Raraw_hist
        Rx_hist
        Rv_hist
        Ra_hist
        Rjerk_hist
        Rxnorm_hist
        Rvnorm_hist
        Ranorm_hist
        Rjerknorm_hist
        Rph_hist
        Romega_hist
        Ralpha_hist
        Ramp_hist
        %phase-based histograms
        Rxraw_phhist
        Rvraw_phhist
        Raraw_phhist
        Rx_phhist
        Rv_phhist
        Ra_phhist
        Rjerk_phhist
        Rxnorm_phhist
        Rvnorm_phhist
        Ranorm_phhist
        Rjerknorm_phhist
        Rph_phhist
        Romega_phhist
        Ralpha_phhist
        Ramp_phhist
        %peaks
        Rpeaks
        Rvpeaks
        Rphpeaks
        idx
        maxhistL
        maxhistR
    end
    
    %Hidden properties with actual used by dynamic property getters/setters
    properties (SetAccess = private, Hidden)
        %Contain the actual ts data, stored or raw according to config.
        Lxraw_
        Lvraw_
        Laraw_
        Rxraw_
        Rvraw_
        Raraw_
        Lpeaks_
        Lvpeaks_
        Rpeaks_
        Rvpeaks_
        idx_
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
        % Low pass filtered signals
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
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Normalized and low pass filtered signals
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
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
            Rph = atan2(ts.Rxnorm,ts.Rvnorm);
            %Rph = filterdata(unwrap(angle(hilbert(ts.Rx))),ts.conf.cutoff);
            %Rph = filterdata(unwrap(atan2(ts.Rxnorm,ts.Rvnorm)),ts.conf.cutoff);
        end
        
        
        function Lph = get.Lph(ts)
            Lph = atan2(ts.Lxnorm,ts.Lvnorm);
            %Lph = filterdata(unwrap(angle(hilbert(ts.Lx))),ts.conf.cutoff);
            %Lph = filterdata(unwrap(atan2(ts.Lxnorm,ts.Lvnorm)),ts.conf.cutoff*2);
        end
        
        
        function Romega = get.Romega(ts)
            Romega = filterdata(diff(unwrap(ts.Rph)*1000),ts.conf.cutoff*2);
            Romega=[Romega(1); Romega];
        end
        
        
        function Lomega = get.Lomega(ts)
            Lomega = filterdata(diff(unwrap(ts.Lph)*1000),ts.conf.cutoff*2);
            Lomega=[Lomega(1); Lomega];
        end
        
        
        function Ralpha = get.Ralpha(ts)
            Ralpha=filterdata(diff(ts.Romega*1000),ts.conf.cutoff*2);
            Ralpha(end+1)=Ralpha(end);
        end
        
        
        function Lalpha = get.Lalpha(ts)
            Lalpha=filterdata(diff(ts.Lomega*1000),ts.conf.cutoff*2);
            Lalpha(end+1)=Lalpha(end);
        end
        
        
        function Ramp = get.Ramp(ts)
            Ramp = abs(hilbert(ts.Rx));
        end
        
        
        function Lamp = get.Lamp(ts)
            Lamp = abs(hilbert(ts.Lx));
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Canonic histograms of time series
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function maxhistL = get.maxhistL(ts)
            maxhistL=max(diff(ts.Lpeaks(2:end-1)));
        end
        
        function maxhistR = get.maxhistR(ts)
            maxhistR=max(diff(ts.Rpeaks(2:end-1)));
        end
        
        function Lxraw_hist = get.Lxraw_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Lxraw_hist=get_ts_histogram(ts.Lxraw,peaks,ts.conf.hist_bins);
        end
        
        function Lvraw_hist = get.Lvraw_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Lvraw_hist=get_ts_histogram(ts.Lvraw,peaks,ts.conf.hist_bins);
        end
        
        function Laraw_hist = get.Laraw_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Laraw_hist=get_ts_histogram(ts.Laraw,peaks,ts.conf.hist_bins);
        end
        
        function Rxraw_hist = get.Rxraw_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Rxraw_hist=get_ts_histogram(ts.Rxraw,peaks,ts.conf.hist_bins);
        end
        
        function Rvraw_hist = get.Rvraw_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Rvraw_hist=get_ts_histogram(ts.Rvraw,peaks,ts.conf.hist_bins);
        end
        
        function Raraw_hist = get.Raraw_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Raraw_hist=get_ts_histogram(ts.Raraw,peaks,ts.conf.hist_bins);
        end
        
        
        function Lx_hist = get.Lx_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Lx_hist=get_ts_histogram(ts.Lx,peaks,ts.conf.hist_bins);
        end
        
        
        function Lv_hist = get.Lv_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Lv_hist=get_ts_histogram(ts.Lv,peaks,ts.conf.hist_bins);
        end
        
        
        function La_hist = get.La_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            La_hist=get_ts_histogram(ts.Lxraw,peaks,ts.conf.hist_bins);
        end
        
        
        function Ljerk_hist = get.Ljerk_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Ljerk_hist=get_ts_histogram(ts.Ljerk,peaks,ts.conf.hist_bins);
        end
        
        
        function Rx_hist = get.Rx_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Rx_hist=get_ts_histogram(ts.Rx,peaks,ts.conf.hist_bins);
        end
        
        
        function Rv_hist = get.Rv_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Rv_hist=get_ts_histogram(ts.Rv,peaks,ts.conf.hist_bins);
        end
        
        
        function Ra_hist = get.Ra_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Ra_hist=get_ts_histogram(ts.Ra,peaks,ts.conf.hist_bins);
        end
        
        
        function Rjerk_hist = get.Rjerk_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Rjerk_hist=get_ts_histogram(ts.Rjerk,peaks,ts.conf.hist_bins);
        end
        
        
        function Lxnorm_hist = get.Lxnorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Lxnorm_hist=get_ts_histogram(ts.Lxnorm,peaks,ts.conf.hist_bins);
        end
        
        
        function Lvnorm_hist = get.Lvnorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Lvnorm_hist=get_ts_histogram(ts.Lvnorm,peaks,ts.conf.hist_bins);
        end
        
        
        function Lanorm_hist = get.Lanorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Lanorm_hist=get_ts_histogram(ts.Lanorm,peaks,ts.conf.hist_bins);
        end
        
        
        function Ljerknorm_hist = get.Ljerknorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Ljerknorm_hist=get_ts_histogram(ts.Ljerknorm,peaks,ts.conf.hist_bins);
        end
        
        
        function Rxnorm_hist = get.Rxnorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Rxnorm_hist=get_ts_histogram(ts.Rxnorm,peaks,ts.conf.hist_bins);
        end
        
        
        function Rvnorm_hist = get.Rvnorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Rvnorm_hist=get_ts_histogram(ts.Rvnorm,peaks,ts.conf.hist_bins);
        end
        
        
        function Ranorm_hist = get.Ranorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Ranorm_hist=get_ts_histogram(ts.Ranorm,peaks,ts.conf.hist_bins);
        end
        
        
        function Rjerknorm_hist = get.Rjerknorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Rjerknorm_hist=get_ts_histogram(ts.Rjerknorm,peaks,ts.conf.hist_bins);
        end
        
        
        function Rph_hist = get.Rph_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Rph_hist=get_ts_histogram(ts.Rph,peaks,ts.conf.hist_bins,1);
        end
        
        
        function Lph_hist = get.Lph_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Lph_hist=get_ts_histogram(ts.Lph,peaks,ts.conf.hist_bins);
        end
        
        
        function Romega_hist = get.Romega_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Romega_hist=get_ts_histogram(ts.Romega,peaks,ts.conf.hist_bins);
        end
        
        
        function Lomega_hist = get.Lomega_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Lomega_hist=get_ts_histogram(ts.Lomega,peaks,ts.conf.hist_bins);
        end
        
        
        function Ralpha_hist = get.Ralpha_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Ralpha_hist=get_ts_histogram(ts.Ralpha,peaks,ts.conf.hist_bins);
        end
        
        
        function Lalpha_hist = get.Lalpha_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Lalpha_hist=get_ts_histogram(ts.Lalpha,peaks,ts.conf.hist_bins);
        end
        
        
        function Ramp_hist = get.Ramp_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Rpeaks;
                tsp=ts.Rx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Rvpeaks;
                tsp=ts.Rv;
            end
            Ramp_hist=get_ts_histogram(ts.Ramp,peaks,ts.conf.hist_bins);
        end
        
        
        function Lamp_hist = get.Lamp_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.Lpeaks;
                tsp=ts.Lx;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.Lvpeaks;
                tsp=ts.Lv;
            end
            Lamp_hist=get_ts_histogram(ts.Lams,peaks,ts.conf.hist_bins);
        end
        
        

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        function Lxraw_phhist = get.Lxraw_phhist(ts)
            Lxraw_phhist=get_ph_histogram(ts.Lxraw,ts.Lphpeaks,ts.conf.hist_bins);
        end
        
        function Lvraw_phhist = get.Lvraw_phhist(ts)
            Lvraw_phhist=get_ph_histogram(ts.Lvraw,ts.Lphpeaks,ts.conf.hist_bins);
        end
        
        function Laraw_phhist = get.Laraw_phhist(ts)
            Laraw_phhist=get_ph_histogram(ts.Laraw,ts.Lphpeaks,ts.conf.hist_bins);
        end
        
        function Rxraw_phhist = get.Rxraw_phhist(ts)
            Rxraw_phhist=get_ph_histogram(ts.Rxraw,ts.Rphpeaks,ts.conf.hist_bins);
        end
        
        function Rvraw_phhist = get.Rvraw_phhist(ts)
            Rvraw_phhist=get_ph_histogram(ts.Rvraw,ts.Rphpeaks,ts.conf.hist_bins);
        end
        
        function Raraw_phhist = get.Raraw_phhist(ts)
            Raraw_phhist=get_ph_histogram(ts.Raraw,ts.Rphpeaks,ts.conf.hist_bins);
        end
        
        function Lx_phhist = get.Lx_phhist(ts)
            Lx_phhist=get_ph_histogram(ts.Lx,ts.Lphpeaks,ts.conf.hist_bins);
        end        
        
        function Lv_phhist = get.Lv_phhist(ts)
            Lv_phhist=get_ph_histogram(ts.Lv,ts.Lphpeaks,ts.conf.hist_bins);
        end        
        
        function La_phhist = get.La_phhist(ts)
            La_phhist=get_ph_histogram(ts.La,ts.Lphpeaks,ts.conf.hist_bins);
        end        
        
        function Ljerk_phhist = get.Ljerk_phhist(ts)
            Ljerk_phhist=get_ph_histogram(ts.Ljerk,ts.Lphpeaks,ts.conf.hist_bins);
        end        
        
        function Rx_phhist = get.Rx_phhist(ts)
            Rx_phhist=get_ph_histogram(ts.Rx,ts.Rphpeaks,ts.conf.hist_bins);
        end        
        
        function Rv_phhist = get.Rv_phhist(ts)
            Rv_phhist=get_ph_histogram(ts.Rv,ts.Rphpeaks,ts.conf.hist_bins);
        end        
        
        function Ra_phhist = get.Ra_phhist(ts)
            Ra_phhist=get_ph_histogram(ts.Ra,ts.Rphpeaks,ts.conf.hist_bins);
        end        
        
        function Rjerk_phhist = get.Rjerk_phhist(ts)
            Rjerk_phhist=get_ph_histogram(ts.Rjerk,ts.Rphpeaks,ts.conf.hist_bins);
        end        
        
        function Lxnorm_phhist = get.Lxnorm_phhist(ts)
            Lxnorm_phhist=get_ph_histogram(ts.Lxnorm,ts.Lphpeaks,ts.conf.hist_bins);
        end        
        
        function Lvnorm_phhist = get.Lvnorm_phhist(ts)
            Lvnorm_phhist=get_ph_histogram(ts.Lvnorm,ts.Lphpeaks,ts.conf.hist_bins);
        end        
        
        function Lanorm_phhist = get.Lanorm_phhist(ts)
            Lanorm_phhist=get_ph_histogram(ts.Lanorm,ts.Lphpeaks,ts.conf.hist_bins);
        end        
        
        function Ljerknorm_phhist = get.Ljerknorm_phhist(ts)
            Ljerknorm_phhist=get_ph_histogram(ts.Ljerknorm,ts.Lphpeaks,ts.conf.hist_bins);
        end
                
        function Rxnorm_phhist = get.Rxnorm_phhist(ts)
            Rxnorm_phhist=get_ph_histogram(ts.Rxnorm,ts.Rphpeaks,ts.conf.hist_bins);
        end        
        
        function Rvnorm_phhist = get.Rvnorm_phhist(ts)
            Rvnorm_phhist=get_ph_histogram(ts.Rvnorm,ts.Lphpeaks,ts.conf.hist_bins);
        end        
        
        function Ranorm_phhist = get.Ranorm_phhist(ts)
            Ranorm_phhist=get_ph_histogram(ts.Ranorm,ts.Rphpeaks,ts.conf.hist_bins);
        end        
        
        function Rjerknorm_phhist = get.Rjerknorm_phhist(ts)
            Rjerknorm_phhist=get_ph_histogram(ts.Ramp,ts.Lphpeaks,ts.conf.hist_bins);
        end        
        
        function Rph_phhist = get.Rph_phhist(ts)
            Rph_phhist=get_ph_histogram(ts.Rph,ts.Rphpeaks,ts.conf.hist_bins,1);
        end        
        
        function Lph_phhist = get.Lph_phhist(ts)
            Lph_phhist=get_ph_histogram(ts.Lph,ts.Lphpeaks,ts.conf.hist_bins,1);
        end        
        
        function Romega_phhist = get.Romega_phhist(ts)
            Romega_phhist=get_ph_histogram(ts.Romega,ts.Rphpeaks,ts.conf.hist_bins);
        end        
        
        function Lomega_phhist = get.Lomega_phhist(ts)
            Lomega_phhist=get_ph_histogram(ts.Lomega,ts.Lphpeaks,ts.conf.hist_bins);
        end        
        
        function Ralpha_phhist = get.Ralpha_phhist(ts)
            Ralpha_phhist=get_ph_histogram(ts.Ralpha,ts.Rphpeaks,ts.conf.hist_bins);
        end       
        
        function Lalpha_phhist = get.Lalpha_phhist(ts)
            Lalpha_phhist=get_ph_histogram(ts.Lalpha,ts.Lphpeaks,ts.conf.hist_bins);
        end        
        
        function Ramp_phhist = get.Ramp_phhist(ts)
            Ramp_phhist=get_ph_histogram(ts.Ramp,ts.Rphpeaks,ts.conf.hist_bins);
        end        
        
        function Lamp_phhist = get.Lamp_phhist(ts)
            Lamp_phhist=get_ph_histogram(ts.Lamp,ts.Lphpeaks,ts.conf.hist_bins);
        end        
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Peak finding and valid index computation code
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function Lpeaks = get.Lpeaks(ts)
            if ts.conf.store_idx==1
                Lpeaks=ts.Lpeaks_;
            else
                [maxPeaks, minPeaks] = peakdet(ts.Lx, ts.conf.peak_size);
                Lpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Lx)]);
            end
        end
        
        function Rpeaks = get.Rpeaks(ts)
            if ts.conf.store_idx==1
                Rpeaks=ts.Rpeaks_;
            else
                [maxPeaks, minPeaks] = peakdet(ts.Rx, ts.conf.peak_size);
                Rpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Rx)]);
            end
        end
        
        function Lphpeaks = get.Lphpeaks(ts)
            
            maxPeaks = peakdet(ts.Lph, pi/2);
            Lphpeaks = maxPeaks(:,1);
            
        end
        
        function Rphpeaks = get.Rphpeaks(ts)
            maxPeaks = peakdet(ts.Rph, pi/2);
            Rphpeaks = maxPeaks(:,1);
        end
        
        function Lvpeaks = get.Lvpeaks(ts)
            if ts.conf.store_idx==1
                Lvpeaks=ts.Lvpeaks_;
            else
                [maxPeaks, minPeaks] = peakdet(ts.Lv, ts.conf.peak_size);
                Lvpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Lv)]);
            end
        end
        
        function Rvpeaks = get.Rvpeaks(ts)
            if ts.conf.store_idx==1
                Rvpeaks=ts.Rvpeaks_;
            else
                [maxPeaks, minPeaks] = peakdet(ts.Rv, ts.conf.peak_size);
                Rvpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.Rv)]);
            end
        end
        
        function idx = get.idx(ts)
            if ts.conf.store_idx==1
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
            ts.compute_idx();
            
            %Computation-intensive variables, always stored on creation
            ts.compute_fourier();
        end
        
        function compute_idx(ts)
            if ts.conf.store_idx==1
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
        end
        
        function compute_fourier(ts)
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
        
        function plot_phsp(ts,ax1,ax2)
            if nargin<3;
                figure;
                ax1=subplot(1,2,1);hold on;
                ax2=subplot(1,2,2);hold on;
            end
            scatter(ax1,ts.Lph_hist,ts.Lomega_hist,'r.'); scatter(ax1,ts.Lph_hist,ts.Lxnorm_hist*pi,'b.');
            xlim(ax1,[-pi,pi])
            title(ax1,'Left hand Phase space')
            
            scatter(ax2,ts.Rph_hist,ts.Romega_hist,'r.'); scatter(ax2,ts.Rph_hist,ts.Rxnorm_hist*pi,'b.');
            xlim(ax2,[-pi,pi])
            title(ax2,'Right hand Phase space')
        end
        
    end % methods
    
end% classdef
