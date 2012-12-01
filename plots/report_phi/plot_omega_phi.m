function  plot_omega_phi(ts,filename)
    if nargin==1,filename=''; end
    
    if isa(ts,'Trial')
        tr=ts;
        ts=tr.ts;
    end
    if ~isa(ts,'TimeSeriesBimanual')
        error('ts input argument must be either a TimeSeriesBimanual or a Trial instance')
    end
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %some globals
    osc=12;
    len=length(ts.Lx);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Get instantaneous frequencies
    Lph=ts.Lph;
    Rph=ts.Rph;
    Romega=ts.Romega;
    Lomega=ts.Lomega;
%     Romega(1:500)=mean(Romega);
%     Romega(len-500:end)=mean(Romega);
%     Lomega(1:500)=mean(Lomega);
%     Lomega(len-500:end)=mean(Lomega);   
    Romax=max(Romega);
    Lomax=max(Lomega);
    omax=max(Romax,Lomax);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Get averaged instantaneous frequencies
    [mRomega,~] = moving_average(Romega,osc);
    [mLomega,~] = moving_average(Lomega,osc);    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Get phase differences
    phDiff1=tr.ls.phDiff;
    phDiff2=Lph.*Romega-Rph.*Lomega;
    phDiff3=Lph.*mRomega-Rph.*mLomega;
    phmax=max(phDiff1);
    phmin=min(phDiff1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Start plotting
    scrsz = get(0,'ScreenSize');
    figure('Position',[1 1 scrsz(3)/2 scrsz(4)-100]);
    set(gcf,'name',filename);

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot time series of positions and velocities
    ax=subplot(6,3,[1,2,3]);        
    hold on;        
    plot(ax,ts.Lx, 'r');
    plot(ax,ts.Rx, 'b');
    %plot(ax,ts.Lv/5, 'k--');
    %plot(ax,ts.Rv/5, 'g--');
    scatter(ax,ts.Lpeaks,ts.Lx(ts.Lpeaks),'r+');
    scatter(ax,ts.Rpeaks,ts.Rx(ts.Rpeaks),'b+');    
    axis(ax,[0 len -0.1 0.1]);
    ylabh=ylabel('x','rot',0);
    s = struct(handle(ylabh));
    s.Position=s.Position - [3 0 0 ];
    %title(filename);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot time series of omega
    ax=subplot(6,3,[4,5,6]);
    hold on        
    plot(Lomega, 'r')
    plot(Romega, 'b')
    ylabh=ylabel('Omega (rad/s)','rot',0);
    s = struct(handle(ylabh));
    s.Position=s.Position - [3 0 0 ];
    xlim([0, len]);
    %axis(ax,[0 max 0 omax]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot time series of phase difference
    ax=subplot(6,3,[7,8,9]);
    hold on
    plot(ax,phDiff1,'b')
    ylabh=ylabel('Phi (rads)','rot',0);
    s = struct(handle(ylabh));
    s.Position=s.Position - [3 0 0 ];
    if phmin>0
        phmin=-1; 
    else
        phmax=1;
    end        
    %axis(ax,[0 len phmin phmax]);
    xlim([0, len]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot time series of phase difference
    ax=subplot(6,3,[10,11,12]);
    hold on
    plot(ax,phDiff2,'r')
    ylabh=ylabel('Phi (rads)','rot',0);
    s = struct(handle(ylabh));
    s.Position=s.Position - [3 0 0 ];
    xlim([0, len]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot time series of phase difference
    ax=subplot(6,3,[13,14,15]);
    hold on
    plot(ax,phDiff3,'r')
    ylabh=ylabel('Phi (rads)','rot',0);
    s = struct(handle(ylabh));
    s.Position=s.Position - [3 0 0 ];
    xlim([0, len]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot phase difference histograms
    ax=subplot(6,3,16);
    rose(phDiff1);
    %hist(phDiff1)
    ylabh=ylabel('PhDiff','rot',0);
    s = struct(handle(ylabh));
    s.Position=s.Position - [3 0 0 ];
    %xlim([-2*pi,2*pi])
    
    ax=subplot(6,3,17);
    rose(phDiff2);
    %hist(phDiff2)
    %xlim([-2*pi,2*pi])
    
    ax=subplot(6,3,18);
    rose(phDiff3);
    %hist(phDiff3)
    %xlim([-2*pi,2*pi])
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Save file to disk if filename provided
    if ~isempty(filename)
        %saveas(gcf,filename,'png');
        options.Format = 'png';
        hgexport(gcf,[filename '.png'],options);
        close 
    end    
end