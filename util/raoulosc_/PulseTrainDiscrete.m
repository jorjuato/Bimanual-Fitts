function I = PulseTrainDiscrete(t,T,w)

% 	PULSETRAIN is a block function, i.e. it is one if T-w < t < T, 
%   else zero
%	block(t,T,w)
%	t = time (argument), T denotes the period (beginning) and w the width 
%   of a block

I = 0.5*(sign(mod(t,T)-(T-w))-sign(mod(t,T)-T));	% sets the block to zero 
                                                    % for a<x<a+b, else to 1
% ii    = find(I~=0);
% I(ii) = 1;

% I = 0.5*(sign(mod(t,T)-(T-w))-sign(mod(t,T)-T));	% sets the block to zero 
%                                         % for a<x<a+b, else to 1
% ii    = find(I~=0);
% I(ii) = 1;
