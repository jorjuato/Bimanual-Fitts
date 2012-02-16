function plot_vectorFields(obj,mode,graphPath,rootname,ext)
    % Plotting Modes:
    % 1 -> All graphs in same figure
    % 2 -> Left and right fields in different figures
    % 3 -> One figure for each couple of L/R per trial
    % 4 -> One figure for each couple of L/R per trial, with vector angles    
    if nargin<5, ext='fig';end
    if nargin<4, rootname='nosession';end
    if nargin<3, graphPath='';end
    if nargin<2, mode=1;end
    
    if lenght(obj.size) == 2
        return
    end
    
    [IDL IDR ~] = obj.size;
    DS = obj.data_set;
    if mode==1 %All graphs in same figure
        if graphPath
            fig = figure('visible','off');
        else
            fig = figure();
        end
        plotnum=0;
        titledone = 0;
        for i=1:IDR
            for j=1:IDL
                %Left hand vector field
                plotnum = plotnum+1;
                subplot(IDR,IDL*2+1,plotnum); 
                subplot_vf(DS{j,i,end},'L');
                ylabel(sprintf('IDR=%1.2f',DS{j,i,1}.info.IDR),'fontsize',10,'fontweight','b'); 
                xlabel('Left Hand','fontsize',10,'fontweight','b');
                %Shall we plot the title?
                if i==1 & j==1 & titledone == 0
                    title(sprintf('\t IDL=%1.2f',DS{1,1,1}.info.IDL),'fontsize',12,'fontweight','b');                     
                    titledone = 1;
                elseif i==1 & j==2 & titledone == 1
                    title(sprintf('\t IDL=%1.2f',DS{2,1,1}.info.IDL),'fontsize',12,'fontweight','b');                     
                    titledone = 2;
                end 
                %Right hand vector field
                plotnum = plotnum+1;
                subplot(IDR,IDL*2+1,plotnum); 
                subplot_vf(DS{j,i,end},'R');
                xlabel('Right Hand','fontsize',10,'fontweight','b');
                if j==1, plotnum=plotnum+1; end
            end
        end
        if graphPath
            filename = sprintf('%s-BlockVectorFields',rootname);
            figname = joinpath(graphPath,filename);
            saveas(fig,figname,ext);
            close(fig);
        end
    elseif mode==2 %Left and right fields in different figures
        if graphPath
            figR=figure('visible','off'); 
            figL=figure('visible','off');
        else
            figR=figure(); 
            figL=figure();
        end
        plotnum=0;
        for i=1:IDL
            for j=1:IDR
                plotnum = plotnum+1;
                %Left hand vector field
                set(0,'CurrentFigure',figL);
                subplot(IDR*2,IDL,plotnum);
                subplot_vf(DS{i,j,end},'L');            
                %Right hand vector field
                set(0,'CurrentFigure',figR);
                subplot(IDR*2,IDL,plotnum); 
                subplot_vf(DS{i,j,end},'R');        
            end
        end
        if graphPath
            filename = sprintf('%s-BlockVectorFields',rootname);
            fignameR = joinpath(graphPath,strcat(filename,'Right'));
            fignameL = joinpath(graphPath,strcat(filename,'Left'));
            saveas(figR,fignameR,ext);
            saveas(figR,fignameL,ext);
            close(figR,figL);
        end
    elseif mode==3 %One figure for each couple of L/R per trial
        for i=1:IDL
            for j=1:IDR
                if graphPath
                    fig=figure('visible','off');
                else
                    fig=figure();
                end
                %Left hand vector field
                subplot(1,2,1);
                subplot_vf(DS{i,j,end},'L');            
                %Right hand vector field
                subplot(1,2,2); 
                subplot_vf(DS{i,j,end},'R');
                if graphPath
                    filename = sprintf('%s-Trial_%d_%d_VectorFields',rootname,i,j);
                    figname = joinpath(graphPath,filename);
                    saveas(fig,figname,ext);
                    close(fig);
                end
            end
        end
    elseif mode==4 %One figure for each couple of L/R per trial, with angles too
        for i=1:IDL
            for j=1:IDR
                if graphPath
                    fig=figure('visible','off');
                else
                    fig=figure();
                end
                %Left hand vector field and vector angles
                subplot(2,2,1);
                subplot_vf(DS{i,j,end},'L');
                subplot(2,2,3);
                imagesc(flipud(DS{i,j,end}.vfL.angles{2}),[0 pi]);
                %Right hand vector field and vector angles
                subplot(2,2,2); 
                subplot_vf(DS{i,j,end},'R');
                subplot(2,2,4);
                imagesc(flipud(DS{i,j,end}.vfR.angles{2}),[0 pi]);
                colorbar;
                if graphPath
                    filename = sprintf('%s-Trial_%d_%d_VectorFields_VectorAngles',rootname,i,j);
                    figname = joinpath(graphPath,filename);
                    saveas(fig,figname,ext);
                    close(fig);
                end
            end
        end
  
    end
end

function subplot_vf(tr,hand)
    h=ishold;
    if strcmp(hand,'L')
        plot(tr.ts.Lxnorm,tr.ts.Lvnorm,'color',[1,.7,1]);
        %Prepare grid to plot vectors and select non Nan values
        idx=isfinite(tr.vfL.vectors{1}) & isfinite(tr.vfL.vectors{2});
        [X,Y]=meshgrid(tr.vfL.vectors{end}{1},tr.vfL.vectors{end}{2});
        hold on;
        quiver(X(idx),Y(idx),tr.vfL.vectors{1}(idx),tr.vfL.vectors{2}(idx));
    else
        plot(tr.ts.Rxnorm,tr.ts.Rvnorm,'color',[1,.7,1]);
        %Prepare grid to plot vectors and select non Nan values
        idx=isfinite(tr.vfR.vectors{1}) & isfinite(tr.vfR.vectors{2});
        [X,Y]=meshgrid(tr.vfR.vectors{end}{1},tr.vfR.vectors{end}{2});
        hold on;
        quiver(X(idx),Y(idx),tr.vfR.vectors{1}(idx),tr.vfR.vectors{2}(idx));
    end
    if ~h
        hold off;
    end
    axis tight;
end
