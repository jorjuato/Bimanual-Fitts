function plot_va(obj,graphPath,rootname,ext)
    % Plotting Modes:
    % 1 -> All graphs in same figure
    % 2 -> Left and right fields in different figures
    % 3 -> One figure for each couple of L/R per trial
    % 4 -> One figure for each couple of L/R per trial, with vector angles    
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath='';end
    
    DS = obj.data_set;       
    
    if graphPath
        fig = figure('visible','off');
    else
        fig = figure();
    end
    
    if obj.unimanual
        [ID ~] = size(DS);
        for i=1:ID
            ax=subplot(1,ID,i);
            tr=DS{i,1};
            tr.plot_va(ax);
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
                tr.plot_va(axL,'L');
                axR=subplot(IDL*2,IDR,((i-1)*2+1)*IDR+j);                
                tr.plot_va(axR,'R');
                %Now put titles and axes
                if i==1                    
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
    if graphPath
        filename = sprintf('%s-BlockVectorAngles',rootname);
        figname = joinpath(graphPath,filename);
        saveas(fig,figname,ext);
        close(fig);
    end
end
