function plot_param_omega4D(mdl,pnames,pranges)
    %Prepare model and ranges
    p0=mdl.params;
    ph=-pi:pi/128:pi;
    omega=zeros(length(pranges{1}),length(ph),length(pranges{2}));
    
    %Fetch data
    for i=1:length(pranges{1})
        for j=1:length(pranges{2})
            mdl.subs_param(pnames{1},pranges{1}(i));
            mdl.subs_param(pnames{2},pranges{2}(j));
            omega(i,:,j)=-mdl.eq([],ph,[],mdl.params{:});
        end
    end
    mdl.load_param(p0);
    
    %Prepare figures and do plotting
    figtit=sprintf('Parametrization of variables %s and %s: Theoretical Phase~Omega functional dependence', pnames{:});
    figure('name',figtit);
    title(['Phase-Omega relationship for varying ',pnames{:}]);
    anymate(@plot_surf,omega);
    
    function plot_surf(m)
        surf(ph,pranges{1},m);
        colormap(bluewhitered(256));
        ylabel([pnames{1}, ' parameter']);
        xlabel('phase');
        zlabel('omega');
        %colormap(get_cm())        
        %colormap(flipud(lbmap(256,'BrownBlue')))                
        %shading interp
        %caxis([-max(omega(:)) max(omega(:))])
        %caxis([-1 1])
        %colorbar
        %alpha(.51)        
    end
    
end

function cm = get_cm()
    r = [1 0 0];       %# start
    w = [.9 .9 .9];    %# middle
    b = [0 0 1];       %# end

    %# colormap of size 64-by-3, ranging from red -> white -> blue
    c1 = zeros(32,3); c2 = zeros(32,3);
    for i=1:3
        c1(:,i) = linspace(r(i), w(i), 32);
        c2(:,i) = linspace(w(i), b(i), 32);
    end
    cm = [c1(1:end-1,:);c2];
end