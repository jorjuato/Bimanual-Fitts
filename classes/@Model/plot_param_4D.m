function plot_param_4D(mdl,vn,tailname,no)
    if nargin<4, no=0; end
    if nargin<3, tailname='_phhist'; end
    if nargin<2, vn='x'; end
    
    if isempty(mdl.ppset)
        error('You have to run a bivariate parametrization')     
    elseif nargin<2 || no==0
        pnames=mdl.ppset{end}{1};
        pranges=mdl.ppset{end}{2};
        %p0=mdl.pset{end}{3};
        pset=mdl.ppset{end}{4};
    elseif no>0 && no<=length(mdl.ppset)
        pnames=mdl.ppset{no}{1};
        pranges=mdl.ppset{no}{2};
        %p0=mdl.ppset{no}{3};
        pset=mdl.ppset{no}{4};
    else
        error('Invalid number of simulation!')
    end
    
    %Prepare model and ranges
    ph=linspace(-pi,pi,mdl.conf.bins);    
    omega=zeros(length(pranges{1}),length(ph),length(pranges{2}));
    v=[vn tailname];
    p0=mdl.params;
    
    %Fetch data
    for i=1:length(pranges{1})
        for j=1:length(pranges{2})
            mdl.load_ppset(pset{i,j});
            omega(i,:,j)=mdl.(v);
        end
    end
    mdl.load_param(p0);
    
    %Prepare figures and do plotting
    figtit=sprintf('Parametrization of variables %s and %s: Simulated Phase~%s', pnames{:},vn);
    figure('name',figtit);
    title(['Phase-',vn,' relationship for varying ',pnames{:}]);

    %animate_surf(omega,ranges,axislabels);
    anymate(@plot_surf,omega);
    
    function plot_surf(m)        
        surf(ph,pranges{1},m)
        colormap(bluewhitered(256))
        %shading interp        
        alpha(.51)        
        ylabel([pnames{1}, ' parameter']);
        xlabel('phase')
        zlabel(vn);
    end
    
end