function [fcns, names, xlabels, ylabels] = get_plots(obj)
    idx=[1,2,3];
    fcns = {...
         @plot_time_series...
        ,@plot_phase_plane...
        ,@plot_hook_plane...
        ,@plot_jerk_vs_x...
        ,@plot_jerk_vs_v...
        ,@plot_jerk_vs_a...        
        }; %fcns=fcns{idx};

    names = {...
        'time_series'...
        ,'phase_plane'...
        ,'hook_plane'...
        ,'jerk_vs_x'...
        ,'jerk_vs_v'...
        ,'jerk_vs_a'...        
        }; %names=names{idx};

    ylabels = {...
        'Position/Speed(m;m/s)'...
        ,'Speed(m/s)'...
        ,'Accel (m/s^2)'...
        ,'Jerk (m/s^3)'...
        ,'Jerk (m/s^3)'...
        ,'Jerk (m/s^3)'...        
        }; %ylabels=ylabels{idx};

    xlabels = {...
        'Time (ms)'...
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
        plot(ts.x, 'b');
        plot(ts.v, 'r');
        plot(ts.a, 'g');
        plot(ts.jerk, 'k');
        axis([0 length(ts.x) -0.2 0.2]);
    else
        plot(ax,ts.x, 'b');
        plot(ax,ts.v, 'r');
        plot(as,ts.a, 'g');
        plot(as,ts.jerk, 'k');        
        axis(ax,[0 length(ts.x) -0.2 0.2]);        
    end
    %Plot targets positions
    %line([0,length(tr.Rxraw)],[tr.minY-tr.W/2,tr.minY-tr.W/2],'Color','k');
    %line([0,length(tr.Rxraw)],[tr.minY+tr.W/2,tr.minY+tr.W/2],'Color','k');
    %line([0,length(tr.Rxraw)],[tr.maxY-tr.W/2,tr.maxY-tr.W/2],'Color','k');
    %line([0,length(tr.Rxraw)],[tr.maxY+tr.W/2,tr.maxY+tr.W/2],'Color','k');
    hold('off');
end

function  plot_phase_plane(ts,ax)
    if nargin==1
        plot(ts.x,ts.v, 'b');
    else
        plot(ax,ts.x,ts.v, 'b');
    end
    %axis([min(tr.x) max(tr.x) min(tr.v) max(tr.v)]);
end

function  plot_hook_plane(ts,ax)
    if nargin==1
        plot(ax,ts.x,ts.a, 'b');
    else
        plot(ax,ts.x,ts.a, 'b');
    end
    %axis([min(tr.x) max(tr.x) min(tr.a) max(tr.a)]);
end

function  plot_jerk_vs_x(ts,ax)
    hold on
    if nargin==1, 
        plot(ts.x,ts.jerk,'r'); 
    else
        plot(ax,ts.x,ts.jerk,'r'); 
    end
    hold on
end

function  plot_jerk_vs_v(ts,ax)
    hold on
    if nargin==1, 
        plot(ts.v,ts.jerk,'r'); 
    else
        plot(ax,ts.v,ts.jerk,'r'); 
    end
    hold on
end

function  plot_jerk_vs_a(ts,ax)
    hold on
    if nargin==1, 
        plot(ts.a,ts.jerk,'r'); 
    else
        plot(ax,ts.a,ts.jerk,'r'); 
    end
    hold on
end
