function plot_all_peakDelays3D(xp,plot_type)
    if nargin<1, xp=Experiment(); end
    if nargin<2, plot_type='waterfall'; end
    
    %Get data for each 3D hist plot
    x = -1:0.05:1;
    for p=1:10
        pp=xp(p);  
        scrsz = get(0,'ScreenSize');
        figure('Position',[1 1 scrsz(3) scrsz(4)-100]);
        set(gcf,'name',pp.conf.name);
        bar_series=cell(2,3);
        for s=1:3 
            for l=1:2
                for r=1:3
                    d=[];
                    for rep=1:3
                        tr=pp(s).bimanual{l,r,rep};
                        pks=tr.oscR.minPeakDistance/1000;
                        if length(tr.oscR.MT) == length(pks)
                            d=[d;pks./tr.oscR.MT];
                        else
                            d=[d;pks./tr.oscL.MT];
                        end
                    end
                    n=hist(d,x);
                    bar_series{l,r}=[bar_series{l,r}; n];
                end
            end
        end    
        %do the plotting
        cnt=0;
        for l=1:2
            for r=1:3
                cnt=cnt+1;
                subplot(2,3,cnt);
                if strcmp(plot_type,'waterfall')
                    [X,Y]=meshgrid(x,[0.05,0.1,.15]);
                    waterfall(X,Y,bar_series{l,r});
                    view([-12,15]);
                    caxis([1 2]);
                else
                    bar3(x,bar_series{l,r}');
                    view([-12,15])
                end
                %xlim([-1, 1]);
            end
        end
    end
end