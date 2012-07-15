function [Lf,Rf,Tr,Tl,phWin] = get_relative_freq_windowed(tr,osc,overlap,do_plot,filename)
    if nargin<5, filename=''; end
    if nargin<4, do_plot=1; end
    if nargin<3, overlap=99/100; end
    if nargin<2, osc=20; end    
    plot_spectrogram=1;
    parallelize=1;
    
    if ~isa(tr,'Trial')
        error('tr input argument has to be a Trial instance')
    end
    
    %Local instances of time series, to avoid processing overhead
    Lx=tr.ts.Lxnorm;
    Rx=tr.ts.Rxnorm;    
    Lph=tr.ts.Lph;
    Rph=tr.ts.Rph;
    len=length(Lx);
    Lwin=round(len/(length(tr.ts.Lpeaks)/osc));
    Rwin=round(len/(length(tr.ts.Rpeaks)/osc));

    %Get spectrograms for both timeseries
    if parallelize==1
        if matlabpool('size') == 0
            matlabpool(2)
        end
        r={};
        parfor i=1:2
            if i==1
                [~,~,Tl,LP] = get_spectrogram(Lx,Lwin,overlap);
                r{i}={Tl,LP};
            else
                [~,F,Tr,RP] = get_spectrogram(Rx,Rwin,overlap);
                r{i}={F,Tr,RP};
            end
        end
        [Tl,LP]=r{1}{:};
        [F,Tr,RP]=r{2}{:};
        if plot_spectrogram
            figure;
            subplot(1,2,1)
            surf(Tl,F,10*log10(abs(LP)),'edgecolor','none');
            axis tight;
            view(0,90);
            subplot(1,2,2)
            surf(Tr,F,10*log10(abs(RP)),'edgecolor','none');            
            axis tight;
            view(0,90);
        end
    else
        [~,~,Tl,LP] = get_spectrogram(Lx,Lwin,overlap,plot_spectrogram);
        [~,F,Tr,RP] = get_spectrogram(Rx,Rwin,overlap,plot_spectrogram);
    end

    %Get maximum freq for each timestep and interpolate to smooth gaps
    [~,Lmi]=max(LP,[],1);
    [~,Rmi]=max(RP,[],1);
    %Lf=F(Lmi);
    %Rf=F(Rmi);
    Lf=interp1(round(Tl*1000),F(Lmi),1:len)';
    Rf=interp1(round(Tr*1000),F(Rmi),1:len)';
    
    if do_plot==1
        figure(); 
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot temporal series
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot_time_series(tr.ts,subplot(4,1,1));
        yl=ylabel('Time Series','rot',0,'FontWeight','bold');
        set(yl,'Position',get(yl,'Position') - [3 0 0]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot "instantaneous" frequencies and rho
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        subplot(4,1,2);
        hold on
        plot(Lf,'r'); 
        plot(Rf,'b'); 
        if tr.ts.info.LID > tr.ts.info.RID
            plot(Rf./Lf,'g'); 
        else
            plot(Lf./Rf,'g'); 
        end
        yl=ylabel('Freqs/rho','rot',0,'FontWeight','bold');
        set(yl,'Position',get(yl,'Position') - [3 0 0]);
        hold off;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot "all-trial" frequency corrected phase difference
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        subplot(4,1,3);        
        plot(tr.ls.phDiff);
        yl=ylabel('Phi','rot',0,'FontWeight','bold');
        set(yl,'Position',get(yl,'Position') - [3 0 0]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot "instantaneous" frequency corrected phase difference
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        subplot(4,1,4);
        phWin=Lph.*Rf-Rph.*Lf;
        plot(phWin);
        yl=ylabel('Phi corrected','rot',0,'FontWeight','bold');
        set(yl,'Position',get(yl,'Position') - [3 0 0]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Save to disk if filename provided
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ~isempty(filename)
            %saveas(gcf,filename,'png');
            hgsave(gcf,filename);
        end
    end
    
end