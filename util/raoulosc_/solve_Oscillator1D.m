function [t,y] = solve_Oscillator1D(tspan,y0,param,cI)

% solver for Excitator


options = odeset('MaxStep',.01);    % maximal time integration step
options.Q = [.1];              % noise strength with same dimension as variable
options.NoiseFn = 'ynoise';        % Noise function

ts = 12.5;
bparam = [2*ts,.03*ts];                  % parameters for block function [10,0.3];
%cI = -3.0;                         % block constant (-3.5 works well)

% call solver

[t,y] = ode15sn('Oscillator1D',tspan,y0,options,param,bparam,cI);

   
if nargout == 0
    clf
    plot(t,y)
end