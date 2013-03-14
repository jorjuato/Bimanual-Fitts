
function plot_lockingStrength(obj)
    graphPath=joinpath(obj.conf.plot_block_path,'lockingStrength');
    if ~exist(graphPath,'dir') & obj.conf.interactive==0
        mkdir(graphPath);
    end
    
    if obj.conf.unimanual==1
        return
    end
    
    DS = obj.data_set;    
        
    [IDL, IDR, rep] = size(DS);
    [fields, names, labels, ylims] = get_ls_plots();
    

    %Fetch data
    data=zeros(IDL,IDR,length(fields),3); %IDRef,mean(Prop), stdev(Prop)
    IDLs=zeros(IDL,1);
    IDRs=zeros(IDR,1);
    for f1=1:IDL
        IDLs(f1) =DS{f1,1,1}.ts.LID;
        for f2=1:IDR        
            IDRs(f2) = DS{1,f2,1}.ts.RID;
            for f=1:length(fields)
                data(f1,f2,f,1)=mean(DS{f1,f2,end}.ls.(fields{f}));
                data(f1,f2,f,2)=ste(DS{f1,f2,end}.ls.(fields{f}));
            end
        end
    end
                   
    %Plot all        
    for f=1:length(fields)
        if obj.conf.interactive==0
            fig = figure('visible','off');
        else
            fig = figure();
        end
        set(fig,'Name',names{f});
        hold on;
        h = bar(IDLs,data(:,:,f,1),'grouped');
        x = getBarCentroids(get(get(h(1),'children'),'xdata'));         
        errorbar(x,data(:,1,f,1),data(:,1,f,2),'k', 'linestyle', 'none', 'linewidth', 1);        
        x = getBarCentroids(get(get(h(2),'children'),'xdata'));         
        errorbar(x,data(:,2,f,1),data(:,2,f,2),'k', 'linestyle', 'none', 'linewidth', 1);
        
        red = [1,0,0];
        %blue = [0,0,1];
        %legendCell = cell(2*Sno);
        for s=1:IDR                      
            set(h(s),'FaceColor',red/s,'EdgeColor','k');
            %set(h(Sno+s),'FaceColor',blue/s,'EdgeColor','k');
            legendCell{s} = sprintf('Right ID %1.1f',IDRs(s));
        end
        
        hl = legend(h(1:IDR),legendCell{1:IDR});
        set(hl,'FontSize',8);      
        set(gca,'XTick',sort(IDLs));
        ylabel(labels{f});
%        ylim(ylims{f});
        hold off;
        if exist(graphPath) & obj.conf.interactive==0
            figname = joinpath(graphPath,fields{f});
            saveas(fig,figname,obj.conf.ext); close(fig);
        end
    end
end


function [fields, names, labels, ylims] = get_ls_plots()

    fields= {...
            %'Rf',...
            %'Lf',...
            'rho',...
            'flsPC',...
            'flsAmp',...
            'phDiffMean',...
            'phDiffStd'};
            

    names = {...
            % 'Frequency'...
            %,'Frequency'...
            'Frequency Quotient'...
            ,'Frequency Locking Strength PC'...
            ,'Frequency Locking Strength Amplitude'...
            ,'Phase Difference Mean'...
            ,'Phase Difference Stdev'...
            };
    labels = {...
            % 'Frequency (Hz)'...
            %,'Frequency (Hz)'...
            'Frequency Quotient'...
            ,'FLS Pure Coordination'...
            ,'FLS Amplitude'...
            ,'Mean Phase Difference (rad)'...
            ,'Stdev Phase Difference (rad)'...
            };
    ylims = {...
            %  [0,5]...
            % ,[0,5]...
             [0,5]...
             ,[]...
             ,[]...
             ,[-2*pi,2*pi]...
             ,[-2*pi,2*pi]};
end
