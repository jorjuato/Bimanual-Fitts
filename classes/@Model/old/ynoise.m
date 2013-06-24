function [ynoise] = ynoise(t, y, options)
%
% [ynoise] = ynoise(t, y, options, cfg)
%

ynoise = sqrt(options.Q).*randn(size(options.Q));


