function var = fetch_from_ANOVA(AV)

grp=unique(AV.grLevels)';
ss=unique(AV.ssLevels)';

if isa(AV,'AnovaBimanual')
    idl=unique(AV.lhLevels)';
    idr=unique(AV.rhLevels)';
    var=zeros(0,0,0,0,0);
    
    %Iterate over within factors
    for g=1:length(grp)
        for s=1:length(ss)  % session numbers
            for l=1:length(idl) % left: difficult, easy
                for r=1:length(idr)   % right: difficult, medium, easy
                    %Create logical indexing vector
                     idx=find( (AV.grLevels==g) .*...
                               (AV.ssLevels==ss(s)) .*...
                               (AV.lhLevels==l) .*...
                               (AV.rhLevels==r) );   
                     for j=1:length(idx)
                         var(g,s,l,r,j)=AV.data(idx(j));
                     end
                end
            end
        end
    end
else
    id=unique(AV.idLevels)';
    %Iterate over within factors
    var=zeros(0,0,0,0);
    for g=1:length(grp)
        for s=1:length(ss)  % session number
            for i=1:length(id) % ID: difficult, easy
                %Create logical indexing vector
                idx=find( (AV.grLevels==g) .*...
                          (AV.ssLevels==ss(s)) .*...
                          (AV.idLevels==i));
                for j=1:length(idx)
                    var(g,s,i,j)=AV.data(idx(j));
                end
            end
        end
    end
end

