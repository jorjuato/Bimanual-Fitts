function plot_va(obj,graphPath)
    if nargin<2, graphPath=''; end    
    if ~exist(graphPath,'dir') & obj.conf.interactive==0
        mkdir(graphPath);
    end
    
    S= obj.sessions;
    [IDL, IDR, ~] = size(S(1).bimanual.data_set);

    for i=1:IDL
        for j=1:IDR
            %Create figure and name it
            if obj.conf.interactive==0
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
                DSl{i,end}.plot_va(ax);
                ylabel(sprintf('S%d',n),'fontsize',9,'fontweight','b');
                set(get(gca,'YLabel'),'Rotation',0);
                
                if n==1
                    title('Unimanual Left','fontsize',9,'fontweight','b');
                end
                
                ax=subplot(3,4,(n-1)*4+2); 
                DSb{i,j,end}.plot_va(ax,'L');
                if n==1
                    title('Bimanual Left','fontsize',9,'fontweight','b');
                end
                
                ax=subplot(3,4,(n-1)*4+3); 
                DSb{i,j,end}.plot_va(ax,'R');
                if n==1
                    title('Bimanual Right','fontsize',9,'fontweight','b');
                end
                ax=subplot(3,4,(n-1)*4+4);
                DSr{j,end}.plot_va(ax);
                if n==1
                    title('Unimanual Right','fontsize',9,'fontweight','b');
                end
                                
            end
            name=sprintf('LearningVectorAnglesIDL%1dIDR%1d',round(DSl{i,1}.info.ID),round(DSr{j,1}.info.ID));
            if obj.conf.interactive==1
                suplabel(name,'t',[.1 .1 .84 .84]);
            end
            if exist(graphPath,'dir') & obj.conf.interactive==0                
                figname = joinpath(graphPath,name); 
                saveas(fig,figname,obj.conf.ext);
                close(fig);
            end
        end
    end
end
