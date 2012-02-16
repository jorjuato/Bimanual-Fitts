function W = getWRight(data)
%Get a sorted list of Widths used in the experiment
    W = zeros(0,0);
    TPList = zeros(0,0);
    TP_TABLE = data.TP_TABLE;
    
    % This loop select only the TP used in the experiment
    % which can be different from those in TARGET_TABLE/TP_TABLE
    for tr=1:length(data)
        TPList(tr) = data(tr).TRIAL.TP;        
    end
    
    %Get Targets and Widths used
    Targets = TP_TABLE.TargetRD(TPList);
    Wtmp = data(1).TARGET_TABLE.Height(Targets);
    
    %This loop removes repetition in W due to the factor relative phase
    for i=1:length(Wtmp)
        if isempty(find(W == Wtmp(i), 1))
            W(end+1) = Wtmp(i);
        end
    end
    W = sort(W);
end