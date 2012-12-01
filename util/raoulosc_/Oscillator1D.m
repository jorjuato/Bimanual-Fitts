function ydot = Oscillator1D(t,y,options,param,bparam,cI)

%   
%   ydot(1) = w-a*cos(y)

w = param(1);
a = param(2);

I = cI*PulseTrainDiscrete(t,bparam(1),bparam(2));

ydot = w - a*cos(y(1)) - I;
