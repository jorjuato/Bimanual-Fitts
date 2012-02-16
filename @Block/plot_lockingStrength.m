
function plot_lockingStrength(obj,graphPath,rootname,ext)
    if nargin<4, ext='fig';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath='';end
    
    if obj.unimanual==1
        return
    end
    
    DS = obj.data_set;    
        
    [IDL, IDR, rep] = obj.size;
    [fields, names, labels, ylims] = obj.get_ls_plots();
    

    #Fetch data
    data1=cell(length(fields),3); %IDRef,mean(Prop), stdev(Prop)
    data2=cell(length(fields),3); %IDRef,mean(Prop), stdev(Prop)

    for f2=1:IDR
        for f=1:length(fields)
            for r=1:rep-1
                tmp1{r}=DS{1,f2,r}.ts.RIDef;
                tmp2{r}=DS{2,f2,r}.ts.RIDef;
                tmp3{r}=DS{1,f2,r}.ls.(fields{f});
                tmp4{r}=DS{2,f2,r}.ls.(fields{f});
            end
            data1{f2,1}=mean(tmp1);            
            data1{f2,2}=mean(tmp3);
            data1{f2,3}=ste(tmp3);
            data2{f2,1}=mean(tmp2);
            data2{f2,2}=mean(tmp4);
            data2{f2,3}=ste(tmp4);
        end
    end
                   
    #Plot all        
    for f=1:length(fields)
        if graphPath
            fig = figure('visible','off');
        else
            fig = figure();
        end
        set(fig,'Name',names{f});

        hold on;
        errorbar(data1{:,1},data1{:,2},data1{:,3},'r');
        errorbar(data2{:,1},data2{:,2},data2{:,3},'b');
        h = legend('IDL=2.4','IDL=5.7');
        ylabel(labels{f});
        ylim(ylims{f});
        hold off;
        if graphPath
            filename = sprintf('%s-%s',rootname,fields{f});
            figname = joinpath(graphPath,filename);
            saveas(fig,figname,ext); close(fig);
        end
    end
end


function [fields, names, labels, ylims] = get_ls_plots()

    fields= {...
            'Rf',...
            'Lf',...
            'rho',...
            'flsPC',...
            'flsAmp',...
            'phDiffMean',...
            'phDiffStd'};
            

    names = {...
             'Frequency'...
            ,'Frequency'...
            ,'Frequency Quotient'...
            ,'Frequency Locking Strength PC'...
            ,'Frequency Locking Strength Amplitude'...
            ,'Phase Difference Mean'...
            ,'Phase Difference Stdev'...
            };
    labels = {...
             'Frequency (Hz)'...
            ,'Frequency (Hz)'...
            ,'Frequency Quotient'...
            ,'FLS Pure Coordination'...
            ,'FLS Amplitude'...
            ,'Mean Phase Difference (rad)'...
            ,'Stdev Phase Difference (rad)'...
            };
    ylims = {...
              [0,5]...
             ,[0,5]...
             ,[0,5]...
             ,[]...
             ,[]...
             ,[-2*pi,2*pi]...
             ,[-2*pi,2*pi]};
end
