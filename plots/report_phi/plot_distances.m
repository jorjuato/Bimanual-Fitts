function plot_distances(tr,filename)
    if nargin<2, filename=''; end  

    scrsz = get(0,'ScreenSize');
    figure('Position',[1 1 scrsz(3)/2 scrsz(4)-100]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot time series of position and velocity
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    plot_time_series(tr.ts,subplot(5,4,[1,2]));
    yl=ylabel('Time series','rot',0,'FontWeight','bold');
    set(yl,'Position',get(yl,'Position') - [3 0 0]);
    
    subplot(5,4,3)
    f=tr.ts.freq;
    plot(f,tr.ts.LPxx,'r');
    xlim([0,5]);
    
    subplot(5,4,4)
    plot(f,tr.ts.RPxx,'b');
    xlim([0,5]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot 4D distance
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    subplot(5,4,[5,6])
    plot(phasedist4D(tr));
    %plot(tr.ls.d4D);
    yl=ylabel('4D distance','rot',0,'FontWeight','bold');
    set(yl,'Position',get(yl,'Position') - [3 0 0]);
    
    subplot(5,4,7)
    hist(phasedist4D(tr));
    
    subplot(5,4,8)
    [Pxx, f] = get_welch_periodogram(detrend(phasedist4D(tr)));
    plot(f,Pxx)
    xlim([0 5]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot 3D distance
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    subplot(5,4,[9,10])
    plot(phasedist3D(tr));
    %plot(tr.ls.d3D);
    yl=ylabel('3D distance','rot',0,'FontWeight','bold');
    set(yl,'Position',get(yl,'Position') - [3 0 0]);
    
    subplot(5,4,11)
    hist(phasedist3D(tr));
    
    subplot(5,4,12)
    [Pxx, f] = get_welch_periodogram(detrend(phasedist3D(tr)));
    plot(f,Pxx)
    xlim([0 5]);    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot 2D distance
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    subplot(5,4,[13, 14])
    plot(phasedist2D(tr));
    %plot(tr.ls.d2D);
    yl=ylabel('2D distance','rot',0,'FontWeight','bold');
    set(yl,'Position',get(yl,'Position') - [3 0 0]);
    
    subplot(5,4,15)
    hist(phasedist2D(tr));
    
    subplot(5,4,16)
    [Pxx, f] = get_welch_periodogram(detrend(phasedist2D(tr)));
    plot(f,Pxx)
    xlim([0 5]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot 1D distance
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    subplot(5,4,[17,18])
    %plot(phasedist1D(tr));
    plot(tr.ls.phDiff);
    yl=ylabel('1D distance','rot',0,'FontWeight','bold');
    set(yl,'Position',get(yl,'Position') - [3 0 0]);
    
    subplot(5,4,19)
    hist(phasedist1D(tr));
    
    subplot(5,4,20)
    [Pxx, f] = get_welch_periodogram(detrend(phasedist1D(tr)));
    plot(f,Pxx)
    xlim([0 5]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Save to disk if filename provided
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~isempty(filename)
        %saveas(gcf,filename,'png');
        options.Format = 'png';
        hgexport(gcf,[filename '.png'],options);
        close
    end
    
end