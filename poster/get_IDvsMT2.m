function [IDown, IDother,MTown,MTother,IDefL,IDefR,MTL,MTR,IDefLu,IDefRu,MTLu,MTRu,HL,HR,HLu,HRu,CL,CR,CLu,CRum,FRu,FLu] = get_IDvsMT2(experiment,grp)
if nargin<2,grp=1;end

%U=[1,4,5,7,10];
C=[2,3,6,8,9];

IDown=zeros(0,0,0);
IDother=zeros(0,0,0);
MTown=zeros(0,0,0);
MTother=zeros(0,0,0);
IDefL=zeros(0,0,0,0,0);
IDefR=zeros(0,0,0,0,0);
MTL=zeros(0,0,0,0,0);
MTR=zeros(0,0,0,0,0);
IDefLu=zeros(0,0,0,0);
IDefRu=zeros(0,0,0,0);
MTLu=zeros(0,0,0,0);
MTRu=zeros(0,0,0,0);
HR=zeros(0,0,0,0,0);
HL=zeros(0,0,0,0,0);
HRu=zeros(0,0,0,0);
HLu=zeros(0,0,0,0);
CR=zeros(0,0,0,0,0);
CL=zeros(0,0,0,0,0);
CRu=zeros(0,0,0,0);
CLu=zeros(0,0,0,0);

FRu=zeros(0,0,0,0);
FLu=zeros(0,0,0,0);

if grp
    i=zeros(2,3);
else
    i=zeros(10,3);
end

for p=1:10     % participant number
    %Load participant p from disk
    pp=experiment(p);
    
    %Choose between group-based or participant-based sorting. 
    if grp==1
        if any(C==p)
            g=1;
        else
            g=2;
        end
    else
        g=p;
    end
    
    %Iterate over within factors
    for s=1:3  % session number
        for a=1:2 % left: difficult, easy
            for b=1:3   % right: difficult, medium, easy
                for c=1:3 % replication number
                    %Bimanual and bilateral IDef and MT
                    idx=(p-1)*3+c;
                    IDefR(g,s,a,b,idx)=pp(s).bimanual{a,b,c}.ts.RIDef;
                    IDefL(g,s,a,b,idx)=pp(s).bimanual{a,b,c}.ts.LIDef;
                    MTL(g,s,a,b,idx)=median(pp(s).bimanual{a,b,c}.oscL.MT);
                    MTR(g,s,a,b,idx)=median(pp(s).bimanual{a,b,c}.oscR.MT);
                    HL(g,s,a,b,c)=median(pp(s).bimanual{a,b,c}.ts.LHarmonicity);
                    HR(g,s,a,b,c)=median(pp(s).bimanual{a,b,c}.ts.RHarmonicity);
                    CL(g,s,a,b,c)=median(pp(s).bimanual{a,b,c}.ts.LCircularity);
                    CR(g,s,a,b,c)=median(pp(s).bimanual{a,b,c}.ts.RCircularity);
                    
                    %Unimanual IDef and MT
                    if b==1
                        IDefLu(g,s,a,idx)=pp(s).uniLeft{a,c}.ts.IDef;
                        MTLu(g,s,a,idx)=median(pp(s).uniLeft{a,c}.osc.MT);
                        HLu(g,s,a,c)=median(pp(s).uniLeft{a,c}.ts.Harmonicity);
                        CLu(g,s,a,c)=median(pp(s).uniLeft{a,c}.ts.Circularity);
                        [Lf, freqs]=LockingStrenth.get_welch_periodogram(pp(s).uniLeft{a,c}.ts.xnorm);
                        FLu(g,s,a,c)=freqs(Lf==max(Lf));
                    end
                    if a==1
                        IDefRu(g,s,b,idx)=pp(s).uniRight{b,c}.ts.IDef;                    
                        MTRu(g,s,b,idx)=median(pp(s).uniRight{b,c}.osc.MT);
                        HRu(g,s,b,c)=median(pp(s).uniRight{b,c}.ts.Harmonicity);
                        CRu(g,s,b,c)=median(pp(s).uniRight{b,c}.ts.Circularity);
                        [Rf, freqs]=LockingStrenth.get_welch_periodogram(pp(s).uniRight{b,c}.ts.xnorm);
                        FRu(g,s,b,c)=freqs(Rf==max(Rf));
                    end
                    
                    %Bimanual de-lateralized IDef and MT
                    i(g,s)=i(g,s)+1;
                    IDown(g,s,i(g,s))=pp(s).bimanual{a,b,c}.ts.LIDef;
                    MTown(g,s,i(g,s))=median(pp(s).bimanual{a,b,c}.oscL.MT);
                    IDother(g,s,i(g,s))=pp(s).bimanual{a,b,c}.ts.RIDef;
                    MTother(g,s,i(g,s))=median(pp(s).bimanual{a,b,c}.oscR.MT);                    
                    i(g,s)=i(g,s)+1;
                    IDown(g,s,i(g,s))=pp(s).bimanual{a,b,c}.ts.RIDef;
                    MTown(g,s,i(g,s))=median(pp(s).bimanual{a,b,c}.oscR.MT);
                    IDother(g,s,i(g,s))=pp(s).bimanual{a,b,c}.ts.LIDef;
                    MTother(g,s,i(g,s))=median(pp(s).bimanual{a,b,c}.oscL.MT);
                end
            end
        end
    end
end
end