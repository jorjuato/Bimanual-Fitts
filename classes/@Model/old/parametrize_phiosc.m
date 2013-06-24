function [phi_out,wrange] = parametrize_phiosc(wrange, initcond, alpha, tspan,intType)
    if nargin<1, wrange=2; end
    if nargin<2, initcond='none'; end
    if nargin<3, alpha=0; end
    if nargin<4, tspan=[0,4*pi]; end
    if nargin<5, intType='stochastic'; end
    if ischar(initcond)
        ics=1;
    else
        ics=length(initcond);
    end
    phi_out=cell(length(wrange),ics);
    
    for i=1:length(wrange)
        for j=1:ics
            %params={wrange(i),wrange(i)-wrange(i)/2,alpha};
            params={wrange(i),wrange(i),alpha};
            if strcmp(initcond,'none')
                phi0=[0,0];
            else
                phi0=[initcond(j),initcond(j)];
            end
            if strcmp(intType,'stochastic')
                [t,phi] = solve_phiosc_stoc(params,phi0,tspan);
            else
                [t,phi] = solve_phiosc_det(params,phi0,tspan);
            end
            phi_out{i,j}=[phi, t];
        end
    end
end

