function fout = sort_postgroups(fin,rfirst)
%Extremely ugly hack to keep each group at a 
%desired position. EXPLAIN DESIGN GOALS
%rfirst is a switch that changes its behaviour giving precedence always to
%idr factor over idl.

fout=cell(1,length(fin));
grp=strcmp('grp',fin);
ss=strcmp('ss',fin);
idl=strcmp('idl',fin);
idr=strcmp('idr',fin);
if rfirst == 1
    if any(grp)
        fout{1}='grp';
        if any(idr)
            fout{2}='idr';
            if any(idl)
                fout{3}='idl';
                if any(ss)
                    fout{4}='ss';
                end
            elseif any(ss)
                fout{3}='ss';
            end
        elseif any(idl)
            fout{2}='idl';
            if any(ss)
                fout{3}='ss';
            end
        elseif any(ss)
            fout{2}='ss';
        end
    elseif any(idr)
        fout{1}='idr';
        if any(idl)
            fout{2}='idl';
            if any(ss)
                fout{3}='ss';
            end
        elseif any(ss)
            fout{2}='ss';
        end
    elseif any(idl)
        fout{1}='idl';
        if any(ss)
            fout{2}='ss';
        end
    elseif any(ss)
        fout{1}='ss';
    else
        error('Something is wrong with your factors. Please check')
    end
else
    if any(grp)
        fout{1}='grp';
        if any(idl)
            fout{2}='idl';
            if any(idr)
                fout{3}='idr';
                if any(ss)
                    fout{4}='ss';
                end
            elseif any(ss)
                fout{3}='ss';
            end
        elseif any(idr)
            fout{2}='idr';
            if any(ss)
                fout{3}='ss';
            end
        elseif any(ss)
            fout{2}='ss';
        end
    elseif any(idl)
        fout{1}='idl';
        if any(idr)
            fout{2}='idr';
            if any(ss)
                fout{3}='ss';
            end
        elseif any(ss)
            fout{2}='ss';
        end
    elseif any(idr)
        fout{1}='idr';
        if any(ss)
            fout{2}='ss';
        end
    elseif any(ss)
        fout{1}='ss';
    else
        error('Something is wrong with your factors. Please check')
    end
end
end