function y = hkb_sde(K,Q,N,dt,p,y0)
%x=hkb_sde(K,Q,N,dt,x0);
% compute the time series of an Lorenz system
% input:  - K  drift coefficient--not used now, using parameters...
%         - Q  fluctuation strength
%         - N  number of samples
%         - dt time step
%         - p  parameter values
%         - y0 initial condition
randn(fix(mod(now,1000000)),1);          % 'randomize' random generator
langevinforce=sqrt(2*Q*dt)*randn(N,4);   % define the Langevin force (rescaled with sqrt(dt)
y=zeros(N,4); y(1,:)=(y0(:))';           % initialize the output array
a       = p(1);                          % initialize model parameters
e       = p(2);
r0      = p(3);
w0      = p(4);
alpha   = p(5);
beta    = p(6);
orb     = w0^2*r0^2;
for k=1:N-1                                % and Euler-forward integration
    I12= (y(k,2) - y(k,4)) * ( alpha + beta * (y(k,1) - y(k,3))^2);
    I21= (y(k,4) - y(k,2)) * ( alpha + beta * (y(k,3) - y(k,1))^2);
    y(k+1,1) = y(k,1) + dt*(  y(k,2))                                           + langevinforce(k,1);
    y(k+1,2) = y(k,2) + dt*(- y(k,1)*a - e * (y(k,2)^2 - orb) * y(k,2) + I12)   + langevinforce(k,2);
    y(k+1,3) = y(k,3) + dt*(  y(k,4))                                           + langevinforce(k,3);
    y(k+1,4) = y(k,4) + dt*(- y(k,3)*a - e * (y(k,4)^2 - orb) * y(k,4) + I21)   + langevinforce(k,4);
end


