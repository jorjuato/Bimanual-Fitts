function  plot_alpha_omega(ts,filename)
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

    Romega=ts.Romega;
    Lomega=ts.Lomega;
    Ralpha=ts.Ralpha;
    Lalpha=ts.Lalpha;
    Rph=ts.Rph;
    Lph=ts.Lph;
    i=1000:(length(Romega)-1000);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Start plotting
    scrsz = get(0,'ScreenSize');
    figure('Position',[1 1 scrsz(3)/4 scrsz(4)/2]);
    set(gcf,'name',filename);

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot time series of positions and velocities
    ax=subplot(3,2,[1,2]);        
    hold on;        
    plot(ax,ts.Lx, 'r');
    plot(ax,ts.Rx, 'b');
    %plot(ax,ts.Lv/5, 'k--');
    %plot(ax,ts.Rv/5, 'g--');
    scatter(ax,ts.Lpeaks,ts.Lx(ts.Lpeaks),'r+');
    scatter(ax,ts.Rpeaks,ts.Rx(ts.Rpeaks),'b+');    
    axis(ax,[0 length(ts.Lx) -0.1 0.1]);
    ylabh=ylabel('Position','rot',0);
    s = struct(handle(ylabh));
    s.Position=s.Position - [3 0 0 ];
    %title(filename);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot omega vs phase
    ax=subplot(3,2,3);    
    scatter(mod(Lph(i),2*pi),Lomega(i), 'r.');
    ylabh=ylabel('Omega vs Phase)','rot',0);
    s = struct(handle(ylabh));
    s.Position=s.Position - [3 0 0 ];
    xlim([0 2*pi]);
    %axis(ax,[0 max 0 omax]);
    
    ax=subplot(3,2,4);    
    scatter(mod(Rph(i),2*pi),Romega(i), 'b.');
    xlim([0 2*pi]);
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot alpha vs phase
    ax=subplot(3,2,5);    
    scatter(mod(Lph(i),2*pi),Lalpha(i), 'r.');
    ylabh=ylabel('Alpha vs Phase)','rot',0);
    s = struct(handle(ylabh));
    s.Position=s.Position - [3 0 0 ];
    xlim([0 2*pi]);
    %axis(ax,[0 max 0 omax]);   
    
    ax=subplot(3,2,6);
    scatter(mod(Rph(i),2*pi),Ralpha(i), 'b.');
    xlim([0 2*pi]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Save file to disk if filename provided
    if ~isempty(filename)
        options.Format = 'png';
        hgexport(gcf,[filename '.png'],options);
        %close
    end
end