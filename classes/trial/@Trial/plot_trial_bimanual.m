function  plot_trial_bimanual(data,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath='';end
    
    %Get trial configuration
    ne = length(data.EVENTS.TIMES);
    TP = data.TRIAL.TP;
    scale = data.TP_TABLE.ScaleY(TP);
    shift = data.TP_TABLE.FeedBackShift(TP)/100;   
    targetLD = data.TP_TABLE.TargetLD(TP);
    targetLU = data.TP_TABLE.TargetLU(TP);
    targetRD = data.TP_TABLE.TargetRD(TP);
    targetRU = data.TP_TABLE.TargetRU(TP);
    heightL  = data.TARGET_TABLE.Height(targetLD)/100;
    heightR  = data.TARGET_TABLE.Height(targetRD)/100;
    %Asummes same amplitude for both hands
    minY = data.TARGET_TABLE.Y(targetLD)/100;
    maxY = data.TARGET_TABLE.Y(targetLU)/100;
    IDL = log2(2*(maxY-minY)/heightL);
    IDR = log2(2*(maxY-minY)/heightR);
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
    
    %Get effetive kinematic data for Left hand
    Lxraw = Lxelbow*L2*scale+offset;
    Lx = Lxraw - origin;
    Lvraw = Lvelbow*L2*scale;
    Lv = filterdata(Lvraw);
    La = filterdata(Laelbow*L2*scale);
    %Get effetive kinematic data for Left hand
    Rxraw = Rxelbow*L2*scale+offset-0.073;
    Rx = Rxraw - origin;
    Rv = filterdata(Rvelbow*L2*scale);
    Rvraw = Rvelbow*L2*scale;
    Ra = filterdata(Raelbow*L2*scale);
    %Get absolute phase kinematic data for both hands
    %Lh = hilbert(Lx);
    %Rh = hilbert(Rx);
    %Lph = angle(Lh);
    %Rph = angle(Rh);
    %Lph = computePhase(Lx,Lvraw);
    %Rph = computePhase(Rx,Rvraw);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   PLOTTING   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    close all;
    figure();
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Right hand, assumed to be dominant
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(2,1,1);
    hold('on');
    vscale = max(Rx)/max(Rvraw);
    plot(Rx,'b');
    plot(Rvraw*vscale,'g');
    %plot(Rph/40,'g');
        title(strcat('Right Hand: ID=',num2str(IDR),' Vscale=',num2str(1/vscale)),'fontsize',14,'fontweight','b'); 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot events as lines and crosses
    for i=1:ne
        label = data.EVENTS.LABELS{i};
        time = data.EVENTS.TIMES(i)*1000; 
        if findstr(label,'DOMINANT_OSCILLATION') == 1
            line([time;time],[minY-heightR/2-origin;maxY+heightR/2-origin],'Color','b');
        elseif findstr(label,'DOMINANT_ERROR') == 1
            line([time;time],[minY-heightR/2-origin;maxY+heightR/2-origin],'Color','r');
        elseif findstr(label,'DOM_NEXT_DOWN') == 1
            scatter(time,minY-origin,'rx');
        elseif findstr(label,'DOM_NEXT_UP') == 1
            scatter(time,maxY-origin,'rx');
        end
    end
    %Plot axes and targets positions
    line([0,length(Rx)],[minY-heightR/2-origin,minY-heightR/2-origin],'Color','k');
    line([0,length(Rx)],[minY+heightR/2-origin,minY+heightR/2-origin],'Color','k');
    line([0,length(Rx)],[maxY-heightR/2-origin,maxY-heightR/2-origin],'Color','k');
    line([0,length(Rx)],[maxY+heightR/2-origin,maxY+heightR/2-origin],'Color','k');
    line([0;length(Rx)],[0;0],'Color','k','LineWidth',1.5);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Left hand , assumed to be non-dominant
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(2,1,2);    
    vscale = max(Lx)/max(Lvraw);
    hold('on');
    plot(Lx,'b');
    plot(Lvraw*vscale,'g');
    %plot(Lph/40,'g');
    title(strcat('Left Hand: ID=',num2str(IDL),' Vscale=',num2str(1/vscale)),'fontsize',14,'fontweight','b'); 
    for i=1:ne
        label = data.EVENTS.LABELS{i};
        time = data.EVENTS.TIMES(i)*1000; 
        if findstr(label,'NONDOMINANT_OSCILLATION')
            line([time;time],[minY-heightL/2-origin;maxY+heightL/2-origin],'Color','b');
        elseif findstr(label,'NONDOMINANT_ERROR')
            line([time;time],[minY-heightL/2-origin;maxY+heightL/2-origin],'Color','r');
        elseif findstr(label,'ND_NEXT_DOWN') == 1
            scatter(time,minY-origin,'rx');
        elseif findstr(label,'ND_NEXT_UP') == 1
            scatter(time,maxY-origin,'rx');
        end
    end
    %Plot axes and targets positions
    line([0,length(Rx)],[minY-heightL/2-origin,minY-heightL/2-origin],'Color','k');
    line([0,length(Rx)],[minY+heightL/2-origin,minY+heightL/2-origin],'Color','k');
    line([0,length(Rx)],[maxY-heightL/2-origin,maxY-heightL/2-origin],'Color','k');
    line([0,length(Rx)],[maxY+heightL/2-origin,maxY+heightL/2-origin],'Color','k');
    line([0;length(Rx)],[0;0],'Color','k','LineWidth',1.5);
end

function ph = computePhase(x,v)
    w = 50;
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
