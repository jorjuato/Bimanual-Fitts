function [ALeft,ARight,R2Left,R2Right,pvalueLeft,pvalueRight]=temp_regression(data_path)
    if nargin==0, data_path=joinpath(joinpath(getuserdir(),'KINARM'),'save');end
    for pp=1:10
        load(joinpath(data_path,sprintf('participant%03d',pp)));
        ss=0;
        for session=[1,4,7]
            ss=ss+1;
            for a=1:2 % left: difficult, easy
                for b=1:3   % right: difficult, medium, easy
                    for c=1:3
                        IDefR(pp,ss,a,b,c)=obj.sessions(session).bimanual.data_set{a,b,c}.ts.RIDef;
                        IDefL(pp,ss,a,b,c)=obj.sessions(session).bimanual.data_set{a,b,c}.ts.LIDef;
                        MTL(pp,ss,a,b,c)=median(obj.sessions(session).bimanual.data_set{a,b,c}.oscL.MT);
                        MTR(pp,ss,a,b,c)=median(obj.sessions(session).bimanual.data_set{a,b,c}.oscR.MT);
                    end
                    % regression Right
                    x=squeeze(IDefR(pp,ss,a,:,:)); x=x(:);
                    y=squeeze(MTR(pp,ss,a,:,:));   y=y(:);
                    [b,bint,R,rint,stats]=regress(y,([x,ones(size(x))]),.05);
                    ARight(pp,ss,a,1)=b(2); % constant MT=b(2) + ID*b(1)
                    ARight(pp,ss,a,2)=b(1);
                    R2Right(pp,ss,a)=stats(1);
                    pvalueRight(pp,ss,a)=stats(3);
                    % regression Left
                    x=squeeze(IDefL(pp,ss,a,:,:)); x=x(:);
                    y=squeeze(MTL(pp,ss,a,:,:));   y=y(:);
                    [b,bint,R,rint,stats]=regress(y,([x,ones(size(x))]),.05);
                    ALeft(pp,ss,a,1)=b(2); % constant MT=b(2) + ID*b(1)
                    ALeft(pp,ss,a,2)=b(1);
                    R2Left(pp,ss,a)=stats(1);
                    pvalueLeft(pp,ss,a)=stats(3);
                end
            end
        end
    end
    C=[2,3,6,8,9];U=[1,4,5,7,10];
end