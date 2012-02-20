function plot_vf(obj,graphPath,rootname,ext)
    % Plotting Modes:
    % 1 -> All graphs in same figure
    % 2 -> Left and right fields in different figures
    % 3 -> One figure for each couple of L/R per trial
    % 4 -> One figure for each couple of L/R per trial, with vector angles    
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath='';end
    
    DSb = obj.bimanual.data_set;
    DSl = obj.uniLeft.data_set;
    DSr = obj.uniRight.data_set;
    
    if graphPath
        fig = figure('visible','off');
    else
        fig = figure();
    end
    
    [IDL IDR ~] = size(DSb);
    for i=1:IDL
        for j=1:IDR
            tr=DSb{i,j,1};
            
            %Plot left hand
            axL=subplot(IDL*2+1,IDR+1, (i-1)*2*(IDR+1) + j);            
            tr.plot_vf(axL,'L');                
            set(axL,'LooseInset',get(axL,'TightInset'));
            
            %Plot right hand
            axR=subplot(IDL*2+1,IDR+1,((i-1)*2+1)*(IDR+1)+j);            
            tr.plot_vf(axR,'R');
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
        tr=DSl{i,1};
        %ax=subplot(IDL*2+1,IDR+1, (i-1)*2*(IDR+1) + 4);                
        ax=subplot(IDL*2+1,IDR+1, [4 8]+8*(i-1));                
        tr.plot_vf(ax);
        ylabel(ax,sprintf('Left ID=%1.1f',tr.info.ID),'fontsize',12,'fontweight','b');
        set(ax,'yaxislocation','right');
        set(ax,'LooseInset',get(ax,'TightInset'));   
    end
    for i=1:IDR
        tr=DSr{i,1};
        ax=subplot(IDL*2+1,IDR+1, 4*(IDR+1) + i);                
        tr.plot_vf(ax);
        xlabel(ax,sprintf('Right ID=%1.1f',tr.info.ID),'fontsize',12,'fontweight','b');
        set(ax,'LooseInset',get(ax,'TightInset'));   
    end
    if graphPath
        filename = sprintf('%s-BlockVectorFields',rootname);
        figname = joinpath(graphPath,filename);
        saveas(fig,figname,ext);
        close(fig);
    end
end
