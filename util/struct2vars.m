function varargout=struct2vars(S)
    C = struct2cell(S);
    varargout = {C{:}};
end