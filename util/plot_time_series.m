function  plot_time_series(ts,ax)
    if nargin==1,ax=gca(); end
    
    if isa(ts,'Trial')
        tr=ts;
        ts=tr.ts;
    end
    if ~isa(ts,'TimeSeriesBimanual')
        error('ts input argument must be either a TimeSeriesBimanual or a Trial instance')
    end
    hold('on');
    plot(ax,ts.Lx, 'r');
    plot(ax,ts.Rx, 'b');
    scatter(ax,ts.Lpeaks,ts.Lx(ts.Lpeaks),'r+');
    scatter(ax,ts.Rpeaks,ts.Rx(ts.Rpeaks),'b+');
    %   line(ax,[0, length(ts.Rx)],[ 0, 0 ]);
    axis(ax,[0 length(ts.Lx) -0.1 0.1]);

    %Plot targets locations
    %line(ax,[0,length(tr.Rxraw)],[tr.minY-tr.W/2,tr.minY-tr.W/2],'Color','k');
    %line(ax,[0,length(tr.Rxraw)],[tr.minY+tr.W/2,tr.minY+tr.W/2],'Color','k');
    %line(ax,[0,length(tr.Rxraw)],[tr.maxY-tr.W/2,tr.maxY-tr.W/2],'Color','k');
    %line(ax,[0,length(tr.Rxraw)],[tr.maxY+tr.W/2,tr.maxY+tr.W/2],'Color','k');
    hold('off');
end