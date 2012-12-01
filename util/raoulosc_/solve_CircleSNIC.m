function [t,phi,I] = solve_CircleSNIC(tspan,phi0,w,cI,bparam)

% solver for SNLC

options.Q = 0.0000000001;            % noise strength
options.NoiseFn = 'ynoise';  % Noise function

% call solver

% [t,phi] = ode15sn('CircleSNIC',tspan,phi0,options,w,bparam,cI);
[t,phi] = ode15sn('FixedPoint',tspan,phi0,options,w,bparam,cI);

I=PulseTrainDiscrete(t,bparam(1),bparam(2));

if nargout==0
    tt=t/12.5; 
    plot(tt,phi),hold on
    %plot(tt,mod(phi,2*pi)),hold on
    if cI~=0
        plot(tt,I-1.1,'k');
    end,hold off
end