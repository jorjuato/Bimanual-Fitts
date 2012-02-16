function arr = plot_learning_vf(obj,graphPath,ext)
    if nargin<3, ext='fig';end
    if nargin<2, graphPath='';end

    S= obj.sessions;
    session=S(1)
    blk=S(1).bimanual;
    [IDL IDR rep]=session.bimanual;
    %vfSize = size(data(1).bimanual{1,1,end}.Lva{1},2);    
    arr = cell([IDL, IDR, 6]);   
    
    for n=1:3
        s=3*(n-1)+1;
        DSB = S(s).bimanual;
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
               arr{l,r,n+3}=max(tmp);
            end
        end
    end
    %return
    %Now plot all the stuff
    if graphPath
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
                title(sprintf('\t\t IDL=%1.2f',blk{1,1,1}.info.IDL),'fontsize',18,'fontweight','b');
                titledone = 1;
            end
            if r==1 & l==2 & titledone == 1
                title(sprintf('\t\t IDL=%1.2f',blk{2,1,1}.info.IDL),'fontsize',18,'fontweight','b');
                titledone = 2;
            end
            if l==1
                txt = sprintf('IDR=%1.2f',blk{l,r,1}.IDR);
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
    if graphPath
        filename = sprintf('%s-BlockVectorAngles',rootname);
        figname = joinpath(graphPath,filename);
        saveas(fig,figname,ext);
        close(fig);
    end
