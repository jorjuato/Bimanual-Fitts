function [t,phi] = solve_phiosc_stoc(params,y0,tspan)
    options = odeset('MaxStep',.01); % maximal time integration step
    options.Q = 0.05;                % noise strength with same dimension as variable
    options.NoiseFn = 'ynoise';      % Noise function
    myinline = inline(['[ omega1 + sin(2*y(1)) + alpha*sin(y(1)-y(2)) ;' ...
                       '  omega2 + sin(2*y(2)) + alpha*sin(y(2)-y(1)) ]'],...
                         't','y','kk','omega1','omega2','alpha');
    [t,phi] = ode15sn(myinline,tspan,y0,options,params{:});
end