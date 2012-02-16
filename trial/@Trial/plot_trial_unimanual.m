function  plot_trial_unimanual(data,hand)
    if nargin==1, hand='R'; end
    %Get trial setup
    ne = length(data.EVENTS.TIMES);
    TP = data.TRIAL.TP;
    scale = data.TP_TABLE.ScaleY(TP);
    shift = data.TP_TABLE.FeedBackShift(TP)/100;   
    targetD = data.TP_TABLE.TargetD(TP);
    targetU = data.TP_TABLE.TargetU(TP);
    height  = data.TARGET_TABLE.Height(targetD)/100;
    minY = data.TARGET_TABLE.Y(targetD)/100;
    maxY = data.TARGET_TABLE.Y(targetU)/100;
    ID = log2(2*(maxY-minY)/height);
    offset = minY+shift;
    origin = (minY+maxY)/2;
    
    %Get calibration parameters
    Left_L2 = data.CALIBRATION.LEFT_L2;
    Right_L2 = data.CALIBRATION.RIGHT_L2;
    L2 = (Left_L2+Right_L2)/2;
    
    %Skip first 'skiposc' oscillations
    %Lxelbow = data(i).Left_L2Ang-data(i).Left_L1Ang;
    %[maxPeaks, minPeaks] = peakdet(Lxelbow, 0.00005);
    %idx = [maxPeaks(skiposc,1):maxPeaks(end,1)];
    idx = 1:length(data.Left_L2Ang); 
    
    %Get kinematic raw data
    Lxelbow = data.Left_L2Ang(idx)-data.Left_L1Ang(idx);
    Lvelbow = data.Left_L2Vel(idx)-data.Left_L1Vel(idx);
    Laelbow = data.Left_L2Acc(idx)-data.Left_L1Acc(idx);
    Rxelbow = pi/4-(data.Right_L2Ang(idx)-data.Right_L1Ang(idx));
    Rvelbow = -data.Right_L2Vel(idx)-data.Right_L1Vel(idx);
    Raelbow = -data.Right_L2Acc(idx)-data.Right_L1Acc(idx);
    
    %Get effetive kinematic data
    Lxraw = Lxelbow*L2*scale+offset;
    Lx = Lxraw - origin;
    Lvraw = Lvelbow*L2*scale;
    Lv = filterdata(Lvraw);
    La = filterdata(Laelbow*L2*scale);
    Rxraw = Rxelbow*L2*scale+offset-0.073;
    Rx = Rxraw - origin;    
    Rvraw = Rvelbow*L2*scale;
    Rv = filterdata(Rvraw);
    Ra = filterdata(Raelbow*L2*scale);
    %Lh = hilbert(Lx);
    %Rh = hilbert(Rx);
    %Lph = angle(Lh);
    %Rph = angle(Rh);
    Lph = computePhase(Lx,Lvraw);
    Rph = computePhase(Rx,Rvraw);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   CHOOSE HAND   %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(hand,'L') || strcmp(hand,'l')
        Rx = Lx;
        Rvraw = Lvraw;
        Rph = Lph;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   PLOTTING   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    close all;
    figure()    
    hold('on');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Kinematics
    vscale = max(Rx)/max(Rvraw);
    plot(Rx,'b');
    plot(Rvraw*vscale,'r');
    plot(Rph/100,'g');
    title(strcat('ID=',num2str(ID),' Vscale=',num2str(1/vscale)),'fontsize',14,'fontweight','b'); 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot events as lines and crosses
    for i=1:ne
        label = data.EVENTS.LABELS{i};
        time = data.EVENTS.TIMES(i)*1000; 
        if findstr(label,'OSCILLATION')
            line([time;time],[minY-height/2-origin;maxY+height/2-origin],'Color','b');
        elseif findstr(label,'ERROR')
            line([time;time],[minY-height/2-origin;maxY+height/2-origin],'Color','r');
        elseif findstr(label,'NEXTISDOWN') == 1
            scatter(time,minY-origin,'rx');
        elseif findstr(label,'NEXTISUP') == 1
            scatter(time,maxY-origin,'rx');
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot axes and targets positions    
    line([0,length(Rx)],[minY-height/2-origin,minY-height/2-origin],'Color','k');
    line([0,length(Rx)],[minY+height/2-origin,minY+height/2-origin],'Color','k');
    line([0,length(Rx)],[maxY-height/2-origin,maxY-height/2-origin],'Color','k');
    line([0,length(Rx)],[maxY+height/2-origin,maxY+height/2-origin],'Color','k');
    line([0;length(Rx)],[0;0],'Color','k');
end

function ph = computePhase(x,v)
    w = 120;
    maxv = 0;
    maxp = 0;
    ph = zeros(length(x),1);
    for i=1:length(x)-w
        if abs(v(i))> maxv, maxv = abs(v(i)); end
        if abs(x(i))> maxp, maxp = abs(x(i)); end
        ph(i+w) = abs(atan2(mean(v(i:i+w))/maxv,mean(x(i:i+w))/maxp));
    end
    
end

function xf =  filterdata(x)
%2nd order Butter low-pass filter
     niqfreq = 500;
     cutoff = 5;
     [a,b] = butter(2,cutoff/niqfreq);
     xf = filter(a,b,x);
end