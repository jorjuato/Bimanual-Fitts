function [t,phi] = solve_phiosc(params,y0,tspan,mode)
    if nargin<4, mode='det'; end
    if strcmp(mode,'det')
        [t,phi] = solve_phiosc_det(params,y0,tspan);
    else
        [t,phi] = solve_phiosc_stoc(params,y0,tspan);
    end
end