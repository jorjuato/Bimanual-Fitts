function plot_param_omega3D(mdl,no,prange)
%function [omega,ph,prange]=plot_param_omega2D(mdl,no)
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
    omega=zeros(length(prange),length(ph));
    
    %Fetch data
    for i=1:length(prange)
        mdl.subs_param(pname,prange(i));
        omega(i,:)=abs(mdl.eq([],ph,[],mdl.params{:}));
    end
    mdl.load_param(p0);
    pranges={ph,prange,min(omega):0.01:max(omega)};
    %axislabels={'Phase',[pname, ' parameter'],'omega'};    
    %animate_surf(omega,ranges,axislabels);
    anymate(@plot_surf,omega);
    
    function plot_surf(m)
        surf(ph,pranges{1},m);
        colormap(bluewhitered(256));
        xlabel('phase');
        ylabel([pname, ' parameter']);
        zlabel('omega');    
    end    
end
        
    %Prepare figures and do plotting
%     figtit=sprintf('Parametrization of variable %s: Theoretical Phase~Omega functional dependence', pname);
%     figure('name',figtit);
%     hold on;
%     surf(ph,prange,omega);
%     title(['Phase-Omega relationship for varying ',pname]);
%     xlabel('Phase');
%     ylabel([pname ' parameter']);
%     zlabel('omega');
%end
