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
        xraw
        vraw
        araw
        x
        v
        a
        jerk
        xnorm
        vnorm
        anorm
        jerknorm
        ph
        omega
        omeganorm
        alpha
        amp
        ampnorm
        xraw_hist
        vraw_hist
        araw_hist
        x_hist
        v_hist
        a_hist
        jerk_hist
        xnorm_hist
        vnorm_hist
        anorm_hist
        jerknorm_hist
        ph_hist
        omega_hist
        omeganorm_hist
        alpha_hist
        amp_hist
        ampnorm_hist
        xraw_phhist
        vraw_phhist
        araw_phhist
        x_phhist
        v_phhist
        a_phhist
        jerk_phhist
        xnorm_phhist
        vnorm_phhist
        anorm_phhist
        jerknorm_phhist
        ph_phhist
        omega_phhist
        omeganorm_phhist
        alpha_phhist
        amp_phhist   
        ampnorm_phhist
        peaks
        phpeaks
        idx
        maxhist
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
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % Compressed Raw data retrieval
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
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
             
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % Low pass filtered time series
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       
       function x = get.x(ts)
           x = filterdata(ts.xraw(ts.idx),ts.conf.cutoff);
       end
       
       
       function v = get.v(ts)
           v = filterdata(ts.vraw(ts.idx),ts.conf.cutoff);
       end
       
       
       function a = get.a(ts)
           a = filterdata(ts.araw(ts.idx),ts.conf.cutoff);
       end
       
       
       function jerk = get.jerk(ts)
           jerk = [0;diff(ts.a)]*ts.conf.fs;
       end
       
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % Normalized time series
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
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
       

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % Oscillator phasing time series
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function ph = get.ph(ts)
            ph = atan2(ts.vnorm,ts.xnorm);
            %ph = atan2(ts.anorm,ts.vnorm);
        end
        

        function omega = get.omega(ts)
            %omega = filterdata(diff(unwrap(ts.ph)*1000),ts.conf.cutoff*2);
            omega = diff(unwrap(ts.ph)*1000);
            omega = [omega(1); omega];
        end
        
        function omeganorm = get.omeganorm(ts)
            omeganorm = -ts.omega./max(abs(ts.omega));
        end
        
        function alpha = get.alpha(ts)
            alpha=filterdata(diff(ts.omega*1000),ts.conf.cutoff*2);
            alpha = [alpha(1); alpha];
        end

        
        function amp = get.amp(ts)
            %amp = abs(hilbert(ts.x));
            amp=sqrt(ts.vnorm.^2+ts.xnorm.^2);
        end

        function ampnorm = get.ampnorm(ts)
            ampnorm = ts.amp/max(ts.amp);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Canonic histograms of time series
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function maxhist = get.maxhist(ts)
            maxhist=max(diff(ts.peaks(2:end-1)));
        end
        
       function xraw_hist = get.xraw_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            xraw_hist=get_ts_histogram(ts.xraw,peaks,ts.conf.hist_bins);
       end
       
       
       function vraw_hist = get.vraw_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            vraw_hist=get_ts_histogram(ts.vraw,peaks,ts.conf.hist_bins);
       end
       
       
       function araw_hist = get.araw_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            araw_hist=get_ts_histogram(ts.araw,peaks,ts.conf.hist_bins);
       end        
       
       function x_hist = get.x_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            x_hist=get_ts_histogram(ts.x,peaks,ts.conf.hist_bins);
       end
       
       
       function v_hist = get.v_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            v_hist=get_ts_histogram(ts.v,peaks,ts.conf.hist_bins);
       end
       
       
       function a_hist = get.a_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            a_hist=get_ts_histogram(ts.a,peaks,ts.conf.hist_bins);
       end
       
       
       function jerk_hist = get.jerk_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            jerk_hist=get_ts_histogram(ts.jerk,peaks,ts.conf.hist_bins);
       end
       
       
       function xnorm_hist = get.xnorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            xnorm_hist=get_ts_histogram(ts.xnorm,peaks,ts.conf.hist_bins);
       end
       
       
       function vnorm_hist = get.vnorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            vnorm_hist=get_ts_histogram(ts.vnorm,peaks,ts.conf.hist_bins);
       end
       
       
       function anorm_hist = get.anorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            anorm_hist=get_ts_histogram(ts.anorm,peaks,ts.conf.hist_bins);
       end
       
       
       function jerknorm_hist = get.jerknorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            jerknorm_hist=get_ts_histogram(ts.jerknorm,peaks,ts.conf.hist_bins);
       end
      
        
        function ph_hist = get.ph_hist(ts)
%             peaks=peakdet(ts.ph,pi/2);
%             ph_temp=get_ph_histogram(ts.ph,peaks(:,1),ts.conf.hist_bins);
%             xL=length(ph_temp);
%             maxL=length(ts.xnorm_hist);            
%             t=linspace(1,xL,maxL);
%             ph_hist=interp1(1:xL,ph_temp,t);
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            ph_hist=get_ts_histogram(ts.ph,peaks,ts.conf.hist_bins,1);
        end
        

        function omega_hist = get.omega_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            omega_hist=get_ts_histogram(ts.omega,peaks,ts.conf.hist_bins);
        end

        function omeganorm_hist = get.omeganorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            omeganorm_hist=get_ts_histogram(ts.omeganorm,peaks,ts.conf.hist_bins);
        end        
        
        function alpha_hist = get.alpha_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            alpha_hist=get_ts_histogram(ts.alpha,peaks,ts.conf.hist_bins);
        end

        
        function amp_hist = get.amp_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            amp_hist=get_ts_histogram(ts.amp,peaks,ts.conf.hist_bins);
        end
        

        function ampnorm_hist = get.ampnorm_hist(ts)
            if strcmp(ts.conf.hist_peaks,'x')
                peaks=ts.peaks;
                tsp=ts.x;
            elseif strcmp(ts.conf.hist_peaks,'v')
                peaks=ts.vpeaks;
                tsp=ts.v;
            end
            ampnorm_hist=get_ts_histogram(ts.ampnorm,peaks,ts.conf.hist_bins);
        end

        
       function xraw_phhist = get.xraw_phhist(ts)
            xraw_phhist=get_ph_histogram(ts.xraw,ts.phpeaks,ts.conf.hist_bins);
       end
       
       
       function vraw_phhist = get.vraw_phhist(ts)
            vraw_phhist=get_ph_histogram(ts.vraw,ts.phpeaks,ts.conf.hist_bins);
       end
       
       
       function araw_phhist = get.araw_phhist(ts)
            araw_phhist=get_ph_histogram(ts.araw,ts.phpeaks,ts.conf.hist_bins);
       end        
       
       function x_phhist = get.x_phhist(ts)
            x_phhist=get_ph_histogram(ts.x,ts.phpeaks,ts.conf.hist_bins);
       end
       
       
       function v_phhist = get.v_phhist(ts)
            v_phhist=get_ts_phhistogram(ts.v,peaks,ts.conf.hist_bins);
       end
       
       
       function a_phhist = get.a_phhist(ts)
            a_phhist=get_ph_histogram(ts.a,ts.phpeaks,ts.conf.hist_bins);
       end
       
       
       function jerk_phhist = get.jerk_phhist(ts)
            jerk_phhist=get_ph_histogram(ts.jerk,ts.phpeaks,ts.conf.hist_bins);
       end
       
       
       function xnorm_phhist = get.xnorm_phhist(ts)
            xnorm_phhist=get_ph_histogram(ts.xnorm,ts.phpeaks,ts.conf.hist_bins);
       end
       
       
       function vnorm_phhist = get.vnorm_phhist(ts)
            vnorm_phhist=get_ph_histogram(ts.vnorm,ts.phpeaks,ts.conf.hist_bins);
       end
       
       
       function anorm_phhist = get.anorm_phhist(ts)
            anorm_phhist=get_ph_histogram(ts.anorm,ts.phpeaks,ts.conf.hist_bins);
       end
       
       
       function jerknorm_phhist = get.jerknorm_phhist(ts)
            jerknorm_phhist=get_ph_histogram(ts.jerknorm,ts.phpeaks,ts.conf.hist_bins);
       end
      
        
        function ph_phhist = get.ph_phhist(ts)
            %ph_phhist=get_ph_histogram(ts.ph,ts.phpeaks,ts.conf.hist_bins,1);
            ph_phhist=linspace(-pi,pi,ts.conf.hist_bins)';
        end
        

        function omega_phhist = get.omega_phhist(ts)
            omega_phhist=get_ph_histogram(ts.omega,ts.phpeaks,ts.conf.hist_bins);
        end
        
        function omeganorm_phhist = get.omeganorm_phhist(ts)
            omeganorm_phhist=get_ph_histogram(ts.omeganorm,ts.phpeaks,ts.conf.hist_bins);
        end
        
        function alpha_phhist = get.alpha_phhist(ts)
            alpha_phhist=get_ph_histogram(ts.alpha,ts.phpeaks,ts.conf.hist_bins);
        end

        
        function amp_phhist = get.amp_phhist(ts)
            amp_phhist=get_ph_histogram(ts.amp,ts.phpeaks,ts.conf.hist_bins);
        end
        
        function ampnorm_phhist = get.ampnorm_phhist(ts)
            ampnorm_phhist=get_ph_histogram(ts.ampnorm,ts.phpeaks,ts.conf.hist_bins);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Peak finding and valid index computation code
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function peaks = get.peaks(ts)
            if ts.conf.store_idx==1
                peaks=ts.peaks_;
            else
                [maxPeaks, minPeaks] = peakdet(ts.x, ts.conf.peak_size);
                %peaks = sort([1;maxPeaks(:,1);minPeaks(:,1)]);
                peaks = sort([maxPeaks(:,1);minPeaks(:,1);length(ts.x)]);
            end
        end
        
        function phpeaks = get.phpeaks(ts)
            phpeaks = peakdet(ts.ph, pi);
            phpeaks = phpeaks(:,1);
        end
        
        function idx = get.idx(ts)
            if ts.conf.store_idx==1
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
 
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %Constructor
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        ts.compute_idx();
        
        %Computation intensive variables
        ts.compute_fourier();
      end
      
      function compute_idx(ts)          
          if ts.conf.store_idx==1
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
      end
      
      function compute_fourier(ts)          
          [ts.Pxx,ts.freq] = get_welch_periodogram(ts.xnorm);
          ts.f=ts.freq(ts.Pxx==max(ts.Pxx));
      end
      
      function update_conf(ts,conf)
         ts.conf=conf;
      end
      
      function plot_phsp(ts,ax)
          if nargin<2; figure; ax=subplot(1,1,1);hold on; end          
          scatter(ax,ts.ph_phhist,ts.omega_phhist,'r.');
          scatter(ax,ts.ph_phhist,ts.xnorm_phhist*pi,'b.');
          xlim(ax,[-pi,pi])
          title('Unimanual Phase space')
      end
        
   end % methods
   
end% classdef
