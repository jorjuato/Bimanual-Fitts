function bar_series = plot_participant_peakDelays(pp)
    figure;
    set(gcf,'name',pp.conf.name);
    ax={};
    bar_series={};
    color=get_colors();
    for s=3:-1:1
        cnt=0;
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
                cnt=cnt+1;
                if s==3
                    ax{l,r}=subplot(2,3,cnt);
                end
                hold(ax{l,r},'on')
                [n xout]=hist(ax{l,r},d,15);
                bar_series{l,r,s}=[xout, n];
                bar(ax{l,r},xout,n,'FaceColor',[color{s}]);
                if s==1
                    xlim(ax{l,r},[-1, 1]);
                end
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function color=get_colors()
colors= {   [1 1 0],[1 1 .1],[1 1 .2],... %yellow
            [1 0 1],[1 .1 1],[1 .2 1],... %magenta
            [0 1 1],[.1 1 1],[.2 1 1],... %cyan
            [1 0 0],[1 .1 0],[1 .2 0],... %red
            [0 1 0],[0 1 .1],[0 1 .2],... %green
            [0 0 1],[.1 0 1],[.2 0 1],... %blue
            [0 0 0],[.1 .1 .1],[.2 .2 .2],... %black
            [0 .5 .5],[.1 .5 .5],[.2 .5 .5],... %teal
            [.5 .5 0],[.5 .5 .1],[.5 .5 .2],... %olive
            [.5 0 .5],[.5 .1 .5],[.5 .2 .5] ... %purple
        };
color=colors([10,13,16]);
end