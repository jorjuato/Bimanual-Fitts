function [finalH,Rsquared,bins,Fs,coeffs] = dfaN(timeSeries, binValue, binLimit, degree)

% dfaN performs detrended fluctuation analysis with nth degree detrending
%
% function [finalH,Rsquared,bins,Fs,coeffs] = dfaN(timeSeries, binValue, binLimit, degree)
%
% Input -  timeSeries: one dimensional time series in a column vector
%   binValue: size of bin iterations, default to 1
%   binLimit: maximum bin width to use
%     degree: degree of polynomial to fit in each bin
% Output - finalH: hurst exponent
%        Rsquared: r^2 value for line fitting
%            bins: vector of bin sizes
%              Fs: vector of F values calculated for each bin
%
% http://reylab.bidmc.harvard.edu/tutorial/DFA/node5.html
% http://www.physionet.org/physiotools/dfa/
%
% to do:
%  make integration optional
%  check for superposition principle (return seperate curves)
%  bin shifting (all possible bins)


% Default to DFA-1
if nargin == 3
	degree = 1;
end;

% integrate time series
integratedSeries = cumsum(timeSeries - mean(timeSeries));


% make sure binValue is positive
if (binValue < 1)
	binValue = 1;
end

% make sure binLimit is smaller than the length of the time series
if (binLimit > length(timeSeries))
	binLimit = length(timeSeries);
elseif (binLimit < 1)
	binLimit = ceil(length(timeSeries)/4);
end

minIncrement = 4;
maxIncrement = floor(binLimit/binValue);
bins = zeros(maxIncrement - minIncrement + 1, 1);
Fs = zeros(maxIncrement - minIncrement + 1, 1);

tsLen = length(timeSeries);

binInd = 0;
for currentIncrement = minIncrement:maxIncrement
	binInd = binInd + 1;

	binSize = currentIncrement * binValue;
	bins(binInd) = binSize;

	incrementBins = floor(tsLen / binSize);

	currentSeries = zeros(binSize, incrementBins);

	% Create bins of the appropriate size
	for currentBin = 1:incrementBins
		currentSeries(:,currentBin) = integratedSeries( (currentBin-1) * binSize + 1 : currentBin * binSize );
	end;

	% Remove a polynomial trend of the given degree
	detrendedSeries = detrend(currentSeries, degree);

	% Calculate fluctuations in each bin
	currentFluctuations = sum(detrendedSeries .^ 2);

	incrementFluctuations = sum(currentFluctuations);

	% total deviation per sample
	Fs(binInd) = sqrt(incrementFluctuations / tsLen);
end

lbins = log10(bins);
lFs = log10(Fs);

% calculate H and R^2
coeffs = polyfit(lbins, lFs, 1);
finalH = coeffs(1);

R = corrcoef(lbins, lFs);

% Octave's corrcoef only returns one value
if size(R,2) > 1
	Rsquared = R(1,2)^2;
else
	Rsquared = R^2;
end;


end

