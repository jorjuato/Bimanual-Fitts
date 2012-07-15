function [IDefL,IDefR,MTL,MTR,IDefLu,IDefRu,MTLu,MTRu,HL,HR,HLu,HRu,CL,CR,CLu,CRu,FRu,FLu] = get_and_sort_variables(expmt,grp)
if nargin<2,grp=1;end
if nargin<1,expmt=Experiment();end

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

%Prepare indexes for group-based or participant-based sorting. 
if grp==1
    i=zeros(2,1);
    %U=[1,4,5,7,10];
    C=[2,3,6,8,9];
else
    i=zeros(10,1);
end

for p=1:10     % participant number
    %Load participant p from disk
    pp=expmt(p);
    
    %Choose between group-based or participant-based sorting. 
    if grp==1 %Group based sorting
        if any(C==p) %Coupled group has index 1
            g=1;
        else         %Uncoupled group has  index 2
            g=2;
        end
    else      %Participant-based sorting
        g=p;
    end
    %Increase count for this participant/group
    i(g)=i(g)+1;
    
    %Iterate over within factors
    for s=1:3  % session number
        for a=1:2 % left: difficult, easy
            for b=1:3   % right: difficult, medium, easy
                for c=1:3 % replication number
                    %Compute index based on i vector and actual replication
                    idx=(i(g)-1)*3+c;
                    
                    %Bimanual and bilateral                    
                    IDefR(g,s,a,b,idx)=pp(s).bimanual{a,b,c}.ts.RIDef;
                    IDefL(g,s,a,b,idx)=pp(s).bimanual{a,b,c}.ts.LIDef;
                    MTL(g,s,a,b,idx)=median(pp(s).bimanual{a,b,c}.oscL.MT);
                    MTR(g,s,a,b,idx)=median(pp(s).bimanual{a,b,c}.oscR.MT);
                    HL(g,s,a,b,idx)=median(pp(s).bimanual{a,b,c}.ts.LHarmonicity);
                    HR(g,s,a,b,idx)=median(pp(s).bimanual{a,b,c}.ts.RHarmonicity);
                    CL(g,s,a,b,idx)=median(pp(s).bimanual{a,b,c}.ts.LCircularity);
                    CR(g,s,a,b,idx)=median(pp(s).bimanual{a,b,c}.ts.RCircularity);
                    
                    %Unimanual Left
                    if b==1
                        IDefLu(g,s,a,idx)=pp(s).uniLeft{a,c}.ts.IDef;
                        MTLu(g,s,a,idx)=median(pp(s).uniLeft{a,c}.osc.MT);
                        HLu(g,s,a,idx)=median(pp(s).uniLeft{a,c}.ts.Harmonicity);
                        CLu(g,s,a,idx)=median(pp(s).uniLeft{a,c}.ts.Circularity);
                        [Lf, freqs]=LockingStrength.get_welch_periodogram(pp(s).uniLeft{a,c}.ts.xnorm);
                        FLu(g,s,a,idx)=freqs(Lf==max(Lf));
                    end
                    
                    %Unimanual Right
                    if a==1
                        IDefRu(g,s,b,idx)=pp(s).uniRight{b,c}.ts.IDef;                    
                        MTRu(g,s,b,idx)=median(pp(s).uniRight{b,c}.osc.MT);
                        HRu(g,s,b,idx)=median(pp(s).uniRight{b,c}.ts.Harmonicity);
                        CRu(g,s,b,idx)=median(pp(s).uniRight{b,c}.ts.Circularity);
                        [Rf, freqs]=LockingStrength.get_welch_periodogram(pp(s).uniRight{b,c}.ts.xnorm);
                        FRu(g,s,b,idx)=freqs(Rf==max(Rf));
                    end                    
                end
            end
        end
    end
end
end