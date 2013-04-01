function exportdata2R(dataB,dataU,varnamesB,varnamesU,vartypesB)

pp_by_groups=[[2,3,6,8,9];[1,4,5,7,10]];
grp=size(pp_by_groups,1);
[varBno,h,pp,ss,idl,idr,reps]=size(dataBi);
[varUno,~,~,~,~,~]=size(dataUn);

%Build bimanual header
headerB={'grp' 'pp' 'S' 'IDR' 'IDL'};
for v=1:length(varnamesB)
    if strcmp(vartypesB{v},'ls')
        %only one meaningful data per variable
        headerB{end+1}=varnamesB{v};
    else
        %Each hand has a value per variable
        headerB{end+1}=[varnamesB{v} 'L'];
        headerB{end+1}=[varnamesB{v} 'R'];
    end
end
%Build unimanual header
headerU={'grp' 'pp' 'S' 'ID' varnamesU{:}};

outB =zeros(grp*ss*idl*idr*reps,length(headerB)+length(varBno));
outUL=zeros(grp*ss*idl*reps,length(headerU)+length(varUno));
outUR=zeros(grp*ss*idr*reps,length(headerU)+length(varUno));

idx=0;
for g=1:grp
    for p=pp_by_groups(g)
        for s=1:ss
            for l=1:idl
                for r=1:idr
                    for rep=1:reps
                        %Fetch bimanual data
                        row=[g,p,s,l,r];
                        for v=1:length(varnamesB)
                            if strcmp(vartypesB{v},'ls')
                                %only one meaningful data per variable
                                row=[row,dataB(v,1,p,s,l,r,rep)];
                            else
                                %Each hand has a value per variable
                                row=[row,suqueeze(dataB(v,:,p,s,l,r,rep))'];
                            end
                        end
                        %Load bimanual
                        outB(idx,:)

end