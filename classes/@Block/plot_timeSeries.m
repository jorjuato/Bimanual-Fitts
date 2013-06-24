% Plots results from a bimanual Fitts experiment withvariation of 
% either the phase (in-phase/anti-phase) or the viscosity.
% All plotting functionare included in the file. It won't work
% with DS structures generated with getMultiResults_fb because it lacks 
% Factor2 parameter, and experiments done before the inclusion of Loads
% won't load with getMultiResults_fbFull because it lacks a Load parameter
% in TP table. 


function  plot_timeSeries(obj)
    graphPath=joinpath(obj.conf.plot_block_path,'timeSeries');
    if ~exist(graphPath,'dir') & obj.conf.interactive==0
        mkdir(graphPath);
    end
    
    rep=obj.conf.replication_ts;
    DS = obj.data_set;

    %Retrieve sorted data and processing methods from auxiliar functions
    if obj.conf.unimanual     
        [F1, ~] = size(DS);        
        [fcns, names, xlabels, ylabels] = DS{1,rep}.ts.get_plots();
    else
        [F1, F2, ~] = size(DS);
        [fcns, names, xlabels, ylabels] = DS{1,1,rep}.ts.get_plots();        
    end 
    
    %Create figures    
    figs=cell(length(fcns));
    for f=1:length(fcns)
        if obj.conf.interactive==0
            figs{f} = figure('visible','off');
        else
            figs{f}=figure();
        end
    end
    
    
    if obj.conf.unimanual
        %Fill it with subplots, one for each exp. condition
        for f1=1:F1
            %Create subplots 
            ax=cell(length(fcns));
            for f=1:length(fcns)
                set(0, 'CurrentFigure', figs{f});
                ax{f}=subplot(1,F1,f1);
            end
            
            %Call plotting function
            DS{f1,rep}.ts.plot(ax);
            
            %Tune plots
            for f=1:length(fcns)
                ylabel(ax{f},strcat('ID=',num2str(DS{f1,1}.info.ID,2)),...
                  'fontweight','b','Rotation',0,...
                  'BackgroundColor',[.7 .9 .7]);
            end
        end
    else
        %Fill it with subplots, one for each exp. condition
        for f1=1:F1
            for f2=1:F2
                %Create subplots 
                ax=cell(length(fcns));
                for f=1:length(fcns)
                    set(0, 'CurrentFigure', figs{f});
                    ax{f}=subplot(F1,F2,(f1-1)*F2+f2);
                end
                
                %Call plotting function
                DS{f1,f2,rep}.ts.plot(ax);
                
                %Tune plots
                for f=1:length(fcns)
                    %Put the title only in top subplots
                    if f1==1;
                        tit = sprintf('IDR=%1.1f / IDL=%1.1f',DS{f1,f2,1}.info.LID,DS{f1,f2,1}.info.RID);
                        title(ax{f},tit,'fontsize',10,'fontweight','b'); 
                    end
                    %Chapucilla
                    if f1==2
                        title(ax{f},sprintf('IDR=%1.1f / IDL=%1.1f',DS{f1,f2,1}.info.LID,DS{f1,f2,1}.info.RID),'fontsize',10,'fontweight','b');
                    end
                    %Put y-label only in left-most subplots
                    if f2==1
                        ylabel(ax{f},ylabels{f});
                    else
                        ylabel(ax{f},'');
                    end
                    %Put x-label only in bottom subplots
                    if f1==F1
                        xlabel(ax{f},xlabels{f});
                    else
                        xlabel(ax{f},'');
                    end
                end%for f=1:length(fcns)
            end%for f2=1:F2
        end%for f1=1:F1
    end%if length(obj.size)
    
    for f=1:length(fcns)
        set(figs{f},'Name',sprintf('%s Replication %i',names{f},rep));
        if exist(graphPath,'dir') && obj.conf.interactive==0
            figname = joinpath(graphPath,names{f});
            saveas(figs{f},figname,obj.conf.ext);
            close(figs{f});
        end
    end
end











