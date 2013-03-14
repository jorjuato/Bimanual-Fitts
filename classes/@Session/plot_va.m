function plot_va(obj,graphPath)
    DSb = obj.bimanual.data_set;
    DSl = obj.uniLeft.data_set;
    DSr = obj.uniRight.data_set;
    
    if obj.conf.interactive==0
        fig = figure('visible','off');
    else
        fig = figure();
    end
    
    [IDL IDR ~] = size(DSb);
    for i=1:IDL
        for j=1:IDR
            tr=DSb{i,j,end};
            
            %Plot left hand
            axL=subplot(IDL*2+1,IDR+1, (i-1)*2*(IDR+1) + j);            
            tr.plot_va(axL,'L');                
            set(axL,'LooseInset',get(axL,'TightInset'));
            
            %Plot right hand
            axR=subplot(IDL*2+1,IDR+1,((i-1)*2+1)*(IDR+1)+j);            
            tr.plot_va(axR,'R');
            set(axR,'LooseInset',get(axR,'TightInset'));   
            
            %Now put titles and axes
            if j==1
                ylabel(axL,'Left Hand','fontsize',12,'fontweight','b');
                ylabel(axR,'Right Hand','fontsize',12,'fontweight','b');
            end
            if i==IDL
                
            end
        end
    end 
    for i=1:IDL
        tr=DSl{i,end};
        %ax=subplot(IDL*2+1,IDR+1, (i-1)*2*(IDR+1) + 4);                
        ax=subplot(IDL*2+1,IDR+1, [4 8]+8*(i-1));                
        tr.plot_va(ax);
        ylabel(ax,sprintf('Left ID=%1.1f',tr.info.ID),'fontsize',12,'fontweight','b');
        set(ax,'yaxislocation','right');
        set(ax,'LooseInset',get(ax,'TightInset'));   
    end
    for i=1:IDR
        tr=DSr{i,end};
        ax=subplot(IDL*2+1,IDR+1, 4*(IDR+1) + i);                
        tr.plot_va(ax);
        xlabel(ax,sprintf('Right ID=%1.1f',tr.info.ID),'fontsize',12,'fontweight','b');
        set(ax,'LooseInset',get(ax,'TightInset'));   
    end
    if exist(obj.conf.plot_session_dir,'dir') & obj.conf.interactive==0           
        figname = joinpath(obj.conf.plot_session_dir,'SessionVectorAngles');
        saveas(fig,figname,obj.conf.ext);
        close(fig);
    end
end
