function x=pitchfork_sde(K,Q,N,dt,x0)
%x=pitchfork_sde(K,Q,N,dt,x0);
% compute the time series of an Ornstein-Uhlenbeck process
% input:  - K  drift coefficient
%         - Q  fluctuation strength
%         - N  number of samples
%         - dt time step
%         - x0 initial condition
randn(fix(mod(now,1000000)),1);          % 'randomize' random generator
langevinforce=sqrt(2*Q*dt)*randn(N,1);   % define the Langevin force 
%                                        % (rescaled with sqrt(dt)
x=zeros(N,1); x(1)=x0;                   % initialize the output array
for k=2:N                                % and Euler-forward integration
   x(k)=(1+K*dt)*x(k-1)-x(k-1)^3*dt+langevinforce(k);
end

