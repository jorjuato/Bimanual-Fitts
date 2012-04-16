function [P,B,PC]=prob_nD(x,b,step,minValsToComputeCondProb)
%[P,B,PC]=prob_nD(x,b,step,minValsToComputeCondProb)
%
% Compute the probability of p[x(t)] and
% the conditional probability p[x(t+step)|x(t)] of a stochastic process.
%
% input:  - x contains M random sequences of length N (NxM array)
%         - bins or number of bins
%         - step (in samples; optional but required to compute cond. prob.)
%         - minValsToComputeCondProb (optional, default number of bins)
%
% output: - P probability density
%         - B bin centers
%         - PC conditional probability
%
% note: P & PC are initialized as arrays of NaN's!!
%
%                            (c) 10/2003 A. Daffertshofer
defnum=10;
if nargin<2 | isempty(b) 
   b={defnum};
end
if iscell(b)==0,
   bb=b;
   b=cell(size(bb,2),1)
   for k=1:size(bb,2), b{k}=bb(:,k); end
end
if length(b)==1, 
   b(1:size(x,2))=b; 
end
M=zeros(1,length(b));
for k=1:length(b)
   if length(b{k})==1
      b{k}=binset(min(x(:,k)),max(x(:,k)),b{k});
   end
   M(k)=length(b{k})-1;
end
N=max(M);
P=NaN*ones([M,1]);
if nargin>2 & nargout>2
   PC=ones([M,M])*NaN;
   if nargin < 4 | isempty(minValsToComputeCondProb)
      minValsToComputeCondProb=N;
   end
else
   PC=[];
end
%
indices=cell(N,size(x,2));
bb=b;
for n=1:size(x,2)
   bb{n}(end)=Inf;
   for k=1:M(n)
      indices{k,n}=find(x(:,n)>=bb{n}(k) & x(:,n)<bb{n}(k+1));
   end
end
forBegin=[];
forEnd=[];
iiStrg='intersect(';
PStrg='P(';
if nargin>2 & nargout>2
   PCStrg1='PC(';
   PCStrg2=[];
end
for n=1:size(x,2)
   forBegin=[forBegin 'for k' num2str(n) '=1:' num2str(M(n)) ','];
   if n==1, 
      iiStrg=['indices{k' num2str(n) ',' num2str(n) '}'];
   else 
      iiStrg=['intersect(' iiStrg ',indices{k' num2str(n) ',' num2str(n) '})'];
   end
   PStrg=[PStrg 'k' num2str(n)];
   if n==size(x,2), PStrg=[PStrg ')']; else PStrg=[PStrg ',']; end
   if nargin>2 & nargout>2
      PCStrg1=[PCStrg1 ':,'];
      PCStrg2=[PCStrg2 'k' num2str(n)];
      if n==size(x,2), PCStrg2=[PCStrg2 ')=prob_nD(x(ii,:),b);']; 
      else PCStrg2=[PCStrg2 ',']; end
   end
   forEnd=[forEnd 'end,'];
end
strg=[...
      forBegin, ...
      ['ii=' iiStrg ';ii=ii(:);'], ...
      [PStrg '=length(ii);']];
if nargin>2 & nargout>2
   strg=[strg ...
         'ii=ii+step;ii=ii(find(ii<=' num2str(size(x,1)) '));', ...
         'if length(ii)>' num2str(minValsToComputeCondProb) ',', ...
         [PCStrg1 PCStrg2], ...
         'end,']; 
end
strg=[strg forEnd];
eval(strg);
%
s=P;
for k=1:size(x,2)
   B{k}=(b{k}(2:end)+b{k}(1:end-1))/2;
   s=squeeze(trapz(B{k},s,1));
   if size(s,1)==1, s=s'; end
end
P=P/s;

function b=binset(xmin,xmax,N)
b=(xmin:(xmax-xmin)/N:xmax)';