function newstr = remove_backslash(oldstr)
    newstr = strrep(oldstr, '\', '');
end