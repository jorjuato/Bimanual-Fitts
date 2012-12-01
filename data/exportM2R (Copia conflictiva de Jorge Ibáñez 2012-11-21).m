function exportM2R(mfile,filename,savepath)
if nargin<1, mfile='/home/jorge/Dropbox/dev/Bimanual-Fitts/data/data_bypp_avg_last.mat'; end
if nargin<2, filename='fitts.dat';end
if nargin<3, savepath=getuserdir();end

[dataB,dataU,varnamesB,varnamesU,vartypesB,vartypesU]=struct2vars(load(mfile));

pp_by_groups=[[2,3,6,8,9];[1,4,5,7,10]];
grp=size(pp_by_groups,1);

[varBno,h,pp,ss,idl,idr,reps]=size(dataB);
[varUno,~,~,~,~,~]=size(dataU);

%Build bimanual header
headerB={'grp' 'pp' 'S' 'IDL' 'IDR'};
for v=1:varBno
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

%Build output data frames
outB =zeros(grp*ss*idl*idr*reps,length(headerB));
outUL=zeros(grp*ss*idl*reps,length(headerU));
outUR=zeros(grp*ss*idr*reps,length(headerU));

idx=0;
idxR=0;
idxL=0;
for g=1:grp
    for p=pp_by_groups(g,:)
        for s=1:ss
            for l=1:idl
                for r=1:idr
                    for rep=1:reps
                        idx=idx+1;
                        %Fetch bimanual data
                        row=[g,p,s,l,r];
                        for v=1:length(varnamesB)
                            if strcmp(vartypesB{v},'ls')
                                %only one meaningful data per variable
                                row=[row,dataB(v,1,p,s,l,r,rep)];
                            else
                                %Each hand has a value per variable
                                row=[row,squeeze(dataB(v,:,p,s,l,r,rep))];
                            end
                        end
                        outB(idx,:)=row;
                        
                        %Store left unimanual only once per loop
                        if r==1
                            idxL=idxL+1;
                            row=[g,p,s,l];
                            for v=1:length(varnamesU)
                                row=[row,dataU(v,1,p,s,l,rep)];
                            end
                            outUL(idxL,:)=row;
                        end
                        %Store right unimanual only once per loop
                        if l==1
                            idxR=idxR+1;
                            row=[g,p,s,r];
                            for v=1:length(varnamesU)
                                row=[row,dataU(v,2,p,s,r,rep)];
                            end
                            outUR(idxR,:)=row;
                        end
                    end
                end
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Save bimanual data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Open file, print header and close it
filepath=joinpath(savepath,['Bi_' filename]);
outfd = fopen(filepath, 'w+');
%printh=sprintf('%s,' ,headerU{:});
%fprintf(outfd, '%s', printh(1:end-1));
fprintf(outfd, '%s,',headerB{:});
fseek(outfd, -1, 0);
fprintf(outfd,'\n');
fclose(outfd);
%Print the real data, much faster this way
dlmwrite (filepath,outB,'-append');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Save unimanualL data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Open file, print header and close it
filepath=joinpath(savepath,['UniL_' filename]);
outfd = fopen(filepath, 'w+');
%fprintf(outfd, '%s', header);
fprintf(outfd, '%s,',headerU{:});
fseek(outfd, -1, 0);
fprintf(outfd,'\n');
fclose(outfd);
%Print the real data, much faster this way
dlmwrite (filepath,outUL,'-append');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Save unimanualR data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Open file, print header and close it
filepath=joinpath(savepath,['UniR_' filename]);
outfd = fopen(filepath, 'w+');
%fprintf(outfd, '%s', header);
fprintf(outfd, '%s,',headerU{:});
fseek(outfd, -1, 0);
fprintf(outfd,'\n');
fclose(outfd);
%Print the real data, much faster this way
dlmwrite (filepath,outUR,'-append');
end
