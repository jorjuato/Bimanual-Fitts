classdef Oscillations < handle
    properties
        peakVel
        MT
        accTime
        decTime
        accQ
        IPerf
        IPerfEf
        conf
    end
    
    %%%%%%%%%%%%%%%%%%
    % Public methods
    %%%%%%%%%%%%%%%%%%
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Prototypes of Public methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot(obj)
        display(obj)
        concatenate(obj,obj2)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function osc = Oscillations(ts,hand,conf)
            osc.conf=conf;
            osc.conf.hand=hand;
            if strcmp(hand,'')
                data.peaks = ts.peaks;
                data.peakNo = size(data.peaks,1)-1;
                data.x = ts.x;
                data.v = ts.v;
                data.a = ts.a;
                data.ID = ts.ID;
                data.IDef = ts.IDef;
            elseif strcmp(hand,'L')
                %Left hand kinematics
                data.peaks = ts.Lpeaks;
                data.peakNo = size(data.peaks,1)-1;
                data.x = ts.Lx;
                data.v = ts.Lv;
                data.a = ts.La;
                data.ID = ts.LID;
                data.IDef = ts.LIDef;
            elseif strcmp(hand,'R')
                %Right hand kinematics
                data.peaks = ts.Rpeaks;
                data.peakNo = size(data.peaks,1)-1;
                data.x = ts.Rx;
                data.v = ts.Rv;
                data.a = ts.Ra;
                data.ID = ts.RID;
                data.IDef = ts.RIDef;
            end
            
            osc.peakVel = zeros(data.peakNo,1);
            osc.MT = zeros(data.peakNo,1);
            osc.accTime = zeros(data.peakNo,1);
            osc.decTime = zeros(data.peakNo,1);
            osc.accQ = zeros(data.peakNo,1);
            osc.IPerf = zeros(data.peakNo,1);
            osc.IPerfEf = zeros(data.peakNo,1);
            
            for i=1:data.peakNo
                x0 = data.peaks(i,1);
                x1 = data.peaks(i+1,1);
                osc.peakVel(i) = max(abs(data.v(x0:x1)));
                osc.MT(i) = (x1-x0)/1000;
                osc.accTime(i) = length(find(data.a(x0:x1)>0))/(x1-x0);
                %osc.accelerationTime = length(find(data.a(x0:x1)>0));
                osc.decTime(i) = length(find(data.a(x0:x1)<0))/(x1-x0);
                %osc.decelerationTime = length(find(data.a(x0:x1)<0));
                osc.accQ(i) = length(find(data.a(x0:x1)<0))/length(find(data.a(x0:x1)>0));
                %osc.indexPerformance = (x1-x0)/data.ID;
                osc.IPerf(i) = data.ID*1000/(x1-x0);
                %osc.IPerfEf = (x1-x0)/data.ID;
                osc.IPerfEf(i) = data.IDef*1000/(x1-x0);
            end
        end %Constructor       
        function update_conf(obj,conf)
            conf.hand=obj.conf.hand;
            obj.conf=conf;
        end
    end
end
