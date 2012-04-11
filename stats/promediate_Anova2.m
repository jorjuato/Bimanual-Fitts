function promediate_Anova2(AV)
    AV.promediate=1;
    grL=AV.grLevels(:);
    ssL=AV.ssLevels(:);   % 1, 4, 7
    ppL=AV.ppLevels(:);   % 1,2,3,4,5,6,7,8,9,10
    rhL=AV.rhLevels(:);   % 1=2.6, 2=4.5, 3=5.4
    lhL=AV.lhLevels(:);   % 1=2.6; 2=5.4
    data=AV.data(:);
    AV.grLevels=[];
    AV.ssLevels=[];
    AV.ppLevels=[];
    AV.rhLevels=[];
    AV.lhLevels=[];
    AV.data=[];
    for g=[1,2]
        for p=AV.groups(g,:)
            for s=[1,4,7]
                for r=1:3
                    for l=[1,2]
                        idx=(grL==g & ssL==s & ppL==p & rhL==r & lhL==l);
                        AV.data=[AV.data;mean(data(idx))];
                        AV.grLevels=[AV.grLevels;g];
                        AV.ppLevels=[AV.ppLevels;p];  
                        AV.ssLevels=[AV.ssLevels;s];   
                        AV.rhLevels=[AV.rhLevels;r];        
                        AV.lhLevels=[AV.lhLevels;l];
                    end
                end
            end
        end
    end
end
