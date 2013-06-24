function plot_param_omega2D(mdl,no,prange)
%function [omega,ph,prange]=plot_param_omega2D(mdl,no)
    %if nargin<4, gPath=''; end        
    if nargin==3
        pname=no;
        parval=mdl.params;
    elseif isempty(mdl.pset) 
        error('You have to run at least one parametrization')    
    elseif mdl.stype>=2
        error('Not implemented for two dimensional models')
    elseif nargin<2 || no==0
        pname=mdl.pset{end}{1};
        prange=mdl.pset{end}{2};
        parval=mdl.pset{end}{3};
        %pset=mdl.pset{end}{4};
    elseif no>0 && no<=length(mdl.pset)
        pname=mdl.pset{no}{1};
        prange=mdl.pset{no}{2};
        parval=mdl.pset{no}{3};
        %pset=mdl.pset{no}{4};
    else
        error('Invalid number of simulation!')
    end

    %Prepare model and ranges
    p0=mdl.params;
    mdl.load_param(parval);
    ph=-pi:pi/128:pi;
    phdot=zeros(length(prange),length(ph));
    
    %Fetch data
    for i=1:length(prange)
        mdl.subs_param(pname,prange(i));
        phdot(i,:)=-(mdl.eq([],ph,[],mdl.params{:}));
    end
    mdl.load_param(p0);
    %ranges={ph,prange,min(phdot):0.01:max(phdot)};
    %axislabels={'Phase',[pname, ' parameter'],'omega'};    
    %animate_surf(omega,ranges,axislabels);

        
    %Prepare figures and do plotting
    figtit=sprintf('Parametrization of variable %s: Theoretical \theta~\tetha` dependence', pname);
    figure('name',figtit);
    hold on;
    surf(ph,prange,phdot);
    colorbar;
    colormap(bluewhitered(256))
    shading interp
    %title(['\theta~\tetha` relationship for varying ',pname]);
    xlabel('\theta');
    ylabel([pname ' parameter']);
    zlabel('\theta`');
    xlim([-pi,pi]);
    ylim([min(prange),max(prange)]);
end
