function arr = plot_learning_vf(pp,graphPath)
    if nargin<2, graphPath=getuserdir(); end    
    if ~exist(graphPath,'dir') & pp.conf.interactive==0
        mkdir(graphPath);
    end
    
    [IDL IDR rep]=size(pp(1).bimanual.data_set);
    arr = cell([IDL, IDR, 6]);
    
    for s=1:3
        DSB = pp(s).bimanual.data_set;
        %DSL = data(s).uniLeft;
        %DSR = data(s).uniRight;
        for r=1:IDR
            for l=1:IDL
               tmp=DSB{l,r,end}.vfL.angles{2};
               tmp(isnan(tmp))=0;
               tmp(tmp<pi/2)=0;
               arr{l,r,n}=max(tmp);
               tmp=DSB{l,r,end}.vfR.angles{2};
               tmp(isnan(tmp))=0;
               tmp(tmp<pi/2)=0;
               arr{l,r,s+3}=max(tmp);
            end
        end
    end
    %return
    %Now plot all the stuff
    rootname = sprintf('Learning-vf');
    if pp.conf.interactive==0
        fig = figure('visible','off');
    else
        fig = figure();
    end
    plotnum=0;
    c=['r','g','b','r','g','b'];
    titledone = 0;
    for r=1:IDR
        for l=1:IDL
            %Left hand vector field
            plotnum = plotnum+1;
            subplot(IDR,IDL*2+1,plotnum);
            hold on;
            for a=1:3 
                plot(arr{l,r,a},c(a));
            end
            ylim([0,pi]);
            hold off;
            if r==1 & l==1 & titledone == 0
                title(sprintf('\t\t IDL=%1.2f',blk{1,1,1}.info.LID),'fontsize',18,'fontweight','b');
                titledone = 1;
            end
            if r==1 & l==2 & titledone == 1
                title(sprintf('\t\t IDL=%1.2f',blk{2,1,1}.info.LID),'fontsize',18,'fontweight','b');
                titledone = 2;
            end
            if l==1
                txt = sprintf('IDR=%1.2f',blk{l,r,1}.info.RID);
                ylabel(txt,'fontsize',10,'fontweight','b');
            end
            if r==IDR, xlabel('Left Hand'); end
            
            %Right hand vector field
            plotnum = plotnum+1;
            subplot(IDR,IDL*2+1,plotnum);
            hold on;
            for a=4:6
                plot(arr{l,r,a},c(a));
            end
            ylim([0,pi]);
            hold off;
            if l==1, plotnum=plotnum+1; end
            if r==IDR, xlabel('Right Hand'); end
        end
    end
    if exist(graphPath,'dir') & pp.conf.interactive==0
        filename = sprintf('%s-BlockVectorAngles',rootname);
        figname = [joinpath(graphPath,filename),'.',obj.conf.ext];
        saveas(fig,figname);
        close(fig);
    end
