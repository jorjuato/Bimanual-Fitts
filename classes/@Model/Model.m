classdef Model < handle
    properties(SetObservable = true)
      conf
      stype % 1=Unidimensional
            % 2=Bidimensional uncoupled
            % 3=Bidimensional coupled
            
      %Local instance of integrator setup
      ode
      options
      eq
      params
      parnames
      IC
      tspan
    end
    
    properties
        %Time series variables
        t        
        ph
        
        %Paramerization Initial conditions cell arrays
        pset 
        ppset
        icset
        bins
        phhist_range=-pi:pi/100:pi;
        
        %Vector field and nullcline related variables
        vfrange
        ncrange
        ph_periods
        vf_
        nc1
        nc2
        potencial_
    end
    
    properties (Dependent = true, GetAccess = public)      

        %Angular time series
        phmod
        phdot
        phcos
        phsin
        phcosdot
        phsindot       
        omeganorm
        %Peaks and indexes
        xpeaks
        vpeaks
        phpeaks        
        idx
        %Nullclines and vector fields 
        ph1nc
        ph2nc
        vf
        vfcart
        potencial
        %Angular ts-based histograms
        ph_hist
        omega_hist
        omeganorm_hist
        %Angular ph-based histograms
        ph_phhist
        omega_phhist  
        omeganorm_phhist
        %Cartesian Time series
        x
        v
        a
        xnorm
        vnorm
        anorm
        %Cartesian ts-based histograms
        x_hist
        v_hist
        a_hist
        xnorm_hist
        vnorm_hist
        anorm_hist
        %Cartesian ph-based histograms
        x_phhist
        v_phhist
        a_phhist
        xnorm_phhist
        vnorm_phhist
        anorm_phhist
    end    
    
    methods          
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function mdl = Model(stype,conf)
            if nargin<1, stype=1.5; end
            if nargin<2, conf=ModelConfig(); end
            
            mdl.conf=conf;
            mdl.stype=stype;
            mdl.pset={};
            mdl.ppset={};
            mdl.icset={};
            mdl.setup();
            mdl.setcallbacks();
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Callback Methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function setcallbacks(mdl)
            addlistener(mdl.conf,'PostSet',@mdl.update_conf);
            %addlistener(mdl,'conf','PostSet',@(src,evnt)update_conf(mdl,src,evnt));
            addlistener(mdl,'stype','PostSet',@(src,evnt)update_stype(mdl,src,evnt));
            addlistener(mdl,'ode','PostSet',@(src,evnt)update_params(mdl,src,evnt));
            addlistener(mdl,'options','PostSet',@(src,evnt)update_params(mdl,src,evnt));
            addlistener(mdl,'eq','PostSet',@(src,evnt)update_params(mdl,src,evnt));
            addlistener(mdl,'params','PostSet',@(src,evnt)update_params(mdl,src,evnt));
            addlistener(mdl,'parnames','PostSet',@(src,evnt)update_params(mdl,src,evnt));
            addlistener(mdl,'IC','PostSet',@(src,evnt)update_params(mdl,src,evnt));
            addlistener(mdl,'tspan','PostSet',@(src,evnt)update_params(mdl,src,evnt));        
        end
        
        function update_conf(mdl,src,evnt)
            mdl.setup();
        end
        
        function update_stype(mdl,src,evnt)
            mdl.setup();            
        end
        
        function update_params(mdl,src,evnt)
            mdl.t     = [];
            mdl.ph    = [];
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Property getters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Simulated time series
        
        function phmod = get.phmod(mdl)
            phmod=atan2(mdl.phcosdot,mdl.phcos);
        end   
        
        function phcos = get.phcos(mdl)
            if mdl.stype<2
                phcos=cos(mdl.ph);
            else
                phcos=[cos(mdl.ph(:,1)),...
                       cos(mdl.ph(:,2))];
            end
        end
        
        function phsin = get.phsin(mdl)
            if mdl.stype<2
                phsin=sin(mdl.ph);
            else
                phsin=[sin(mdl.ph(:,1)),...
                       sin(mdl.ph(:,2))];
            end
        end
        
        function phdot = get.phdot(mdl)
            if mdl.stype<2
                phdot=diff(unwrap(mdl.ph))./diff(mdl.t);
                phdot=[phdot(1);phdot];
            else
                phdot=[diff(unwrap(mdl.ph(:,1)))./diff(mdl.t),...
                       diff(unwrap(mdl.ph(:,2)))./diff(mdl.t)];
                phdot=[phdot(1,:);phdot];
            end
        end
        
        function phcosdot = get.phcosdot(mdl)
            if mdl.stype<2
                phcosdot=diff(unwrap(mdl.phcos))./diff(mdl.t);
                phcosdot=[phcosdot(1);phcosdot];
            else
                phcosdot=[diff(unwrap(mdl.phcos(:,1)))./diff(mdl.t),...
                          diff(unwrap(mdl.phcos(:,2)))./diff(mdl.t)];
                phcosdot=[phcosdot(1,:);phcosdot];                
            end
        end
        
        function phsindot = get.phsindot(mdl)
            if mdl.stype<2
                phsindot=diff(unwrap(mdl.phsin))./diff(mdl.t);
                phsindot=[phsindot(1);phsindot];                
            else
                phsindot=[diff(unwrap(mdl.phsin(:,1)))./diff(mdl.t),...
                          diff(unwrap(mdl.phsin(:,2)))./diff(mdl.t)];
                phsindot=[phsindot(1,:);phsindot];                     
            end
        end

        function omeganorm = get.omeganorm(mdl)
            if mdl.stype<2
                omeganorm=-mdl.phdot(mdl.idx)./max(abs(mdl.phdot(mdl.idx)));
            else
                omeganorm=[mdl.phdot(mdl.idx,1)./max(abs(mdl.phdot(mdl.idx,1))),...
                           mdl.phdot(mdl.idx,2)./max(abs(mdl.phdot(mdl.idx,2)))];
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Peaks and indexes
        
        function idx = get.idx(mdl)
            [maxPeaks, minPeaks] = peakdet(mdl.phcos, mdl.conf.peak_size);
            if ~isempty(minPeaks) && ~isempty(maxPeaks)
                peaks = sort([maxPeaks(:,1);minPeaks(:,1)]);            
                idx=(peaks(1,1):peaks(end,1))';
            else
                idx=[];
            end
        end   
        
        function xpeaks = get.xpeaks(mdl)
            [maxPeaks, minPeaks] = peakdet(mdl.x, mdl.conf.peak_size);
            if ~isempty(minPeaks) && ~isempty(maxPeaks)
                xpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(mdl.x)]);
            else
                xpeaks = [];
            end
        end
        
        function vpeaks = get.vpeaks(mdl)
            [maxPeaks, minPeaks] = peakdet(mdl.v, mdl.conf.peak_size);
            if ~isempty(minPeaks) && ~isempty(maxPeaks)
                vpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(mdl.v)]);
            else
                vpeaks = [];
            end
        end
        
        function phpeaks = get.phpeaks(mdl)
            phpeaks = peakdet(mdl.phmod, pi/2);
            if ~isempty(phpeaks)
                phpeaks = phpeaks(1:end-1,1);
            else
                phpeaks = [];
            end
        end    
        

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Vector Fields, potentials and nullcline getters
        
        function vf = get.vf(mdl)
            if mdl.stype <2
                PH=mdl.vfrange;
                dPH=mdl.vf_(PH,mdl.params{:});
                vf={PH,dPH};
            else
                [PH1,PH2]=meshgrid(mdl.vfrange{1},mdl.vfrange{2});
                dPH1=mdl.vf_(PH1,PH2,mdl.params{[1,3:end]});
                dPH2=mdl.vf_(PH2,PH1,mdl.params{2:end});
                vf={PH1,PH2,dPH1,dPH2};
            end            
        end
        
        function vfcart = get.vfcart(mdl)
            if isempty(mdl.t)
                %mdl.run;
                %disp('need to run simulation first');
                vfcart={[],[],[],[]};
            elseif mdl.stype < 2
                values=-1:0.05:1;
                idx_vp=zeros(size(values));
                idx_vn=zeros(size(values));
                %get min to divide two signs of velocity
                
                [maxt, mint]=peakdet(mdl.xnorm_hist,0.1);
                if isempty(mint)
                    m=maxt(1);
                else
                    m=mint(1);
                end
                for i=1:length(values)                    
                    %Find matching idx
                    ip=abs(mdl.xnorm_hist-values(i))<0.2;
                    in=ip;
                    in(1:m)=0;
                    ip(m:end)=0;
                    vp=find(ip);
                    vn=find(in);
                    idx_vp(i)=min(vp);
                    idx_vn(i)=min(vn);
                end
                i=[idx_vn,idx_vp];
                vfcart={mdl.xnorm_hist(i),mdl.vnorm_hist(i),mdl.vnorm_hist(i),mdl.anorm_hist(i)};
            else
                vfcart={[],[],[],[]};
            end
        end
        
        function potencial = get.potencial(mdl)
            if mdl.stype < 2
                PH=mdl.vfrange;
                potencial=mdl.potencial_(PH,mdl.params{:});
            else
                return
                [PH1,PH2]=meshgrid(mdl.vfrange{1},mdl.vfrange{2});
                dPH1=mdl.vf_(PH1,PH2,mdl.params{[1,3:end]});
                dPH2=mdl.vf_(PH2,PH1,mdl.params{2:end});
                vf={PH1,PH2,dPH1,dPH2};
            end
        end
        
        function ph1nc = get.ph1nc(mdl)
            per_no=length(mdl.ph_periods);
            phr_no=length(mdl.ncrange{1});
            if mdl.stype <2
                ph1nc=[];
            else
                ph1nc=zeros(2,2*phr_no*per_no);
                for n=1:length(mdl.ph_periods)
                    v=mdl.ph_periods(n);
                    i=1+2*(n-1)*phr_no;
                    ph1nc(1,i:i+phr_no-1)=mdl.ncrange{1};
                    ph1nc(2,i:i+phr_no-1)=mdl.nc1(mdl.ncrange{1},mdl.params{[1,3:end]},v);
                    i=i+phr_no+1;
                    ph1nc(1,i:i+phr_no-1)=mdl.ncrange{1};
                    ph1nc(2,i:i+phr_no-1)=mdl.nc2(mdl.ncrange{1},mdl.params{[1,3:end]},v);
                end
                ph1nc(imag(ph1nc) ~= 0)=NaN;
            end
        end
        
        function ph2nc = get.ph2nc(mdl)
            per_no=length(mdl.ph_periods);
            phr_no=length(mdl.ncrange{2});
            if mdl.stype <2
                ph2nc=[];
            else
                ph2nc=zeros(2,2*phr_no*per_no);
                for n=1:length(mdl.ph_periods)
                    v=mdl.ph_periods(n);
                    i=1+2*(n-1)*phr_no;
                    ph2nc(1,i:i+phr_no-1)=mdl.ncrange{2};
                    ph2nc(2,i:i+phr_no-1)=mdl.nc1(mdl.ncrange{2},mdl.params{2:end},v);
                    i=i+phr_no+1;
                    ph2nc(1,i:i+phr_no-1)=mdl.ncrange{2};
                    ph2nc(2,i:i+phr_no-1)=mdl.nc2(mdl.ncrange{2},mdl.params{2:end},v);
                end
                ph2nc(imag(ph2nc) ~= 0)=NaN;
            end   
        end   
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %Kinematic time series
        
        function x = get.x(mdl)
            x=mdl.phcos(mdl.idx);
        end
        
        function v = get.v(mdl)
            v=[0;diff(mdl.x)./diff(mdl.t(mdl.idx))];
        end
        
        function a = get.a(mdl)
            a=[0;diff(mdl.v)./diff(mdl.t(mdl.idx))];
        end
        
        function xnorm = get.xnorm(mdl)
            xnorm=mdl.x./max(abs(mdl.x));
        end
        
        function vnorm = get.vnorm(mdl)
            vnorm=mdl.v./max(abs(mdl.v));
        end
        
        function anorm = get.anorm(mdl)
            anorm=mdl.a./max(abs(mdl.a));
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Kinematic ts-based histograms
        
        function x_hist = get.x_hist(mdl)
            x_hist = get_ts_histogram(mdl.x,mdl.xpeaks,mdl.conf.bins);
        end
        
        function v_hist = get.v_hist(mdl)
            v_hist = get_ts_histogram(mdl.v,mdl.xpeaks,mdl.conf.bins);
        end
        
        function a_hist = get.a_hist(mdl)
            a_hist = get_ts_histogram(mdl.a,mdl.xpeaks,mdl.conf.bins);
        end

        function xnorm_hist = get.xnorm_hist(mdl)
            xnorm_hist = get_ts_histogram(mdl.xnorm,mdl.xpeaks,mdl.conf.bins);
        end
        
        function vnorm_hist = get.vnorm_hist(mdl)
            vnorm_hist = get_ts_histogram(mdl.vnorm,mdl.xpeaks,mdl.conf.bins);
        end
        
        function a_hist = get.anorm_hist(mdl)
            a_hist = get_ts_histogram(mdl.anorm,mdl.xpeaks,mdl.conf.bins);
        end        
        
        function ph_hist=get.ph_hist(mdl)
            ph_hist=get_ts_histogram(mdl.phmod,mdl.xpeaks,mdl.conf.bins);
        end
        
        function omega_hist=get.omega_hist(mdl)
            omega_hist=get_ts_histogram(mdl.phdot,mdl.xpeaks,mdl.conf.bins);
        end
        
        function omeganorm_hist=get.omeganorm_hist(mdl)
            omeganorm_hist=get_ts_histogram(mdl.omeganorm,mdl.xpeaks,mdl.conf.bins);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Kinematic ph-based histograms
        
        function x_phhist = get.x_phhist(mdl)
            x_phhist=get_ph_histogram(mdl.x,mdl.phpeaks,mdl.conf.bins);
        end
        
        function v_phhist = get.v_phhist(mdl)
            v_phhist=get_ph_histogram(mdl.v,mdl.phpeaks,mdl.conf.bins);
        end

        function a_phhist = get.a_phhist(mdl)
            a_phhist=get_ph_histogram(mdl.a,mdl.phpeaks,mdl.conf.bins);
        end
        
        function x_phhist = get.xnorm_phhist(mdl)
            x_phhist=get_ph_histogram(mdl.xnorm,mdl.phpeaks,mdl.conf.bins);
        end
        
        function v_phhist = get.vnorm_phhist(mdl)
            v_phhist=get_ph_histogram(mdl.vnorm,mdl.phpeaks,mdl.conf.bins);
        end

        function a_phhist = get.anorm_phhist(mdl)
            a_phhist=get_ph_histogram(mdl.anorm,mdl.phpeaks,mdl.conf.bins);
        end        
        
        function ph_phhist=get.ph_phhist(mdl)
            %ph_phhist=get_ph_histogram(mdl.phmod,mdl.phpeaks,mdl.conf.bins,1);
            ph_phhist=linspace(-pi,pi,mdl.conf.bins)';
        end
        
        function omega_phhist=get.omega_phhist(mdl)
            omega_phhist=get_ph_histogram(mdl.phdot,mdl.phpeaks,mdl.conf.bins);
        end        
        
        function omeganorm_phhist=get.omeganorm_phhist(mdl)
            omeganorm_phhist=get_ph_histogram(mdl.omeganorm,mdl.phpeaks,mdl.conf.bins);
        end
    end
end