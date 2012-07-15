function [ALeft,ARight,R2Left,R2Right,pvalueLeft,pvalueRight,IDefL,IDefR,MTL,MTR]=regression_participant2D(pp)
    %for session=[1,4,7]
    for ss=1:3
        %ss=ss+1;
        for a=1:2 % left: difficult, easy
            for b=1:3   % right: difficult, medium, easy
                for c=1:3
                    IDefR(ss,a,b,c)=pp(ss).bimanual{a,b,c}.ts.RIDef;
                    IDefL(ss,a,b,c)=pp(ss).bimanual{a,b,c}.ts.LIDef;
                    MTL(ss,a,b,c)=median(pp(ss).bimanual{a,b,c}.oscL.MT);
                    MTR(ss,a,b,c)=median(pp(ss).bimanual{a,b,c}.oscR.MT);
                end
                % regression Right
                x=squeeze(IDefR(ss,a,b,:)); x=x(:);
                y=squeeze(MTR(ss,a,b,:));   y=y(:);
                [bb,bint,R,rint,stats]=regress(y,([x,ones(size(x))]),.05);
                ARight(ss,a,b,1)=bb(2); % constant MT=b(2) + ID*b(1)
                ARight(ss,a,b,2)=bb(1);
                R2Right(ss,a,b)=stats(1);
                pvalueRight(ss,a,b)=stats(3);
                % regression Left
                x=squeeze(IDefL(ss,a,b,:)); x=x(:);
                y=squeeze(MTL(ss,a,b,:));   y=y(:);
                [bb,bint,R,rint,stats]=regress(y,([x,ones(size(x))]),.05);
                ALeft(ss,a,b,1)=bb(2); % constant MT=b(2) + ID*b(1)
                ALeft(ss,a,b,2)=bb(1);
                R2Left(ss,a,b)=stats(1);
                pvalueLeft(ss,a,b)=stats(3);
            end
        end
    end
    plot_it(ARight);
    plot_it(ALeft);
end

function plot_it(A)
[s,l,r,~]=size(A);   
colors={'r+','g+','b+';'ro','go','bo'};
figure; 
hold on;
for ss=1:s
    for idl=1:l
        plot(A(ss,:,idl),colors{idl,ss});
    end
    legend();
end
hold off     
end