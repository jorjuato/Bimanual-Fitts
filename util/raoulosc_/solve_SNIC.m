function [t,phi] = solve_CircleSNIC(tspan,phi0,w,cI)

% solver for SNLC

options.Q = 0.01;            % noise strength with same dimension as variable
options.NoiseFn = 'ynoise';  % Noise function

% call solver
bparam = [20,3];
% cI = 0;

[t,phi] = ode15sn('CircleSNIC',tspan,phi0,options,w,cI);

if nargout==0
    plot(t,mod(phi,2*pi)),
end