function outmat=holm2(varargin)
%Holm-Sidak procedure for multiple Student's t tests.
%This file is applicable for equal or unequal sample sizes
%
% Syntax: 	HOLM(X,CTRL,ALPHA,TAIL)
%      
%     Inputs:
%           X: data matrix (Size of matrix must be n-by-2; data=column 1, sample=column 2). 
%           CTRL: The first sample is a control group (1); there is not a
%           control group (0). (default=0).
%           ALPHA: significance level (default = 0.05).
%           TAIL: 2 (2-tailed, default);
%                -1 (left tailed)
%                 1 (right tailed)
%     Outputs:
%           - Mean and Standard Deviation vectors.
%           - degrees of freedom and combined variance.
%           - p-value for each comparison.
%           - alpha value corrected by Sidak procedure.
%           - whether or not Ho is rejected.
%
%      Example: 
%
%                                 Sample
%                   ---------------------------------
%                       1       2       3       4
%                   ---------------------------------
%                      7.68    7.71    7.74    7.71
%                      7.69    7.73    7.75    7.71
%                      7.70    7.74    7.77    7.74
%                      7.70    7.74    7.78    7.79
%                      7.72    7.78    7.80    7.81
%                      7.73    7.78    7.81    7.85
%                      7.73    7.80    7.84    7.87
%                      7.76    7.81            7.91
%                   ---------------------------------
%                                       
%       Data matrix must be:
%    X=[7.68 1;7.69 1;7.70 1;7.70 1;7.72 1;7.73 1;7.73 1;7.76 1;7.71 2;7.73 2;7.74 2;7.74 2;
%    7.78 2;7.78 2;7.80 2;7.81 2;7.74 3;7.75 3;7.77 3;7.78 3;7.80 3;7.81 3;7.84 3;7.71 4;7.71 4;
%    7.74 4;7.79 4;7.81 4;7.85 4;7.87 4;7.91 4];
%
%
%           Calling on Matlab the function: holm(X) (there is not a control group)
%
%           Answer is:
%
%               Group       N          Mean            Standard Deviation
%                 1         8          7.7138                0.03
%                 2         8          7.7613                0.04
%                 3         7          7.7843                0.04
%                 4         8          7.7988                0.08
% 
%   Degrees of freedom: 27 - Combined variance: 0.0022494
% 
%               Test     p-value        alpha              Comment
%               1-4      0.0013         0.0085             Reject Ho
%               1-3      0.0078         0.0102             Reject Ho
%               1-2      0.0553         0.0127             Fail to reject Ho
%               2-4      0.1254    No comparison made      Ho is accepted
%               2-3      0.3563    No comparison made      Ho is accepted
%               3-4      0.5606    No comparison made      Ho is accepted
%
%           Calling on Matlab the function: holm(X,1) (sample 1 is the control group)
%
%           Answer is:
%
%               Group       N          Mean            Standard Deviation
%                 1         8          7.7138                0.03
%                 2         8          7.7613                0.04
%                 3         7          7.7843                0.04
%                 4         8          7.7988                0.08
% 
%   Degrees of freedom: 27 - Combined variance: 0.0022494
% 
%               Test     p-value        alpha              Comment
%               1-4      0.0013         0.0170             Reject Ho
%               1-3      0.0078         0.0253             Reject Ho
%               1-2      0.0553         0.0500             Fail to reject Ho
%
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2006). Holm-Sidak t-test: a routine for multiple t-test
% comparisons.
% http://www.mathworks.com/matlabcentral/fileexchange/12786


%Input Error handling
verbose=0;
args=cell(varargin);
nu=numel(args);
if isempty(nu)
    error('Warning: Matrix of data is missed...')
elseif nu>5
    error('Warning: Max five input data are required')
end
default.values = {[],0,0.05,2,{}};
default.values(1:nu) = args;
[x ctrl alpha tail grplabels] = deal(default.values{:});
if isempty(x)
    error('Warning: X matrix is empty...')
end
if isvector(x)
    error('Warning: x must be a matrix, not a vector.');
end
if ~all(isfinite(x(:))) || ~all(isnumeric(x(:)))
    error('Warning: all X values must be numeric and finite')
end
%check if x is a Nx2 matrix
if size(x,2) ~= 2
    error('Warning: HOLM requires a Nx2 input matrix')
end
%check if x(:,2) are all whole elements
if ~isequal(x(:,2),round(x(:,2)))
    error('Warning: all elements of column 2 of input matrix must be whole numbers')
end
if nu>1 %check the ctrl value
    if ~isscalar(ctrl) || ~isfinite(ctrl) || ~isnumeric(ctrl) || isempty(ctrl)
        error('Warning: it is required a scalar, numeric and finite CTRL value.')
    end
    if ctrl ~= 0 && ctrl ~= 1 %check if tst is 0 or 1
        error('Warning: CTRL must be 0 for multiple comparisons without a control group or 1 if a control group is present.')
    end
end
if nu>2 %check the alpha value
    if ~isscalar(alpha) || ~isnumeric(alpha) || ~isfinite(alpha) || isempty(alpha)
        error('Warning: it is required a numeric, finite and scalar ALPHA value.');
    end
    if alpha <= 0 || alpha >= 1 %check if alpha is between 0 and 1
        error('Warning: ALPHA must be comprised between 0 and 1.')
    end
end
if nu>3 %check the tail value
    if ~isscalar(tail) || ~isfinite(tail) || ~isnumeric(tail) || isempty(tail)
        error('Warning: it is required a scalar, numeric and finite TAIL value.')
    end
    a=[-1 1 2];
    if isempty(a(a==tail))%check if tail is -1 1 or 2
        error('Warning: TAIL must be -1 1 or 2.')
    end
end

if isempty(grplabels)
    grplabels={};
    for i=1:size(x,1)
        grplabels{i}=num2str(i);
    end
end
clear args default nu

k=max(x(:,2)); %groups
N=crosstab(x(:,2))'; %elements of each group
n=sum(N); %total elements
Md=ones(1,k); %Means vector preallocation
Sd=ones(1,k); %Standard deviations vector preallocation
outmat=eye(length(grplabels))*-1;
% Calculate mean and standard deviation of each group
if verbose
    disp('          Group               N          Mean            Standard Deviation')
end
for I=1:k
    Md(I)=mean(x(x(:,2)==I,1));
    Sd(I)=std(x(x(:,2)==I,1));
    if verbose
        fprintf(' %d - %12s         %d     %11.4f         %11.4f\n',I,grplabels{I},N(I),Md(I),Sd(I))
        disp(' ')
    end
end


df=n-k; %degrees of freedom
s2=sum((N-1).*Sd.^2)/df; %combined variance

clear n Sd %clear unnecessary variables

if verbose
    fprintf('Degrees of freedom: %d - Combined variance: %0.4f\n',df,s2)
    disp(' ')
end

%if there is not a control group, the max number of comparisons are
%k*(k-1)/2; otherwise there it is k-1.
switch ctrl
    case 0 %without a control group
        a=k-1; %rows of probability matrix
        c=0.5*k*(k-1); %max number of comparisons
     case 1
        a=1; %row of probability matrix
        c=k-1; %max number of comparisons
end

count=0; %counter
%preallocation of p-value vectors
p=ones(1,c); pb{c,1} = []; 
resmat={};
for I=1:a
    for J=I+1:k
        count=count+1;
        t=diff(Md([I J]))/realsqrt(s2*sum(1./N([I J]))); %t-value
        resmat{count}=[I,J];
        switch tail
            case -1
                p(count)=tcdf(t,df); %2-tailed p-value vector
            case 1
                p(count)=tcdf(-t,df); %2-tailed p-value vector
            case 2
                p(count)=2*tcdf(-abs(t),df); %2-tailed p-value vector
        end
        pb(count)={strcat(int2str(I),'-',int2str(J))}; %vectors of comparisons
    end
end
clear df Md N s2 a k t count i j %clear unnecessary variables

[p,I]=sort(p); %sorted p-value vector
pb=pb(I);
J=1:c; %How many corrected alpha value?
alphacorr=1-((1-alpha).^(1./(c-J+1))); %Sidak alpha corrected values

%Compare the p-values with alpha corrected values. 
%If p<a reject Ho; else don't reject Ho: no more comparison are required.
if verbose
    disp('Test     p-value        alpha              Comment')
end
comp=1; %compare checker
for J=1:c
    if comp %Comparison is required
        if p(J)<alphacorr(J)
            if verbose
                fprintf('%s %11.4f    %11.4f             Reject Ho\n',pb{J},p(J),alphacorr(J))
            end
            outmat(resmat{I(J)}(1),resmat{I(J)}(2))=1;
        else
            if verbose
                fprintf('%s %11.4f    %11.4f             Fail to reject Ho\n',pb{J},p(J),alphacorr(J))
            end
            comp=0; %no more comparison are required
        end
    else %comparison is unnecessary
        if verbose
            fprintf('%s %11.4f    No comparison made      Ho is accepted\n',pb{J},p(J))
        end
    end
end