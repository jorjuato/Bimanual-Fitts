function [t,phi] = solve_ModelSystem(tspan,phi0,a,b,c,e,cI)

% solver for SNLC

options.Q = 0.01;            % noise strength with same dimension as variable
options.NoiseFn = 'ynoise';  % Noise function

% call solver
bparam = [20,3];
% cI = 0;

[t,phi] = ode15sn('ModelSystem',tspan,phi0,options,bparam,a,b,c,e,cI);

if nargout==0
    plot(t,mod(phi,2*pi)),
end