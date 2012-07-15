function [Lf,Rf,Tr,Tl,phWin] = get_relative_freq_windowed2(tr,osc,overlap,do_plot,filename)
    if nargin<5, filename=''; end
    if nargin<4, do_plot=1; end
    if nargin<3, overlap=39/40; end
    if nargin<2, osc=40; end    
    plot_spectrogram=0;
    parallelize=1;
    
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
        plot_time_series(tr.ts,subplot(8,2,[1 2]));
        yl=ylabel('Time Series','rot',0,'FontWeight','bold');
        set(yl,'Position',get(yl,'Position') - [3 0 0]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot spectrograms
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        subplot(8,2,[3,5])
        surf(Tl,F,10*log10(abs(LP)),'edgecolor','none');
        axis tight;
        view(0,90);
        yl=ylabel('Spectrograms','rot',0,'FontWeight','bold');
        set(yl,'Position',get(yl,'Position') - [3 0 0]);
        subplot(8,2,[4,6])
        surf(Tr,F,10*log10(abs(RP)),'edgecolor','none');
        axis tight;
        view(0,90);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot "instantaneous" frequencies and rho
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        subplot(8,2,[7,8]);
        hold on
        plot(Lf,'r'); 
        plot(Rf,'b'); 
        if tr.ts.info.LID > tr.ts.info.RID
            plot(Rf./Lf,'g'); 
        else
            plot(Lf./Rf,'g'); 
        end
        hold off;
        yl=ylabel('Freqs/rho','rot',0,'FontWeight','bold');
        set(yl,'Position',get(yl,'Position') - [3 0 0]);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot "all-trial" frequency corrected phase difference
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        subplot(8,2,[9,10]);        
        plot(tr.ls.phDiff);
        yl=ylabel('Phi','rot',0,'FontWeight','bold');
        set(yl,'Position',get(yl,'Position') - [3 0 0]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot "instantaneous" frequency corrected phase difference
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        subplot(8,2,[11,12]);
        phWin=Lph.*Rf-Rph.*Lf;
        plot(phWin);
        yl=ylabel('Phi corrected','rot',0,'FontWeight','bold');
        set(yl,'Position',get(yl,'Position') - [3 0 0]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Plot histograms of phi
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        subplot(8,2,[13,15]);
        hist(mod(2*pi,tr.ls.phDiff),25);
        xl=xlabel('Hist Phi','rot',0,'FontWeight','bold');
        %set(yl,'Position',get(xl,'Position') - [3 0 0]);
        subplot(8,2,[14,16]);
        hist(mod(2*pi,phWin),25);
        xl=xlabel('Hist Phi correct','rot',0,'FontWeight','bold');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Save to disk if filename provided
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ~isempty(filename)
            %saveas(gcf,filename,'png');
            hgsave(gcf,filename);
        end
    end
    
end

    
    %Select window size equal for both time series
%     if tr.ts.info.LID < tr.ts.info.RID
%         windowsize=round(len/(length(tr.ts.Rpeaks)/osc_slices));
%     else
%         windowsize=round(len/(length(tr.ts.Lpeaks)/osc_slices));
%     end


%        phWin=[];
%         for i=1:length(T)-1
%             idx=round(T(i)*1000) : round(T(i+1)*1000);
%             phWin=[phWin;Lph(idx)*Rf(i)-Rph(idx)*Lf(i)];
%         end
        
        %phWin=filterdata(phWin,tr.conf.cutoff);