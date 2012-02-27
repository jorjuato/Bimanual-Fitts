function plot_vf(obj)
    graphPath=joinpath(obj.conf.plot_block_path,'vectorField');
    if ~exist(graphPath,'dir') & obj.conf.interactive==0
        mkdir(graphPath);
    end
    
    DS = obj.data_set;       
    
    if obj.conf.interactive==0
        fig = figure('visible','off');
    else
        fig = figure();
    end
    
    if obj.conf.unimanual
        [ID ~] = size(DS);
        for i=1:ID
            ax=subplot(1,ID,i);
            tr=DS{i,1};
            tr.plot_vf(ax)
            %ylabel(sprintf('ID=%1.2f',DS{i,1}.info.ID),'fontsize',10,'fontweight','b'); 
            %xlabel('Left Hand','fontsize',10,'fontweight','b');
            if ID==2
                hand='Left';
            else
                hand='Right';
            end
            title(sprintf('\t ID=%1.2f %s',DS{i,1}.info.ID, hand),'fontsize',12,'fontweight','b');              
        end
    else
        [IDL IDR ~] = size(DS);
        for i=1:IDL
            for j=1:IDR
                tr=DS{i,j,1};
                axL=subplot(IDL*2,IDR, (i-1)*2*IDR + j);                
                tr.plot_vf(axL,'L');                
                axR=subplot(IDL*2,IDR,((i-1)*2+1)*IDR+j);
                tr.plot_vf(axR,'R');
                %Now put titles and axes
                if j==1              
                    ylabel(axL,sprintf('Left ID=%d',tr.info.LID));
                end
                if j==IDR
                    ylabel(axL,'Left Hand');
                    ylabel(axR,'Right Hand');
                end
                if i==IDL
                    xlabel(axR,sprintf('Right ID=%d',tr.info.RID));
                end
            end
        end    
    end
    if exist(graphPath) & obj.conf.interactive==0
        figname = joinpath(graphPath,'BlockVectorFields');
        saveas(fig,figname,obj.conf.ext);
        close(fig);
    end
end
