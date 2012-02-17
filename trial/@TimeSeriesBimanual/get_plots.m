function [fcns, names, xlabels, ylabels] = get_plots(obj)
    %idx=[1,2,3];
    fcns = {...
         @plot_time_series...
        ,@plot_phase_plane...
        ,@plot_hook_plane...
        }; %fcns=fcns{idx};

    names = {...
        'time_series'...
        ,'phase_plane'...
        ,'hook_plane'...
        }; %names=names{idx};

    ylabels = {...
        'Position/Speed(m;m/s)'...
        ,'Speed(m/s)'...
        ,'Accel (m/s^2)'...
        }; %ylabels=ylabels{idx};

    xlabels = {...
        'Time (ms)'...
        ,'Position (m)'...
        ,'Position (m)'...
        }; %xlabels=xlabels{idx};
end

function  plot_time_series(ts,ax)
    hold('on');
    if nargin==1, 
        plot(ts.Lx, 'r'); 
        plot(ts.Rx, 'b');
        axis([0 length(ts.Lx) -0.1 0.1]);
    else
        plot(ax,ts.Lx, 'r'); 
        plot(ax,ts.Rx, 'b');
        axis(ax,[0 length(ts.Lx) -0.1 0.1]);
    end
    %Plot targets positions
    %line([0,length(tr.Rxraw)],[tr.minY-tr.W/2,tr.minY-tr.W/2],'Color','k');
    %line([0,length(tr.Rxraw)],[tr.minY+tr.W/2,tr.minY+tr.W/2],'Color','k');
    %line([0,length(tr.Rxraw)],[tr.maxY-tr.W/2,tr.maxY-tr.W/2],'Color','k');
    %line([0,length(tr.Rxraw)],[tr.maxY+tr.W/2,tr.maxY+tr.W/2],'Color','k');
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