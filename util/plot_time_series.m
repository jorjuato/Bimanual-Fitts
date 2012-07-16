function  plot_time_series(ts,ax)
    if nargin==1,ax=[]; end
    
    if isa(ts,'Trial')
        tr=ts;
        ts=tr.ts;
    end
    if ~isa(ts,'TimeSeriesBimanual')
        error('ts input argument must be either a TimeSeriesBimanual or a Trial instance')
    end
    if isempty(ax)
        figure;
        
        ax1=subplot(4,1,1);        
        hold on;        
        plot(ax1,ts.Lx, 'r');
        plot(ax1,ts.Rx, 'b');
        scatter(ax1,ts.Lpeaks,ts.Lx(ts.Lpeaks),'r+');
        scatter(ax1,ts.Rpeaks,ts.Rx(ts.Rpeaks),'b+');
        %   line(ax,[0, length(ts.Rx)],[ 0, 0 ]);
        axis(ax1,[0 length(ts.Lx) -0.1 0.1]);

        ax2=subplot(4,1,2);
        hold on        
        plot(ax2,ts.Lv, 'r');
        plot(ax2,ts.Rv, 'b');
    
        ax3=subplot(4,1,3);
        hold on
        plot(ax3,ts.Lomega, 'r')
        plot(ax3,ts.Romega, 'b')
        
        ax4=subplot(4,1,4);
        hold on
        plot(ax4,tr.ls.phDiff,'b')
        plot(ax4,ts.Rph.*ts.Lomega/1000-ts.Lph.*ts.Romega/1000,'r')
        plot(ax4,ts.Rph.*ts.Lomega-ts.Lph.*ts.Romega,'g')
        
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