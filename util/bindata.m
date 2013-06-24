function [mu, bins] = bindata(x, y, numbins)
%function [mu, bins] = bindata(x, y, numbins);
% bins the data y according to x and returns the bins and the average
% value of y for that bin


bins = linspace(min(x), max(x), numbins);
[n,bin] = histc(x, bins);
mu = NaN*zeros(size(bins));
for k = [1:numbins],
  ind = find(bin==k);
  if (~isempty(ind))
    mu(k) = mean(y(ind));
  end
end