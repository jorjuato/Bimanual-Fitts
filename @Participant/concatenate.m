function concatenate(obj)
    S=getValidSessions(obj);
    for s=1:length(S)
        blks=properties(obj.sessions(S(s)));
        for b=1:length(blks)
            if isa(obj.sessions(S(s)).(blks{b}),'Block')
                obj.sessions(S(s)).(blks{b}).concatenate();
            end
        end
    end
end
        