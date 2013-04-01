function flist = load_interactions(fname)
    if nargin==0, fname='anova.out'; end
    
    flist={};
    % open the file
    fid = fopen(fname);

    % read the file
    tline = fgetl(fid);
    while ischar(tline)
        a=strread(tline,'%s','delimiter',' ');
        if length(a)==1
            flist{end+1}=a;
        else
            fl={};
            for f=1:length(a)-1
                modifiedStr = lower(strrep(a{f+1}, 'S', 'SS'));                
                fl{f}=strread(modifiedStr,'%s','delimiter',':');
            end
            flist{end+1}={a{1},fl};
        end
        tline = fgetl(fid);
    end
    
    % close the file
    fclose(fid);
end