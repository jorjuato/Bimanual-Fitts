function  plot_time_series(ts,ax,figname)
    if nargin==1,ax=[]; figname=''; end
    if nargin==2 && isa(ax,'char')
        figname=ax;
        ax=[];
    end
    
    if isa(ts,'Trial')
        tr=ts;
        ts=tr.ts;
    end
    if ~isa(ts,'TimeSeriesBimanual')
        error('ts input argument must be either a TimeSeriesBimanual or a Trial instance')
    end
    if isempty(ax)
        scrsz = get(0,'ScreenSize');
        figure('Position',[1 1 scrsz(3)/3 scrsz(4)-100]);
        set(gcf,'name',figname);
        
        ax=subplot(5,2,[1,2]);        
        hold on;        
        plot(ax,ts.Lx, 'r');
        plot(ax,ts.Rx, 'b');
        scatter(ax,ts.Lpeaks,ts.Lx(ts.Lpeaks),'r+');
        scatter(ax,ts.Rpeaks,ts.Rx(ts.Rpeaks),'b+');
        %   line(ax,[0, length(ts.Rx)],[ 0, 0 ]);
        axis(ax,[0 length(ts.Lx) -0.1 0.1]);
        ylabh=ylabel('Position (m)','rot',0);
        s = struct(handle(ylabh));
        s.Position=s.Position - [3 0 0 ];
        %set(ylabh,'Position',s.Position - [3 0 0]);
        title(figname); 
        
        ax=subplot(5,2,[3,4]);
        hold on        
        plot(ax,ts.Lv, 'r');
        plot(ax,ts.Rv, 'b');
        axis(ax,[0 length(ts.Lv) -0.5 0.5]);
        ylabh=ylabel('Velocity (m/s)','rot',0);
        s = struct(handle(ylabh));
        s.Position=s.Position - [3 0 0 ];
        %set(ylabh,'Position',s.Position - [3 0 0]);
        
        %i index removes aberrations of omega at extremes
        i=500:(length(ts.Lx)-500);
        phmax=max(tr.ls.phDiff);
        phmin=min(tr.ls.phDiff);
        %Romin=min(ts.Romega(i));
        Romax=max(ts.Romega(i));
        Lomax=max(ts.Lomega(i));
        %Lomin=min(ts.Lomega(i));
        omax=max(Romax,Lomax);
        
        ax=subplot(5,2,[5,6]);
        hold on
        plot(ax,ts.Lomega(i), 'r')
        plot(ax,ts.Romega(i), 'b')
        ylabh=ylabel('Omega (rad/s)','rot',0);
        s = struct(handle(ylabh));
        s.Position=s.Position - [3 0 0 ];
        %set(ylabh,'Position',s.Position - [3 0 0]);
        axis(ax,[0 max(i) 0 omax]);
        
        ax=subplot(5,2,[7,8]);
        hold on
        plot(ax,tr.ls.phDiff,'b')
        plot(ax,ts.Rph.*ts.Lomega-ts.Lph.*ts.Romega,'r')
        ylabh=ylabel('Phi (rads)','rot',0);
        s = struct(handle(ylabh));
        s.Position=s.Position - [3 0 0 ];
        %set(ylabh,'Position',s.Position - [3 0 0]);
        if phmin>0
            phmin=-1; 
        else
            phmax=1;
        end        
        axis(ax,[0 length(ts.Lx) phmin phmax]);
        
        
        ax=subplot(5,2,9);
        scatter(ax,mod(ts.Lph(i),2*pi),ts.Lomega(i),'r.')
        ylabh=ylabel('Omega/Phi','rot',0);
        s = struct(handle(ylabh));
        s.Position=s.Position - [0.5 0 0 ];
        %set(ylabh,'Position',s.Position - [0.8 0 0]);
        axis(ax,[0 2*pi 0 Lomax]);
        
        ax=subplot(5,2,10);
        scatter(ax,mod(ts.Rph(i),2*pi),ts.Romega(i),'b.')
        axis(ax,[0 2*pi 0 Romax]);
        
        
    else
        hold('on');
        plot(ax,ts.Lx, 'r');
        plot(ax,ts.Rx, 'b');
        scatter(ax,ts.Lpeaks,ts.Lx(ts.Lpeaks),'r+');
        scatter(ax,ts.Rpeaks,ts.Rx(ts.Rpeaks),'b+');    
        %   line(ax,[0, length(ts.Rx)],[ 0, 0 ]);
        axis(ax,[0 length(ts.Lx) -0.1 0.1]);
        hold off
    end
    %Plot targets locations
    %line(ax,[0,length(tr.Rxraw)],[tr.minY-tr.W/2,tr.minY-tr.W/2],'Color','k');
    %line(ax,[0,length(tr.Rxraw)],[tr.minY+tr.W/2,tr.minY+tr.W/2],'Color','k');
    %line(ax,[0,length(tr.Rxraw)],[tr.maxY-tr.W/2,tr.maxY-tr.W/2],'Color','k');
    %line(ax,[0,length(tr.Rxraw)],[tr.maxY+tr.W/2,tr.maxY+tr.W/2],'Color','k');
    hold('off');
end