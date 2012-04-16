function x=lorenz_sde(K,Q,N,dt,x0)
%x=lorenz_sde(K,Q,N,dt,x0);
% compute the time series of an Lorenz system
% input:  - K  drift coefficient
%         - Q  fluctuation strength
%         - N  number of samples
%         - dt time step
%         - x0 initial condition
randn(fix(mod(now,1000000)),1);          % 'randomize' random generator
langevinforce=sqrt(2*Q*dt)*randn(N,3);   % define the Langevin force 
%                                        % (rescaled with sqrt(dt)
x=zeros(N,3); x(1,:)=(x0(:))';           % initialize the output array
k1=K(1)*dt;
k3=(1-K(3)*dt);
for k=2:N                                % and Euler-forward integration
   x(k,1)=x(k-1,1)+k1*(x(k-1,2)-x(k-1,1))+langevinforce(k,1);
   x(k,2)=x(k-1,2)+((K(2)-x(k-1,3))*x(k-1,1)-x(k-1,2))*dt+langevinforce(k,2);
   x(k,3)=x(k-1,3)*k3+x(k-1,1)*x(k-1,2)*dt+langevinforce(k,3);
end

