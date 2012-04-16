function [P,B,PC]=prob_3D(x,b,step,minValsToComputeCondProb);
%[P,B,PC]=prob_3D(x,b,step,minValsToComputeCondProb)
%
% Compute the probability of p[x(t)] and
% the conditional probability p[x(t+step)|x(t)] of a stochastic process.
%
% input:  - x contains 3 random sequence(s) of length N (Nx3 array)
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
defnum=10;
if nargin<2 | isempty(b), b={defnum}; end
if iscell(b)==0,
   bb=b;
   b=cell(size(bb,2),1);
   for k=1:size(bb,2), b{k}=bb(:,k); end
end
if length(b)==1, b(1:3)=b; end
M=zeros(1,3);
for k=1:3
   if length(b{k})==1, b{k}=binset(min(x(:,k)),max(x(:,k)),b{k}); end
   M(k)=length(b{k})-1;
end

P=NaN*ones([M,1]);
if nargin>2 & nargout>2
   PC=ones([M,M])*NaN;
   if nargin < 4 | isempty(minValsToComputeCondProb)
      minValsToComputeCondProb=max(M);
   end
else
   PC=[];
end
bb=b;
indices=cell(max(M),3);
for n=1:3
   bb{n}(end)=Inf;
   for k=1:M(n)
      indices{k,n}=find(x(:,n)>=bb{n}(k) & x(:,n)<bb{n}(k+1));
   end
end
if nargin>2 & nargout>2
   for k1=1:M(1)
      for k2=1:M(2)
         for k3=1:M(3)
            ii=intersect(intersect(indices{k1,1},indices{k2,2}),indices{k3,3});
            ii=ii(:);
            P(k1,k2,k3)=length(ii);
            ii=ii+step;
            ii=ii(find(ii<=size(x,1)));
            if length(ii)>minValsToComputeCondProb
               PC(:,:,:,k1,k2,k3)=prob_3D(x(ii,:),b);
            end
         end
      end
   end
else
   for k1=1:M(1)
      for k2=1:M(2)
         for k3=1:M(3)
            ii=intersect(intersect(indices{k1,1},indices{k2,2}),indices{k3,3});
            ii=ii(:);
            P(k1,k2,k3)=length(ii);
         end
      end
   end
end
s=P;
for k=1:3
   B{k}=(b{k}(2:end)+b{k}(1:end-1))/2;
   s=squeeze(trapz(B{k},s,1));
   if size(s,1)==1, s=s'; end
end
P=P/s;
pack;

function b=binset(xmin,xmax,N)
b=(xmin:(xmax-xmin)/N:xmax)';