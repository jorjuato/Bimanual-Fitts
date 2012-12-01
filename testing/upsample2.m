function [y] = upsample2(x,NN)

% routine for resampling the data
%   input   --> NN = required new length

N  = length(x);
t  = (0:N-1);       %   time vector of original time series
dt = N/NN;
ti = (0:dt:N-dt);   %   new time vector of required length

y  = interp1(t,x,ti,'cubic')';

if nargout==0
    plot(x),hold on,plot(y,'r'),hold off,legend('old','new')
%     subplot(2,1,1);plot(x); set(gca,'xlim',[0 length(x)]);
%     subplot(2,1,2);plot(y); set(gca,'xlim',[0 length(y)]);
end
    