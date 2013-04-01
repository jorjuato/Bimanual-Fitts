function fout = sort_postgroups_did(fin)
%Extremely ugly hack to keep each group at a 
%desired position. EXPLAIN DESIGN GOALS
%rfirst is a switch that changes its behaviour giving precedence always to
%idr factor over idl.

fout=cell(1,length(fin));
grp=strcmp('grp',fin);
ss=strcmp('ss',fin);
did=strcmp('did',fin);

if any(grp)
    fout{1}='grp';
    if any(did)
        fout{2}='did';
        if any(ss)
            fout{3}='ss';
        end
    elseif any(ss)
        fout{2}='ss';
    end
elseif any(did)
    fout{1}='did';
    if any(ss)
        fout{2}='ss';
    end
elseif any(ss)
    fout{1}='ss';
else
    error('Something is wrong with your factors. Please check')
end
end