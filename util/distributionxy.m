function [range,mean_val,std_val]=distributionxy(x,y,bins)
if nargin<3, bins=10; end

range=linspace(min(x),max(x),bins);
mean_val=zeros(length(range)-1,1);    
std_val=zeros(length(range)-1,1);    
    for i=1:length(range)-1
        idx=(range(i)<=x) & (x<=range(i+1));
        mean_val(i)=nanmean(y(idx));
        if length(y(idx))>1          
            std_val(i)=std(y(idx));
        end
    end
range=range(1:end-1)';
end
