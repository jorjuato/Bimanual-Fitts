classdef Oscillations < handle
    properties
        hand
        conf
        ts
        IDOwn
        IDOther
        IDOwnEf
        IDOtherEf
    end
    
    properties (Dependent = true, SetAccess = private)
        peakVel
        MT
        MTOwn
        MTOther
        accTime
        decTime
        accQ
        IPerf
        IPerfEf
    end
    
   %%%%%%%%%%%%%%%%%%
   % Public methods
   %%%%%%%%%%%%%%%%%%      
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Prototypes of Public methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot(obj,graphPath,rootname,ext)
        display(obj)
        concatenate(obj,obj2)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Properties getters and setter
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function MT = get.MT(obj)
            if strcmp(obj.hand,'')
                peaks = obj.ts.peaks;
            elseif strcmp(obj.hand,'L')
                %Left hand kinematics
                peaks = obj.ts.Lpeaks;
            elseif strcmp(obj.hand,'R')
                %Right hand kinematics
                peaks = obj.ts.Rpeaks;
            end
            MT=diff(peaks)./1000;
        end 
        
        function MTOwn = get.MTOwn(obj)
            if strcmp(obj.hand,'')
                MTOwn=[];
                return
            elseif strcmp(obj.hand,'L')
                %Left hand kinematics
                peaks = obj.ts.Lpeaks;
            elseif strcmp(obj.hand,'R')
                %Right hand kinematics
                peaks = obj.ts.Rpeaks;
            end
            MTOwn=diff(peaks)./1000;
        end 

        function MTOther = get.MTOther(obj)
            if strcmp(obj.hand,'')
                MTOther=[];
                return
            elseif strcmp(obj.hand,'L')
                %Right hand kinematics
                peaks = obj.ts.Rpeaks;
            elseif strcmp(obj.hand,'R')
                %Left hand kinematics
                peaks = obj.ts.Lpeaks;
            end
            MTOther=diff(peaks)./1000;
        end 
        
        function peakVel = get.peakVel(obj)
            if strcmp(obj.hand,'')
                peaks = obj.ts.peaks;
                peakNo = size(peaks,1)-1;
                v= obj.ts.v;
            elseif strcmp(obj.hand,'L')
                %Left hand kinematics
                peaks = obj.ts.Lpeaks;
                peakNo = size(peaks,1)-1;
                v= obj.ts.Lv;
            elseif strcmp(obj.hand,'R')
                %Right hand kinematics
                peaks = obj.ts.Rpeaks;
                peakNo = size(peaks,1)-1;
                v= obj.ts.Rv;
            end            
            peakVel = zeros(peakNo,1);
            for i=1:peakNo
                x0 = peaks(i,1);
                x1 = peaks(i+1,1);
                peakVel(i)=max(abs(v(x0:x1)));
            end
        end 
        
        function accTime = get.accTime(obj)
            if strcmp(obj.hand,'')
                peaks = obj.ts.peaks;
                peakNo = size(peaks,1)-1;
                a=obj.ts.a;
            elseif strcmp(obj.hand,'L')
                %Left hand kinematics
                peaks = obj.ts.Lpeaks;
                peakNo = size(peaks,1)-1;
                a=obj.ts.La;
            elseif strcmp(obj.hand,'R')
                %Right hand kinematics
                peaks = obj.ts.Rpeaks;
                peakNo = size(peaks,1)-1;
                a=obj.ts.Ra;
            end
            accTime = zeros(peakNo,1);
            for i=1:peakNo
                x0 = peaks(i,1);
                x1 = peaks(i+1,1);
                accTime(i) = length(find(a(x0:x1)>0))/(x1-x0);
            end
        end 

        function decTime = get.decTime(obj)
            if strcmp(obj.hand,'')
                peaks = obj.ts.peaks;
                peakNo = size(peaks,1)-1;
                a=obj.ts.a;
            elseif strcmp(obj.hand,'L')
                %Left hand kinematics
                peaks = obj.ts.Lpeaks;
                peakNo = size(peaks,1)-1;
                a=obj.ts.La;
            elseif strcmp(obj.hand,'R')
                %Right hand kinematics
                peaks = obj.ts.Rpeaks;
                peakNo = size(peaks,1)-1;
                a=obj.ts.Ra;
            end
            decTime = zeros(peakNo,1);
            for i=1:peakNo
                x0 = peaks(i,1);
                x1 = peaks(i+1,1);
                decTime(i) = length(find(a(x0:x1)<0))/(x1-x0);
            end
        end 

        function accQ = get.accQ(obj)
            if strcmp(obj.hand,'')
                peaks = obj.ts.peaks;
                peakNo = size(peaks,1)-1;
                a=obj.ts.a;
            elseif strcmp(obj.hand,'L')
                %Left hand kinematics
                peaks = obj.ts.Lpeaks;
                peakNo = size(peaks,1)-1;
                a=obj.ts.La;
            elseif strcmp(obj.hand,'R')
                %Right hand kinematics
                peaks = obj.ts.Rpeaks;
                peakNo = size(peaks,1)-1;
                a=obj.ts.Ra;
            end
            accQ = zeros(peakNo,1);
            for i=1:peakNo
                x0 = peaks(i,1);
                x1 = peaks(i+1,1);
                accQ(i) = length(find(a(x0:x1)<0))/length(find(a(x0:x1)>0));
            end
        end 
        

        function IPerf = get.IPerf(obj)
            if strcmp(obj.hand,'')
                peaks = obj.ts.peaks;
                ID=obj.ts.info.ID;
            elseif strcmp(obj.hand,'L')
                %Left hand kinematics
                peaks = obj.ts.Lpeaks;
                ID=obj.ts.info.LID;
            elseif strcmp(obj.hand,'R')
                %Right hand kinematics
                peaks = obj.ts.Rpeaks;
                ID=obj.ts.info.RID;
            end
            IPerf=ID*1000./diff(peaks);
        end 
        
        
        function IPerfEf = get.IPerfEf(obj)
            if strcmp(obj.hand,'')
                peaks = obj.ts.peaks;
                IDef=obj.ts.IDef;
            elseif strcmp(obj.hand,'L')
                %Left hand kinematics
                peaks = obj.ts.Lpeaks;
                IDef=obj.ts.LIDef;
            elseif strcmp(obj.hand,'R')
                %Right hand kinematics
                peaks = obj.ts.Rpeaks;
                IDef=obj.ts.RIDef;
            end
            IPerfEf=IDef*1000./diff(peaks);
        end
        
  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function osc = Oscillations(ts,hand,conf)
            osc.conf=conf;
            osc.hand=hand;
            osc.ts=ts;
            if strcmp(osc.hand,'')
                osc.IDOwn=ts.ID;
                osc.IDOwnEf=ts.IDef;
                osc.IDOther=0;
                osc.IDOtherEf=0;
            elseif strcmp(osc.hand,'L')
                %Left hand kinematics
                osc.IDOwn=ts.LID;
                osc.IDOwnEf=ts.LIDef;
                osc.IDOther=ts.RID;
                osc.IDOtherEf=ts.RIDef;
            elseif strcmp(osc.hand,'R')
                %Right hand kinematics
                osc.IDOwn=ts.RID;
                osc.IDOwnEf=ts.RIDef;
                osc.IDOther=ts.LID;
                osc.IDOtherEf=ts.LIDef;
            end
        end %Constructor     
        
        function update_conf(obj,conf)
            %conf.hand=obj.conf.hand;
            obj.conf=conf;
            obj.ts.conf=conf;
        end
    end
    
    methods(Static=true)  
        function anova_var = get_anova_variables()
            anova_var = { 'peakVel' 'MT' 'MTOwn' 'MTOther' 'IDOwn' 'IDOther' 'IDOwnEf' 'IDOtherEf' 'accTime' 'decTime' 'accQ' 'IPerf' 'IPerfEf'};
        end        
    end
end        