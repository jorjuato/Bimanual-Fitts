function exportM2R(mfile,filename,savepath)
    if nargin<1, mfile='/home/jorge/Dropbox/dev/Bimanual-Fitts/data/mats/databypp.mat'; end
    if nargin<2, filename='fitts.dat';end
    if nargin<3, savepath=getuserdir();end

    global excludeVars
    global pp_by_groups
    excludeVars={'MTOwn','MTOther','IDOwn','IDOther','IDOwnEf','IDOtherEf'};
    pp_by_groups=[[2,3,6,8,9];[1,4,5,7,10]];
    
    obj=load(mfile);
    if length(fields(obj)) == 3
        [dataB,varnamesB,vartypesB]=struct2vars(obj);
        [headerB, varnamesB2, ~, ~] = build_headers(varnamesB,vartypesB); 
        outB = get_rowdata_deltaID(dataB,varnamesB,varnamesB2,vartypesB,headerB);
        is_delta=1;
    else    
        [dataB,dataU,varnamesB,varnamesU,vartypesB,vartypesU]=struct2vars(obj);
        [headerB, varnamesB2, headerU, varnamesU2] = build_headers(varnamesB,varnamesU,vartypesB); 
        [outB, outUL, outUR] = get_rowdata_bimanual(dataB,dataU,varnamesB,varnamesU,varnamesB2,varnamesU2,vartypesB,headerB,headerU);        
        is_delta=0;
    end
    
    %Save bimanual data
    if is_delta
        filepath=joinpath(savepath,['BiDelta_' filename]);
    else
        filepath=joinpath(savepath,['Bi_' filename]);
    end
    %Open file and print header
    outfd = fopen(filepath, 'w+');
    fprintf(outfd, '%s,',headerB{:});
    fseek(outfd, -1, 0);
    fprintf(outfd,'\n');
    fclose(outfd);
    %Print the real data, much faster this way
    dlmwrite (filepath,outB,'-append');

    if ~is_delta
        %Save unimanual Left data
        filepath=joinpath(savepath,['UniL_' filename]);
        outfd = fopen(filepath, 'w+');
        fprintf(outfd, '%s,',headerU{:});
        fseek(outfd, -1, 0); %removes last comma
        fprintf(outfd,'\n');
        fclose(outfd);
        %Print the real data, much faster this way
        dlmwrite (filepath,outUL,'-append');

        %Save unimanual Right data
        filepath=joinpath(savepath,['UniR_' filename]);
        outfd = fopen(filepath, 'w+');
        fprintf(outfd, '%s,',headerU{:});
        fseek(outfd, -1, 0); %removes last comma
        fprintf(outfd,'\n');
        fclose(outfd);
        %Print the real data, much faster this way
        dlmwrite(filepath,outUR,'-append');
    end
end

function [outB, outUL, outUR] = get_rowdata_bimanual(dataB,dataU,varnamesB,varnamesU,varnamesB2,varnamesU2,vartypesB,headerB,headerU)    
    global pp_by_groups
       
    %Build output data frames
    grp=size(pp_by_groups,1);
    [varBno,h,pp,ss,idl,idr,reps]=size(dataB);
    outB =zeros(grp*ss*idl*idr*reps,length(headerB));
    outUL=zeros(grp*ss*idl*reps,length(headerU));
    outUR=zeros(grp*ss*idr*reps,length(headerU));

    %Prepare indexes
    idx=0;
    idxR=0;
    idxL=0;

    %Iterate!!
    for g=1:grp
        for p=pp_by_groups(g,:)
            for s=1:ss
                for l=1:idl
                    for r=1:idr
                        for rep=1:reps
                            idx=idx+1;
                            %Fetch bimanual data
                            row=[g,p,s,l,r];
                            for v=1:length(varnamesB2)
                                v2=strmatch(varnamesB2{v},varnamesB,'exact');
                                if strcmp(vartypesB{v2},'ls')
                                    %only one meaningful data per variable
                                    row=[row,dataB(v2,1,p,s,l,r,rep)];
                                else
                                    %Each hand has a value per variable
                                    row=[row,squeeze(dataB(v2,:,p,s,l,r,rep))];
                                end
                            end
                            outB(idx,:)=row;

                            %Store left unimanual only once per loop
                            if r==1
                                idxL=idxL+1;
                                row=[g,p,s,l];
                                for v=1:length(varnamesU2)
                                    v2=strmatch(varnamesU2{v},varnamesU,'exact');
                                    row=[row,dataU(v2,1,p,s,l,rep)];
                                end
                                outUL(idxL,:)=row;
                            end
                            %Store right unimanual only once per loop
                            if l==1
                                idxR=idxR+1;
                                row=[g,p,s,r];
                                for v=1:length(varnamesU2)
                                    v2=strmatch(varnamesU2{v},varnamesU,'exact');
                                    row=[row,dataU(v2,2,p,s,r,rep)];
                                end
                                outUR(idxR,:)=row;
                            end
                        end
                    end
                end
            end
        end
    end

    %Remove NAN's
    outB=remove_NaNs(outB);
    outUL=remove_NaNs(outUL);
    outUR=remove_NaNs(outUR);
end

function outB=get_rowdata_deltaID(dataB,varnamesB,varnamesB2,vartypesB,headerB)    
    global pp_by_groups  

    %Build output data frames
    grp=size(pp_by_groups,1);
    [varBno,h,pp,ss,did,reps]=size(dataB);
    outB =zeros(grp*ss*did*reps,length(headerB));

    %Prepare indexes
    idx=0;
    %Iterate!!
    for g=1:grp
        for p=pp_by_groups(g,:)
            for s=1:ss
                for i=1:did
                    for rep=1:reps
                        idx=idx+1;
                        %Fetch bimanual data
                        row=[g,p,s,i];
                        for v=1:length(varnamesB2)
                            v2=strmatch(varnamesB2{v},varnamesB,'exact');
                            if strcmp(vartypesB{v2},'ls')
                                %only one meaningful data per variable
                                row=[row,dataB(v2,1,p,s,i,rep)];
                            else
                                %Each hand has a value per variable
                                row=[row,squeeze(dataB(v2,:,p,s,i,rep))];
                            end
                        end
                        outB(idx,:)=row;
                    end
                end
            end
        end
    end    
    %Remove NAN's
    outB=remove_NaNs(outB);
end

function [headerB, varnamesB2, headerU, varnamesU2] = build_headers(varnamesB,varnamesU,vartypesB)  
    if nargin == 2
        headerU= {};
        varnamesU2={};
        is_delta=1;
        vartypesB=varnamesU;
    else
        is_delta=0;
    end
    
    global excludeVars
    
    if is_delta
        %Build bimanual header with delta ID
        headerB={'grp' 'pp' 'S' 'DID'};
        varnamesB2 = varnamesB(~ismember(varnamesB,excludeVars));
        for v=1:length(varnamesB2)
            v2=strmatch(varnamesB2{v},varnamesB,'exact');
            if strcmp(vartypesB{v2},'ls')
                %only one meaningful data per variable
                headerB{end+1}=varnamesB{v2};
            else
                %Each hand has a value per variable
                headerB{end+1}=[varnamesB{v2} 'L'];
                headerB{end+1}=[varnamesB{v2} 'R'];
            end
        end
    else
        headerB={'grp' 'pp' 'S' 'IDL' 'IDR'};
        varnamesB2 = varnamesB(~ismember(varnamesB,excludeVars));
        for v=1:length(varnamesB2)
            v2=strmatch(varnamesB2{v},varnamesB,'exact');
            if strcmp(vartypesB{v2},'ls')
                %only one meaningful data per variable
                headerB{end+1}=varnamesB{v2};
            else
                %Each hand has a value per variable
                headerB{end+1}=[varnamesB{v2} 'L'];
                headerB{end+1}=[varnamesB{v2} 'R'];
            end
        end
        %Build unimanual header
        varnamesU2 = varnamesU(~ismember(varnamesU,excludeVars));
        headerU={'grp' 'pp' 'S' 'ID' varnamesU2{:}};
    end   
end

function data = remove_NaNs(data)
    for i=1:size(data,2)
        d=data(:,i);
        dn=isnan(d);
        if ~isempty(dn)
            d(dn)=nanmean(d);
            data(:,i)=d(:);
        end
    end
end
        