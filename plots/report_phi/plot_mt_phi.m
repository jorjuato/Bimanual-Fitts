function  plot_mt_phi(ts,filename)
    if nargin==1,filename=''; end
    
    if isa(ts,'Trial')
        tr=ts;
        ts=tr.ts;
    end
    if ~isa(ts,'TimeSeriesBimanual')
        error('ts input argument must be either a TimeSeriesBimanual or a Trial instance')
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Get averaged instantaneous frequencies
    [Lf,Rf]=get_freq_byMT_Interp(tr);
    phDiff1=tr.ls.phDiff;
    phDiff2=ts.Rph.*Lf-ts.Lph.*Rf;
    len=length(ts.Lx);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Start plotting
    scrsz = get(0,'ScreenSize');
    figure('Position',[1 1 scrsz(3)/3 scrsz(4)-100]);
    set(gcf,'name',filename);

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot time series of positions and velocities
    ax=subplot(5,2,[1,2]);        
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
    %Plot time series of frequency
    ax=subplot(5,2,[3,4]);
    hold on        
    plot(Lf, 'r')
    plot(Rf, 'b')
    ylabh=ylabel('Omega (rad/s)','rot',0);
    s = struct(handle(ylabh));
    s.Position=s.Position - [3 0 0 ];
    %axis(ax,[0 max 0 omax]);
    xlim([0, len])

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot time series of phase difference
    ax=subplot(5,2,[5,6]);
    hold on
    plot(ax,phDiff1,'b')
    ylabh=ylabel('Phi (rads)','rot',0);
    s = struct(handle(ylabh));
    s.Position=s.Position - [3 0 0 ];
    phmax=max(phDiff1);
    phmin=min(phDiff1);
    if phmin>0
        phmin=-1; 
    else
        phmax=1;
    end        
    %axis(ax,[0 length(ts.Lx) phmin phmax]);
    xlim([0, len])
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot time series of phase difference
    ax=subplot(5,2,[7,8]);
    hold on
    plot(ax,phDiff2,'r')
    ylabh=ylabel('Phi (rads)','rot',0);
    s = struct(handle(ylabh));
    s.Position=s.Position - [3 0 0 ];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot histograms of phase difference
    ax=subplot(5,2,9);
    rose(phDiff1);
    ylabh=ylabel('PhDiff','rot',0);
    s = struct(handle(ylabh));
    s.Position=s.Position - [3 0 0 ];
    %xlim([-2*pi,2*pi])
    
    ax=subplot(5,2,10);
    rose(phDiff2);
    %xlim([-2*pi,2*pi]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Save file to disk if filename provided
    if ~isempty(filename)
        %saveas(gcf,filename,'png');
        options.Format = 'png';
        hgexport(gcf,[filename '.png'],options);
        close 
    end    
end