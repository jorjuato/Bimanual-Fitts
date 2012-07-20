function [ALeft,ARight,R2Left,R2Right,pvalueLeft,pvalueRight,IDefL,IDefR,MTL,MTR]=regression_participant(pp)
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
                x=squeeze(IDefR(ss,a,:,:)); x=x(:);
                y=squeeze(MTR(ss,a,:,:));   y=y(:);
                [bb,bint,R,rint,stats]=regress(y,([x,ones(size(x))]),.05);
                ARight(ss,a,1)=bb(2); % constant MT=bb(2) + ID*bb(1)
                ARight(ss,a,2)=bb(1);
                R2Right(ss,a)=stats(1);
                pvalueRight(ss,a)=stats(3);
                % regression Left
                x=squeeze(IDefL(ss,a,:,:)); x=x(:);
                y=squeeze(MTL(ss,a,:,:));   y=y(:);
                [bb,bint,R,rint,stats]=regress(y,([x,ones(size(x))]),.05);
                ALeft(ss,a,1)=bb(2); % constant MT=b(2) + ID*b(1)
                ALeft(ss,a,2)=bb(1);
                R2Left(ss,a)=stats(1);
                pvalueLeft(ss,a)=stats(3);
            end
        end
    end
end