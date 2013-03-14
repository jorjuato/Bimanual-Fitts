function DS = get_unimanual(obj)
    data = c3d_load('DIR',obj.conf.blockpath);
    WList = getWuni(data);
    rep = getReplicationNumber(data);
    if rep > 1
        DS = cell(length(WList),rep+1);
    else
        DS = cell(length(WList),1);
    end
    repArr = zeros(length(WList),1);
    for i=1:length(data)
        %Check for a valid trial
        if ~isempty(findstr(data(i).EVENTS.LABELS{end},'INVALID_TRIAL'))
            continue
        elseif isempty(findstr(data(i).EVENTS.LABELS{end},'ENDOFTRIAL'))
            display(sprintf('Data file corrupted: %s', data(i).FILE_NAME));
            display(sprintf('There may be a missing trial for TP: %d', data(i).TRIAL.TP));
            continue
        else
            %Compute indexes for f1,f2 and rep
            TP=data(i).TRIAL.TP;
            targetD = data(i).TP_TABLE.TargetD(TP);
            W = data(i).TARGET_TABLE.Height(targetD);
            idx1 = find(WList==W);
            repArr(idx1) = repArr(idx1) + 1;
            ridx = repArr(idx1);
            DS{idx1,ridx} = Trial(data(i),copy(obj.conf));
        end
    end
    obj.data_set=DS;
end
