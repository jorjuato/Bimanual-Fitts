function rep = getReplicationNumber(data)
    rep = 0;
    for tr=1:length(data)
        %if findstr(data(tr).EVENTS.LABELS{end},'INVALID_TRIAL')
        %    continue
        if data(tr).TRIAL.TP == 1 && ~isempty(findstr(data(tr).EVENTS.LABELS{end},'ENDOFTRIAL'))
            rep = rep+1;
        end
    end
end