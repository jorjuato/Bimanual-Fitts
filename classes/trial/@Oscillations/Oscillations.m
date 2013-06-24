classdef Oscillations < handle
    properties
        hand
        conf
        ts
        ID
        IDOwn
        IDOther
        peaks
        a
        x
        v
        f
        info
    end
    
    properties (Dependent = true, SetAccess = private)
        peakVel
        MT
        MTOwn
        MTOther
        IDef
        IDOwnEf
        IDOtherEf
        IPerf
        IPerfEf
        accTime
        decTime
        accQ
        Harmonicity
        HarmonicityDown
        HarmonicityUp
        Circularity
    end
    
    %%%%%%%%%%%%%%%%%%
    % Public methods
    %%%%%%%%%%%%%%%%%%
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Prototypes of Public methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot(osc,graphPath,rootname,ext)
        display(osc)
        concatenate(osc,osc2)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Properties getters and setter
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function MT = get.MT(osc)
            MT=diff(osc.peaks)./1000;
        end
        
        
        function MTOwn = get.MTOwn(osc)
            MTOwn = osc.MT;
        end
        
        
        function MTOther = get.MTOther(osc)
            if strcmp(osc.hand,'')
                MTOther=0;
                return
            elseif strcmp(osc.hand,'L')
                %Right hand kinematics
                peaks = osc.ts.Rpeaks;
            elseif strcmp(osc.hand,'R')
                %Left hand kinematics
                peaks = osc.ts.Lpeaks;
            end
            MTOther=diff(peaks)./1000;
        end
        
        
        function IDef = get.IDef(osc)
            %Formula from McKenzie 1992
            %endpts = abs(x(peaks));
            %Wef = std(endpts)*4.133;
            %IDef = log2(2*A/Wef);
            if strcmp(osc.hand,'')
                x_=osc.ts.x(osc.ts.peaks);
            elseif strcmp(osc.hand,'L')
                %Left hand kinematics
                x_=osc.ts.Lx(osc.ts.Lpeaks);
            elseif strcmp(osc.hand,'R')
                %Right hand kinematics
                x_=osc.ts.Rxnorm(osc.ts.Rpeaks);
            end
            
            Wef=std(abs(x_)) * 4.133;
            IDef = log2(2*osc.ts.info.A/Wef);
        end
        
        
        function IDOwnEf = get.IDOwnEf(osc)
            IDOwnEf = osc.IDef;
        end
        
        
        function IDOtherEf = get.IDOtherEf(osc)
            %Formula from McKenzie 1992
            %endpts = abs(x(peaks));
            %Wef = std(endpts)*4.133;
            %IDef = log2(2*A/Wef);
            if strcmp(osc.hand,'')
                IDOtherEf=0;
            elseif strcmp(osc.hand,'L')
                %Left hand kinematics
                x_=osc.ts.Rx(osc.ts.Rpeaks);
                IDOtherEf = log2(2*osc.ts.info.A/(std(abs(x_))*4.133));
            elseif strcmp(osc.hand,'R')
                %Right hand kinematics
                x_=osc.ts.Lx(osc.ts.Lpeaks);
                IDOtherEf = log2(2*osc.ts.info.A/(std(abs(x_))*4.133));
            end
        end
        
        
        function IPerf = get.IPerf(osc)
            IPerf=osc.ID*1000./diff(osc.peaks);
        end
        
        
        function IPerfEf = get.IPerfEf(osc)
            IPerfEf=osc.IDef*1000./diff(osc.peaks);
        end
        
        
        function peakVel = get.peakVel(osc)
            peakNo = size(osc.peaks,1)-1;
            peakVel = zeros(peakNo,1);
            for i=1:peakNo
                x0 = osc.peaks(i,1);
                x1 = osc.peaks(i+1,1);
                peakVel(i)=max(abs(osc.v(x0:x1)));
            end
        end
        
        
        function accTime = get.accTime(osc)
            peakNo = size(osc.peaks,1)-1;
            accTime = zeros(peakNo,1);
            for i=1:peakNo
                x0 = osc.peaks(i,1);
                x1 = osc.peaks(i+1,1);
                accTime(i) = length(find(osc.a(x0:x1).*osc.v(x0:x1)>0))/1000;
            end
        end
        
        
        function decTime = get.decTime(osc)    
            peakNo = size(osc.peaks,1)-1;
            decTime = zeros(peakNo,1);
            for i=1:peakNo
                x0 = osc.peaks(i,1);
                x1 = osc.peaks(i+1,1);
                decTime(i) = length(find(osc.a(x0:x1).*osc.v(x0:x1)<0))/1000;
            end
        end
        
        
        function accQ = get.accQ(osc)
            at=osc.accTime;
            dt=osc.decTime;
            accQ=at./(dt+at);
        end
        
        
        function Harmonicity = get.Harmonicity(osc)            
            xc=crossings(osc.x);
            Harmonicity=zeros(length(xc)-1,1);
            for i=1:length(xc)-1
                [Harmonicity(i),~]=get_Harmonicity(osc.x,osc.a,xc(i):xc(i+1));
            end
        end
        
        function HarmonicityDown = get.HarmonicityDown(osc)
            xc=crossings(osc.x);
            HarmonicityDown=[0];
            for i=1:length(xc)-1
                if osc.x(i+5)<0
                    HarmonicityDown(i)=get_Harmonicity(osc.x,osc.a,xc(i):xc(i+1));
                end
            end
        end
        
        
        function HarmonicityUp = get.HarmonicityUp(osc)
            xc=crossings(osc.x);
            HarmonicityUp=[0];
            for i=1:length(xc)-1
                if osc.x(i+5)>0
                    HarmonicityUp(i)=get_Harmonicity(osc.x,osc.a,xc(i):xc(i+1));
                end
            end
        end
        
        
        function Circularity = get.Circularity(osc)
            %This method imposes a circle of R=1 and center=(0,0)
            [~,modulus] = cart2pol(osc.x,osc.v);
            Circularity = nanmean(modulus);
        end
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function osc = Oscillations(ts,hand,conf)
            osc.conf=conf;
            osc.hand=hand;
            osc.ts=ts;
            if strcmp(osc.hand,'')
                osc.ID=ts.info.ID;
                osc.IDOwn=osc.ID;
                osc.IDOther=0;
                osc.peaks=osc.ts.peaks;
                osc.x=ts.xnorm;
                osc.v=ts.vnorm;
                osc.a=ts.anorm;      
                osc.f=ts.f;
            elseif strcmp(osc.hand,'L')
                %Left hand kinematics
                osc.ID=ts.info.LID;
                osc.IDOwn=ts.info.LID;
                osc.IDOther=ts.info.RID;
                osc.peaks=osc.ts.Lpeaks;
                osc.x=ts.Lxnorm;
                osc.v=ts.Lvnorm;
                osc.a=ts.Lanorm;  
                osc.f=ts.Lf;
            elseif strcmp(osc.hand,'R')
                %Right hand kinematics
                osc.ID=ts.info.RID;
                osc.IDOwn=ts.info.RID;
                osc.IDOther=ts.info.LID;
                osc.peaks=osc.ts.Rpeaks;
                osc.x=ts.Rxnorm;
                osc.v=ts.Rvnorm;
                osc.a=ts.Ranorm;  
                osc.f=ts.Rf;
            end
        end %Constructor
        
        
        function update_conf(osc,conf)
            %conf.hand=osc.conf.hand;
            osc.conf=conf;
            osc.ts.conf=conf;
        end
    end
    
            
    methods(Static=true)
        function anova_var = get_anova_variables()
            anova_var = { 'peakVel' 'MT' 'MTOwn' 'MTOther' 'IDOwn' 'IDOther' 'IDOwnEf' 'IDOtherEf' 'accTime' 'decTime' 'accQ' 'IPerf' 'IPerfEf' 'Harmonicity' 'f'};
        end
    end
end