function [IDown, IDother,MTown,MTother,IDefL,IDefR,MTL,MTR,IDefLu,IDefRu,MTLu,MTRu,HL,HR,HLu,HRu] = get_IDvsMT(obj,grp)
if nargin<2,grp=0;end

if isa(obj,'Experiment')
    mode='Experiment';
    exp=obj;
elseif isa(obj,'Participant')
    mode='Participant';
    pp=obj;
elseif isa(obj,'Session')
    mode='Session';
    ss=obj;
else
    display('Wrong input class')
    return
end

switch mode
    case 'Experiment'
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
        if grp
            i=zeros(2,3);
        else
            i=zeros(10,3);
        end
        for p=1:10     % participant number
            pp=exp(p);
            for s=1:3  % session number
                for a=1:2 % left: difficult, easy
                    for b=1:3   % right: difficult, medium, easy
                        for c=1:3
                            if grp==1
                                %Check whether locked or not
                                if abs(pp(s).bimanual{a,b,c}.ls.rho-1)<0.2
                                    g=1;    
                                else
                                    g=2;
                                end
                            else
                                g=p;
                            end
                            IDefR(g,s,a,b,c)=pp(s).bimanual{a,b,c}.ts.RIDef;
                            IDefL(g,s,a,b,c)=pp(s).bimanual{a,b,c}.ts.LIDef;
                            MTL(g,s,a,b,c)=median(pp(s).bimanual{a,b,c}.oscL.MT);
                            MTR(g,s,a,b,c)=median(pp(s).bimanual{a,b,c}.oscR.MT);
                            HL(g,s,a,b,c)=median(pp(s).bimanual{a,b,c}.ts.LHarmonicity);
                            HR(g,s,a,b,c)=median(pp(s).bimanual{a,b,c}.ts.RHarmonicity);
                            
                            IDefLu(g,s,a,c)=pp(s).uniLeft{a,c}.ts.IDef;
                            IDefRu(g,s,b,c)=pp(s).uniRight{b,c}.ts.IDef;
                            MTLu(g,s,a,c)=median(pp(s).uniLeft{a,c}.osc.MT);
                            MTRu(g,s,b,c)=median(pp(s).uniRight{b,c}.osc.MT);
                            HLu(g,s,a,c)=median(pp(s).uniLeft{a,c}.ts.Harmonicity);
                            HRu(g,s,b,c)=median(pp(s).uniRight{b,c}.ts.Harmonicity);
                            
                            
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
    case 'Participant'
        IDown=zeros(0,0,0);
        IDother=zeros(0,0,0);
        MTown=zeros(0,0,0);
        MTother=zeros(0,0,0);
        if grp
            i=zeros(2,3);
        else
            i=0;
        end
        for s=1:3
            for a=1:2 % left: difficult, easy
                for b=1:3   % right: difficult, medium, easy
                    for c=1:3
                        if grp
                            %Check whether locked or not
                            if abs(pp(s).bimanual{a,b,c}.ls.rho-1)<0.2
                                g=1;
                            else
                                g=2;
                            end
                            IDefR(g,s,a,b,c)=pp(s).bimanual{a,b,c}.ts.RIDef;
                            IDefL(g,s,a,b,c)=pp(s).bimanual{a,b,c}.ts.LIDef;
                            MTL(g,s,a,b,c)=median(pp(s).bimanual{a,b,c}.oscL.MT);
                            MTR(g,s,a,b,c)=median(pp(s).bimanual{a,b,c}.oscR.MT);
                            
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
                        else
                            IDefR(s,a,b,c)=pp(s).bimanual{a,b,c}.ts.RIDef;
                            IDefL(s,a,b,c)=pp(s).bimanual{a,b,c}.ts.LIDef;
                            MTL(s,a,b,c)=median(pp(s).bimanual{a,b,c}.oscL.MT);
                            MTR(s,a,b,c)=median(pp(s).bimanual{a,b,c}.oscR.MT);
                            
                            i=i+1;
                            IDown(s,i)=pp(s).bimanual{a,b,c}.ts.LIDef;
                            MTown(s,i)=median(pp(s).bimanual{a,b,c}.oscL.MT);
                            IDother(s,i)=pp(s).bimanual{a,b,c}.ts.RIDef;
                            MTother(s,i)=median(pp(s).bimanual{a,b,c}.oscR.MT);
                            
                            i=i+1;
                            IDown(s,i)=pp(s).bimanual{a,b,c}.ts.RIDef;
                            MTown(s,i)=median(pp(s).bimanual{a,b,c}.oscR.MT);
                            IDother(s,i)=pp(s).bimanual{a,b,c}.ts.LIDef;
                            MTother(s,i)=median(pp(s).bimanual{a,b,c}.oscL.MT);
                        end
                    end
                end
            end
        end
    case 'Session'
        i=0;
        for a=1:2 % left: difficult, easy
            for b=1:3   % right: difficult, medium, easy
                for c=1:3
                    IDefR(a,b,c)=ss.bimanual{a,b,c}.ts.RIDef;
                    IDefL(a,b,c)=ss.bimanual{a,b,c}.ts.LIDef;
                    MTL(a,b,c)=median(ss.bimanual{a,b,c}.oscL.MT);
                    MTR(a,b,c)=median(ss.bimanual{a,b,c}.oscR.MT);
                    
                    i=i+1;
                    IDown(i)=ss.bimanual{a,b,c}.ts.LIDef;
                    MTown(i)=median(ss.bimanual{a,b,c}.oscL.MT);
                    IDother(i)=ss.bimanual{a,b,c}.ts.RIDef;
                    MTother(i)=median(ss.bimanual{a,b,c}.oscR.MT);
                    
                    i=i+1;
                    IDown(i)=ss.bimanual{a,b,c}.ts.RIDef;
                    MTown(i)=median(ss.bimanual{a,b,c}.oscR.MT);
                    IDother(i)=ss.bimanual{a,b,c}.ts.LIDef;
                    MTother(i)=median(ss.bimanual{a,b,c}.oscL.MT);
                end
            end
        end
    otherwise
        return
end
end