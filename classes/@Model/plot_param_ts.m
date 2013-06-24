function plot_param_ts(mdl,no)    
    if isempty(mdl.pset)
        error('You have to run at least one parametrization')    
    elseif nargin<2 || no==0
        pname=mdl.pset{end}{1};
        prange=mdl.pset{end}{2};
        %p0=mdl.pset{end}{3};
        pset=mdl.pset{end}{4};
    elseif no>0 && no<=length(mdl.pset)
        pname=mdl.pset{no}{1};
        prange=mdl.pset{no}{2};
        %p0=mdl.pset{no}{3};
        pset=mdl.pset{no}{4};
    else
        error('Invalid number of simulation!')
    end

    figtit=sprintf('Parametrization of variable %s: Time Series', pname);
    figure('name',figtit);
    legnames=cell(length(pset),1);
    if mdl.stype<2
        ax1=subplot(3,1,1); xlim([0,4*pi]);hline(0,'k-');hold on
        ax2=subplot(3,1,2); xlim([0,4*pi]);hline(0,'k-');hold on
        ax3=subplot(3,1,3); xlim([0,4*pi]);hline(0,'k-');hold on
        for i=1:length(pset)
            d=pset{i};
            scatter(ax1,d.t,d.phcos,'.');
            scatter(ax2,d.t,d.phcosdot,'.');
            scatter(ax3,d.t,abs(d.phdot),'.');
            legnames{i}=sprintf('%s=%1.3f',pname,prange(i));
        end        
    else
        ax1a=subplot(2,3,1); xlim([0,4*pi]);hline(0,'k-');hold on
        ax2a=subplot(2,3,2); xlim([0,4*pi]);hline(0,'k-');hold on
        ax3a=subplot(2,3,3); xlim([0,4*pi]);hline(0,'k-');hold on
        ax1b=subplot(2,3,4); xlim([0,4*pi]);hline(0,'k-');hold on
        ax2b=subplot(2,3,5); xlim([0,4*pi]);hline(0,'k-');hold on
        ax3b=subplot(2,3,6); xlim([0,4*pi]);hline(0,'k-');hold on 
        for i=1:length(pset)
            d=pset{i};
            scatter(ax1a,d.t,d.phcos(:,1),'.');
            scatter(ax2a,d.t,d.phcosdot(:,1),'.');
            scatter(ax3a,d.t,abs(d.phdot(:,1)),'.');
            scatter(ax1b,d.t,d.phcos(:,2),'.');
            scatter(ax2b,d.t,d.phcosdot(:,2),'.');
            scatter(ax3b,d.t,d.abs(phdot(:,2)),'.');
            legnames{i}=sprintf('%s=%1.3f',pname,prange(i));
        end     
    end
    legend(legnames);
end