function y = fittsinf_sde(T,dt,y0,Q, doPlotting)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x=fittsinf_sde(T,dt,y0,Q);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ..     2               3          .           .3
%  x = -w * x + alpha * x  - beta * x - gamma * x 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the time series of informationly dumped Duffing + Rayleigh oscillator
% input:  - T  trial length in seconds
%         - dt time step in seconds
%         - y0 initial conditions
%         - Q amount of noise
% output: - y time series of x and dx/dt
% Sample usage
% y = fittsinf_sde(10000, 0.01,[0,1,5],0.01, false);
% comet3(y(1:50:end,1),y(1:50:end,2),y(1:50:end,3));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Experimental parameter values that fit oscillator
omega = [192.875 98.669 66.779 53.666 33.818];
alpha = [0.823 -25.687 -37.406 -43.239 -30.379];
beta = [-0.803 -0.735 -0.931 -3.443  -3.596];
gamma = [0.006 0.012 0.027 0.164 0.313];

%Environmental information:  Index Difficulty
ID      = [3 4 5 6 7];
IDmean  = mean(ID);
IDrange = 1;
IDfreq  = 1/100.0*2*pi;

% Compute regresion of parameters with respect ID
IDr = [ID' ones(length(ID),1)];
r_omega = regress(omega', IDr);
r_alpha = regress(alpha', IDr);
r_beta  = regress(beta' , IDr);
r_gamma = regress(gamma', IDr);

steps=T/dt;
randn(fix(mod(now,1000000)),1);              % 'randomize' random generator
langevinforce=sqrt(2*Q*dt)*randn(steps,2);   % define the Langevin force, rescaled with sqrt(dt)                                         
y=zeros(steps,4); y(1,:)=(y0(:))';           % initialize the output array

for k=1:steps-1                              % and Euler-forward integration
    ID = y(k,4);
    w = r_omega(2)+ID*r_omega(1);
    a = r_alpha(2)+ID*r_alpha(1);
    b = r_beta(2)+ID*r_beta(1);
    g = r_gamma(2)+ID*r_gamma(1);
    y(k+1,1) = y(k,1) + dt*(     y(k,2)                                            ) + langevinforce(k,1);
    y(k+1,2) = y(k,2) + dt*(-w * y(k,1) - a * y(k,1)^3 - b * y(k,2) - g * y(k,2)^3 ) + langevinforce(k,2);
    y(k+1,3) = (y(k+1,2) - y(k,2)) / dt; %Compute acceleration for hook's plot
    y(k+1,4) = IDrange*sin(IDfreq*k*dt) + IDmean;
end
if doPlotting == true
    frames = 100; slice = uint8(length(y(:,1))/frames);
    plot3(y(1:slice,1),y(1:slice,2),y(1:slice,4));
%     axis tight
%     %set(gca,'nextplot','replacechildren','visible','off')
%     set(gca,'nextplot','replacechildren')
%     f = getframe;
%     [im,map] = rgb2ind(f.cdata,256,'nodither');
%     im(1,1,1,frames) = 0;
%     for k = 1:frames-1  
%       low = k*slice; 
%       up =low + slice;
%       plot3(y(low:up,1),y(low:up,2),y(low:up,4))
%       f = getframe;
%       size(im)
%       im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
%     end
%     imwrite(im,map,'trajectory.gif','DelayTime',0,'LoopCount',inf) %g443800
    gifname = 'test.gif'; I = getframe(gcf);
    I = frame2im(I);
    [X, map] = rgb2ind(I, 128);
    imwrite(X, map, gifname, 'GIF', 'WriteMode', 'overwrite', 'DelayTime', 0, 'LoopCount', Inf);
    for k = 1:frames-1  
        low = k*slice; 
        up =low + slice;
        plot3(y(low:up,1),y(low:up,2),y(low:up,4))
        I = getframe(gcf);
        I = frame2im(I);
        [X, map] = rgb2ind(I, 128);
        imwrite(X, map, gifname, 'GIF', 'WriteMode', 'append', 'DelayTime', 0);
    end
end
