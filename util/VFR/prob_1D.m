function [P,B,PC]=prob_1D(x,b,step,minValsToComputeCondProb);
%[P,B,PC]=prob_1D(x,b,step,minValsToComputeCondProb)
%
% Compute the probability of p[x(t)] and
% the conditional probability p[x(t+step)|x(t)] of a stochastic process.
%
% input:  - x contains 1 random sequence(s) of length N (Nx1 array)
%         - bins or number of bins (as cell array)
%         - step (in samples; optional but required to compute cond. prob.)
%         - minValsToComputeCondProb (optional, default max no. bins)
%
% output: - P probability density
%         - B bin centers
%         - PC conditional probability
%
% note: P & PC are initialized as arrays of NaN's!!
%
%                            (c) A. Daffertshofer 02/04
%
% created by makefunction_prob [25-Mar-2004 16:05:26]

% CREATE BINS IF NOT PROVIDED AS INPUT
defnum=10;
if nargin<2 | isempty(b), b={defnum}; end
if iscell(b)==0,    % CREATE CELL of BINS if NOT ALREADY CELL
   bb=b;
   b=cell(size(bb,2),1);
   for k=1:size(bb,2), b{k}=bb(:,k); end
end
if length(b{1})==1, b{1}=binset(min(x(:,k)),max(x(:,k)),b{1}); end

% INITIALIZE P & PC 
M=length(b{1})-1;
P=NaN*ones([M,1]);
if nargin>2 & nargout>2
   PC=ones([M,M])*NaN;%zeros([M,M]);%
   if nargin < 4 | isempty(minValsToComputeCondProb)
      minValsToComputeCondProb=M;
   end
else
   PC=[];
end

bb=b;
indices=cell(M,1);
bb{1}(end)=Inf;
for k=1:M
   indices{k,1}=find(x>=bb{1}(k) & x<bb{1}(k+1));
end
if nargin>2 & nargout>2
   for k=1:M
      ii=indices{k,1};
      ii=ii(:);
      P(k)=length(ii);
      ii=ii+step;
      ii=ii(find(ii<=size(x,1)));
      if length(ii)>minValsToComputeCondProb
         PC(:,k)=prob_1D(x(ii,:),b);
      end
   end
else
   for k=1:M
      ii=indices{k,1};
      ii=ii(:);
      P(k)=length(ii);
   end
end
B{1}=(b{1}(2:end)+b{1}(1:end-1))/2;
P=P/trapz(B{1},P,1);
pack;

function b=binset(xmin,xmax,N)
b=(xmin:(xmax-xmin)/N:xmax)';