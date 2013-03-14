function get_bimanual(obj)
    data = c3d_load('DIR',obj.conf.blockpath);
    %Assumes ID left as the first experimental factor
    WList = getWLeft(data)/100;
    %Assumes Targets as second experimental factor and prepare levels list
    f2List = getWRight(data)/100;
    %Get replications of data and create DataStructure (DS)
    rep = getReplicationNumber(data);

    %Create DataStructure (DS)
    if rep > 1
        DS = cell(length(WList),length(f2List),rep+1);
    else
        DS = cell(length(WList),length(f2List),1);
    end
    repArr = zeros(length(WList),length(f2List));

    %Load data into DS
    for i=1:length(data)
        %Check for a valid trial
        if ~isempty(findstr(data(i).EVENTS.LABELS{end},'INVALID_TRIAL'))
            continue
        elseif isempty(findstr(data(i).EVENTS.LABELS{end},'ENDOFTRIAL'))
            display(sprintf('Data file corrupted: %s', data(i).FILE_NAME));
            display(sprintf('There may be a missing trial for TP: %d', data(i).TRIAL.TP));
            continue
        else
            %Compute indexes (f1,f2,rep) for DS
            TP = data(i).TRIAL.TP;
            tLU = data(i).TP_TABLE.TargetLU(TP);
            tRU = data(i).TP_TABLE.TargetRU(TP);
            WL=data(i).TARGET_TABLE.Height(tLU)/100;
            WR=data(i).TARGET_TABLE.Height(tRU)/100; %*100 or /100 or nothing??
            idx1 = find(WList==WL);
            idx2 = find(f2List==WR);
            repNow = repArr(idx1,idx2);
            repArr(idx1,idx2) = repNow + 1;
            ridx = repArr(idx1,idx2);            
            DS{idx1,idx2,ridx} = Trial(data(i),copy(obj.conf));
        end
    end
    obj.data_set=DS;
end
