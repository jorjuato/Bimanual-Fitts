function [fcns, names, xlabels, ylabels] = get_plots(obj)
    %idx=[1,2,3];
    fcns = {...
         @plot_time_series...
        ,@plot_time_seriesR...
        ,@plot_time_seriesL...
        ,@plot_phase_plane...
        ,@plot_hook_plane...
        ,@plot_jerknorm_vs_x...
        ,@plot_jerknorm_vs_v...
        ,@plot_jerknorm_vs_a...
        }; %fcns=fcns{idx};

    names = {...
        'time_series'...
        ,'time_series Right'...
        ,'time_series Left'...
        ,'phase_plane'...
        ,'hook_plane'...
        ,'jerknorm_vs_x'...
        ,'jerknorm_vs_v'...
        ,'jerknorm_vs_a'...
        }; %names=names{idx};

    ylabels = {...
        'Position(m)'...
        ,'Position/Speed(m;m/s)'...
        ,'Position/Speed(m;m/s)'...
        ,'Speed(m/s)'...
        ,'Accel (m/s^2)'...
        ,'jerknorm (m/s^3)'...
        ,'jerknorm (m/s^3)'...
        ,'jerknorm (m/s^3)'...
        }; %ylabels=ylabels{idx};

    xlabels = {...
        'Time (ms)'...
        ,'Time (ms)'...
        ,'Time (ms)'...
        ,'Position (m)'...
        ,'Position (m)'...
        ,'Position (m)'...
        ,'Speed(m/s)'...
        ,'Accel (m/s^2)'...
        }; %xlabels=xlabels{idx};
end

function  plot_time_series(ts,ax)
    hold('on');
    if nargin==1, 
        plot(ts.Lx, 'r'); 
        plot(ts.Rx, 'b');
        scatter(ts.Lpeaks,ts.Lx(ts.Lpeaks),'r+');
        scatter(ts.Rpeaks,ts.Rx(ts.Rpeaks),'b+');
        line([0 length(ts.Rx)] , [0 0 ]);
        axis([0 length(ts.Lx) -0.1 0.1]);
        
    else
        plot(ax,ts.Lx, 'r'); 
        plot(ax,ts.Rx, 'b');
        scatter(ax,ts.Lpeaks,ts.Lx(ts.Lpeaks),'r+');
        scatter(ax,ts.Rpeaks,ts.Rx(ts.Rpeaks),'b+');
        line(ax,[0 length(ts.Rx)],[ 0 0 ]);
        axis(ax,[0 length(ts.Lx) -0.1 0.1]);
    end
    %Plot targets positions
    %line([0,length(tr.Rxraw)],[tr.minY-tr.W/2,tr.minY-tr.W/2],'Color','k');
    %line([0,length(tr.Rxraw)],[tr.minY+tr.W/2,tr.minY+tr.W/2],'Color','k');
    %line([0,length(tr.Rxraw)],[tr.maxY-tr.W/2,tr.maxY-tr.W/2],'Color','k');
    %line([0,length(tr.Rxraw)],[tr.maxY+tr.W/2,tr.maxY+tr.W/2],'Color','k');
    hold('off');
end

function  plot_time_seriesR(ts,ax)
    hold('on');
    if nargin==1, 
        plot(ts.Rxnorm, 'r'); 
        plot(ts.Rvnorm, 'b');
        plot(ts.Ranorm, 'g');
        plot(ts.Rjerknorm, 'k');
        line([0 length(ts.Rx)],[ 0 0 ]);
        axis([0 length(ts.Rxnorm) -1.1 1.1]);
    else
        plot(ax,ts.Rxnorm, 'r'); 
        plot(ax,ts.Rvnorm, 'b');
        plot(ax,ts.Ranorm, 'g');
        plot(ax,ts.Rjerknorm, 'k');
        line(ax,[0 length(ts.Rx)] , [ 0 0 ]);
        axis(ax,[0 length(ts.Rxnorm) -1.1 1.1]);
    end
    %Plot targets positions
%     line([0,length(tr.Rx)],[tr.minY-tr.W/2,tr.minY-tr.W/2],'Color','k');
%     line([0,length(tr.Rx)],[tr.minY+tr.W/2,tr.minY+tr.W/2],'Color','k');
%     line([0,length(tr.Rx)],[tr.maxY-tr.W/2,tr.maxY-tr.W/2],'Color','k');
%     line([0,length(tr.Rx)],[tr.maxY+tr.W/2,tr.maxY+tr.W/2],'Color','k');
    hold('off');
end

function  plot_time_seriesL(ts,ax)
    hold('on');
    if nargin==1, 
        plot(ts.Lxnorm, 'r'); 
        plot(ts.Lvnorm, 'b');
        plot(ts.Lanorm, 'g');
        plot(ts.Ljerknorm, 'k');
        line([0 length(ts.Lx)],[ 0 0 ]);
        axis([0 length(ts.Lxnorm) -1.1 1.1]);
    else
        plot(ax,ts.Lxnorm, 'r'); 
        plot(ax,ts.Lvnorm, 'b');
        plot(ax,ts.Lanorm, 'g');
        plot(ax,ts.Ljerknorm, 'k');
        line(ax,[0 length(ts.Lx)],[ 0 0 ]);
        axis(ax,[0 length(ts.Lxnorm) -1.1 1.1]);
    end
    %Plot targets positions
%     line([0,length(tr.Rx)],[tr.minY-tr.W/2,tr.minY-tr.W/2],'Color','k');
%     line([0,length(tr.Rx)],[tr.minY+tr.W/2,tr.minY+tr.W/2],'Color','k');
%     line([0,length(tr.Rx)],[tr.maxY-tr.W/2,tr.maxY-tr.W/2],'Color','k');
%     line([0,length(tr.Rx)],[tr.maxY+tr.W/2,tr.maxY+tr.W/2],'Color','k');
    hold('off');
end

function  plot_phase_plane(ts,ax)
    hold on
    if nargin==1, 
        plot(ts.Lx,ts.Lv, 'r'); 
        plot(ts.Rx,ts.Rv, 'b');
    else
        plot(ax,ts.Lx,ts.Lv, 'r'); 
        plot(ax,ts.Rx,ts.Rv, 'b');
    end
    hold off
    %axis([min(tr.Lx) max(tr.Lx) min(tr.Lv) max(tr.Lv)]);
end

function  plot_hook_plane(ts,ax)
    hold on
    if nargin==1, 
        plot(ts.Lx,ts.La,'r'); 
        plot(ts.Rx,ts.Ra, 'b');
    else
        plot(ax,ts.Lx,ts.La,'r'); 
        plot(ax,ts.Rx,ts.Ra, 'b');
    end
    hold on
    %axis([min(tr.Lx) max(tr.Lx) min(tr.La) max(tr.La)]);
end

function  plot_jerknorm_vs_x(ts,ax)
    hold on
    if nargin==1, 
        plot(ts.Lx,ts.Ljerknorm,'r'); 
        plot(ts.Rx,ts.Rjerknorm, 'b');
    else
        plot(ax,ts.Lx,ts.Ljerknorm,'r'); 
        plot(ax,ts.Rx,ts.Rjerknorm, 'b');
    end
    hold on
end

function  plot_jerknorm_vs_v(ts,ax)
    hold on
    if nargin==1, 
        plot(ts.Lv,ts.Ljerknorm,'r'); 
        plot(ts.Rv,ts.Rjerknorm, 'b');
    else
        plot(ax,ts.Lv,ts.Ljerknorm,'r'); 
        plot(ax,ts.Rv,ts.Rjerknorm, 'b');
    end
    hold on
end

function  plot_jerknorm_vs_a(ts,ax)
    hold on
    if nargin==1, 
        plot(ts.La,ts.Ljerknorm,'r'); 
        plot(ts.Ra,ts.Rjerknorm, 'b');
    else
        plot(ax,ts.La,ts.Ljerknorm,'r'); 
        plot(ax,ts.Ra,ts.Rjerknorm, 'b');
    end
    hold on
end
