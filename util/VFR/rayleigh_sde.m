function y = rayleigh_sde(K,Q,N,dt,y0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x=rayleigh_sde(K,Q,N,dt,x0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ..     2             .2       . 
%  x = -w * x + alpha( x - 1) * x 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the time series of an Lorenz system
% input:  - K  drift coefficient
%         - Q  fluctuation strength
%         - N  number of samples
%         - dt time step
%         - y0 initial condition
% output: - y time series of x and dx/dt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
randn(fix(mod(now,1000000)),1);          % 'randomize' random generator
langevinforce=sqrt(2*Q*dt)*randn(N,2);   % define the Langevin force, rescaled with sqrt(dt)                                         
y=zeros(N,2); y(1,:)=(y0(:))';           % initialize the output array
a       = K(1);                          % initialize model parameters
w       = K(2);
for k=1:N-1                              % and Euler-forward integration
    y(k+1,1) = y(k,1) + dt*(     y(k,2)                              )   + langevinforce(k,1);
    y(k+1,2) = y(k,2) + dt*(-w * y(k,1) + a * (y(k,2)^2 - 1) * y(k,2))   + langevinforce(k,2);
end