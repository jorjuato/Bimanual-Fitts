function arr = plot_vf(obj,graphPath,ext)
    if nargin<3, ext='png';end
    if nargin<2, graphPath=joinpath(joinpath(getuserdir(),'KINARM'),'plots');end
    %if nargin<2, graphPath='';end

    S= obj.sessions;
    [IDL, IDR, ~] = size(S(1).bimanual.data_set);
    
    for i=1:IDL
        for j=1:IDR
            %Create figure and name it
            if graphPath
                fig = figure('visible','off');
            else
                fig = figure();
            end
            %Iterate over valid sessions
            for n=1:3
                s=3*(n-1)+1;
                DSb = obj.sessions(s).bimanual.data_set;
                DSl = obj.sessions(s).uniLeft.data_set;
                DSr = obj.sessions(s).uniRight.data_set;      
                
                ax=subplot(3,4,(n-1)*4+1);
                DSl{i,1}.plot_va(ax);
                ylabel(sprintf('S%d',n),'fontsize',9,'fontweight','b');
                set(get(gca,'YLabel'),'Rotation',0);
                
                if n==1
                    title('Unimanual Left','fontsize',9,'fontweight','b');
                end


                ax=subplot(3,4,(n-1)*4+2); 
                DSb{i,j,1}.plot_va(ax,'L');
                if n==1
                    title('Bimanual Left','fontsize',9,'fontweight','b');
                end
                
                ax=subplot(3,4,(n-1)*4+3); 
                DSb{i,j,1}.plot_va(ax,'R');
                if n==1
                    title('Bimanual Right','fontsize',9,'fontweight','b');
                end
                ax=subplot(3,4,(n-1)*4+4);
                DSr{j,1}.plot_va(ax);
                if n==1
                    title('Unimanual Right','fontsize',9,'fontweight','b');
                end
                                
            end
            name=sprintf('LearningVectorAnglesIDL=%1.1f IDR=%1.1f',DSl{i,1}.info.ID,DSr{j,1}.info.ID);
            suplabel(name,'t',[.1 .1 .84 .84]);
            if graphPath                
                figname = strcat(strcat(joinpath(graphPath,name),'.'),ext);       
                saveas(fig,figname);
                close(fig);
            end
        end
    end
end
