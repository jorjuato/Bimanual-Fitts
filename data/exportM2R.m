function exportM2R(mfile,filename,savepath)
    if nargin<1, mfile='/home/jorge/Dropbox/dev/Bimanual-Fitts/data/mats/databypp.mat'; end
    if nargin<2, filename='fitts.dat';end
    if nargin<3, savepath=getuserdir();end

    global excludeVars
    global pp_by_groups
    excludeVars={'MTOwn','MTOther','IDOwn','IDOther','IDOwnEf','IDOtherEf'};
    pp_by_groups=[[2,3,6,8,9];[1,4,5,7,10]];
    
    if ischar(mfile)
        obj=load(mfile,'obj');
    else
        obj=mfile;
    end

    %Fetch and export Bimanual header and matrix
    [header,vnames2]=build_headers({'grp' 'pp' 'S' 'IDL' 'IDR'},obj.vnamesB,obj.vtypesB);
    out = get_rowdata(obj.dataB,obj.vtypesB,obj.vnamesB,vnames2,header);  
    export_matrix(out,header,joinpath(savepath,['Bi_' filename]));
    
    %Fetch and export Bimanual Delta ID header and matrix
    [header,vnames2]=build_headers({'grp' 'pp' 'S' 'DID'},obj.vnamesB,obj.vtypesB);
    out = get_rowdata(obj.dataD,obj.vtypesB,obj.vnamesB,vnames2,header);  
    export_matrix(out,header,joinpath(savepath,['BiDelta_' filename]));
    
    %Fetch and export Unimanual header and matrix
    [header,vnames2]=build_headers({'grp' 'pp' 'S' 'ID'},obj.vnamesU,obj.vtypesU);
    out = get_rowdata(obj.dataL,obj.vtypesU,obj.vnamesU,vnames2,header);  
    export_matrix(out,header,joinpath(savepath,['UniL_' filename]));
    out = get_rowdata(obj.dataR,obj.vtypesU,obj.vnamesU,vnames2,header);  
    export_matrix(out,header,joinpath(savepath,['UniR_' filename]));
end

function export_matrix(matrix,header,filepath)    
    %Open file
    fd = fopen(filepath, 'w+');
    %Print header
    fprintf(fd, '%s,',header{:});
    fseek(fd, -1, 0);
    fprintf(fd,'\n');
    fclose(fd);
    %Print the real data, much faster this way
    dlmwrite (filepath,matrix,'-append');
end

function out = get_rowdata(data,vartypes,varnames1,varnames2,header)    
    global pp_by_groups
       
    %Build output data frames
    grp=size(pp_by_groups,1);
    
    if length(size(data))==7
        [vno,h,pp,ss,idl,idr,reps]=size(data);
        out =zeros(grp*ss*idl*idr*reps,length(header));
        bimanual=1;
    elseif length(size(data))==6
        [vno,h,pp,ss,id,reps]=size(data);
        out =zeros(grp*ss*id*reps,length(header));
        bimanual=1;
        idl=0;
    else 
        [vno,pp,ss,id,reps]=size(data);
        out =zeros(grp*ss*id*reps,length(header));
        bimanual=0;
        idl=0;
    end
    
    %Iterate!!
    idx=0;
    for g=1:grp
        for p=pp_by_groups(g,:)
            for s=1:ss
                %Unimanual and ID diff blocks
                if ~idl
                    for i=1:id
                       for rep=1:reps
                            idx=idx+1;
                            %Fetch bimanual data
                            row=[g,p,s,i];
                            for v=1:length(varnames2)
                                v2=strmatch(varnames2{v},varnames1,'exact');
                                %ID diff blocks
                                if bimanual
                                    if strcmp(vartypes{v2},'ls')
                                        %only one meaningful data per magnitude
                                        row=[row,data(v2,1,p,s,i,rep)];
                                    else
                                        %two meaningful data per magnitude
                                        row=[row,squeeze(data(v2,:,p,s,i,rep))];
                                    end
                                %Unimanual blocks
                                else
                                   row=[row,squeeze(data(v2,p,s,i,rep))];
                                end
                            end
                            out(idx,:)=row;
                       end
                    end
                %Bimanual blocks
                else
                    for l=1:idl
                        for r=1:idr
                            for rep=1:reps
                                idx=idx+1;
                                %Fetch bimanual data
                                row=[g,p,s,l,r];
                                for v=1:length(varnames2)
                                    v2=strmatch(varnames2{v},varnames1,'exact');
                                    if strcmp(vartypes{v2},'ls')
                                        %only one meaningful data per variable
                                        row=[row,data(v2,1,p,s,l,r,rep)];
                                    else
                                        %Each hand has a value per variable
                                        row=[row,squeeze(data(v2,:,p,s,l,r,rep))];
                                    end
                                end
                                out(idx,:)=row;
                            end
                        end
                    end
                end
            end
        end
    end
    out=remove_NaNs(out);
end

function [header,varnames2]=build_headers(factors,varnames,vartypes)
    global excludeVars
    header=factors;
    varnames2 = varnames(~ismember(varnames,excludeVars));
    for v=1:length(varnames2)
        v2=strmatch(varnames2{v},varnames,'exact');
        if strcmp(vartypes{v2},'ls')
            %only one meaningful data per variable
            header{end+1}=varnames{v2};
        elseif any(strcmp('IDL',factors)) || any(strcmp('DID',factors))
            %Each hand has a value per variable
            header{end+1}=[varnames{v2} 'L'];
            header{end+1}=[varnames{v2} 'R'];            
        else
            header{end+1}=varnames{v2};
        end
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
        
