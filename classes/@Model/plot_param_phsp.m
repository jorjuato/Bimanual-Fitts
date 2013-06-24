function plot_param_phsp(mdl,no)    
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

    figtit=sprintf('Parametrization of variable %s: Phase Space', pname);
    figure('name',figtit);
    if mdl.stype<2
        hold on
    else
        ax1=subplot(1,2,1); hold on;
        ax2=subplot(1,2,2); hold on;
    end    
    legnames=cell(length(pset),1);
    for i=1:length(pset)
        d=pset{i};
        if mdl.stype<2
            scatter(d.ph,abs(d.phdot),'.');
        else
            scatter(ax1,d.ph(:,1),abs(d.phdot(:,1)),'.');
            scatter(ax2,d.ph(:,2),abs(d.phdot(:,2)),'.');
        end
        legnames{i}=sprintf('%s=%1.3f',pname,prange(i));
    end

    legend(legnames);
    hline(0,'k-')
end