function y = bootsma_sde(K,Q,N,dt,y0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x=bootsma_sde(K,Q,N,dt,x0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ..     2               3          .           .3
%  x = -w * x + alpha * x  - beta * x - gamma * x 
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
g       = K(3);
for k=1:N-1                              % and Euler-forward integration
    y(k+1,1) = y(k,1) + dt*(     y(k,2)                                            ) + langevinforce(k,1);
    y(k+1,2) = y(k,2) + dt*(-w * y(k,1) - a * y(k,1)^3 - b * y(k,2) - g * y(k,2)^3 ) + langevinforce(k,2);
end

function savegif()
Z = peaks;
surf(Z)
axis tight
set(gca,'nextplot','replacechildren','visible','off')
f = getframe;
[im,map] = rgb2ind(f.cdata,256,'nodither');
im(1,1,1,20) = 0;
for k = 1:20
  surf(cos(2*pi*k/20)*Z,Z)
  f = getframe;
  im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
end
imwrite(im,map,'DancingPeaks.gif','DelayTime',0,'LoopCount',inf) %g443800
