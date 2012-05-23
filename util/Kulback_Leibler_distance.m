function [MI,H]=Kulback_Leibler_distance(x,N)

% compute Kulback-Leibler distance between probability distribution of signal x 
%   and uniform distribution
%
% input:    x  = signal
%           N  = number of bins for prob. distribution
% output:   MI = modulation index
%           H  = prob distribution
%
% try:  x = rand(10^5,1) for uniform distribution
%       x = randn(10^5,1) for gaussian distribution
% (see Tort et al., 2010, J Neurophysiol 104)


x=x(:)'; 

% compute istogram
[H,B]=hist(x,N);
H=H/sum(H);

% create uniform distribution
U=ones(1,N);
U=U/sum(U);
d=zeros(length(H),1);
for n=1:length(H)
    d(n)=H(n)*log(H(n)/U(n));
end
Dkl=nansum(d);
MI=Dkl/log(length(H));

if nargout==0
    bar(B,H),axis tight
    set(gca,'ylim',[0 1.1*max(H)])
    title([sprintf('MI = %.3g',MI)])
end