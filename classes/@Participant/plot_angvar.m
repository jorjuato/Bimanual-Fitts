function plot_angvar(obj,vname,graphPath)
    if nargin<3, graphPath=obj.conf.plot_participant_path; end    
    if nargin<2, vname='omega'; end
    
    if ~exist(graphPath,'dir') & obj.conf.interactive==0
        mkdir(graphPath);
    end 
    
    S=obj.sessions;
    [IDL, IDR, ~] = size(S(1).bimanual.data_set);
    lnames={'Easy','Diff'};
    rnames={'Easy','Med','Diff'};
    r=1;
    for i=1:IDL
        for j=1:IDR
            %Create figure and name it
            if obj.conf.interactive==0
                fig = figure('visible','off');
            else
                fig = figure();
            end
            
            ylimits=obj.get_ylimits(i,j,vname);
            
            %Iterate over valid sessions
            for n=1:3
                s=3*(n-1)+1;
                DSb = obj.sessions(s).bimanual.data_set;
                DSl = obj.sessions(s).uniLeft.data_set;
                DSr = obj.sessions(s).uniRight.data_set;                    
                
                %Plot Unimanual Left
                ax=subplot(3,4,(n-1)*4+1);
                DSl{i,r}.plot_angvar(ax,vname);
                ylabel(sprintf('S%d',n),'fontsize',9,'fontweight','b');
                set(get(gca,'YLabel'),'Rotation',0);
                ylim(ax,ylimits(1,:)); 
                if n==1, title('Unimanual Left','fontsize',9,'fontweight','b'); end
                
                %Plot Bimanual Left
                ax=subplot(3,4,(n-1)*4+2); 
                DSb{i,j,r}.plot_angvar(ax,vname,'L');
                ylim(ax,ylimits(2,:));
                if n==1, title('Bimanual Left','fontsize',9,'fontweight','b'); end
                
                %Plot Bimanual Right
                ax=subplot(3,4,(n-1)*4+3); 
                DSb{i,j,r}.plot_angvar(ax,vname,'R');
                ylim(ax,ylimits(3,:));
                if n==1, title('Bimanual Right','fontsize',9,'fontweight','b'); end
                
                %Plot Unimanual Right
                ax=subplot(3,4,(n-1)*4+4);
                DSr{j,r}.plot_angvar(ax,vname);
                ylim(ax,ylimits(4,:));
                if n==1, title('Unimanual Right','fontsize',9,'fontweight','b'); end
                                
            end
            %name=sprintf('LearningVectorAnglesIDL%1dIDR%1d',round(DSl{i,1}.info.ID),round(DSr{j,1}.info.ID));
            name=sprintf('Learning-%s-histogram_L-%s_R-%s',vname,lnames{i},rnames{j});
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
