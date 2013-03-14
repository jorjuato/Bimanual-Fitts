function info  = get_trial_info_bi(data)
    %Get basic information about the trial
    info = struct;
    info.Factor2Name = 'Targets';
    TP = data.TRIAL.TP;
    info.TP = TP;
    info.eventLabels = data.EVENTS.LABELS;
    info.eventTimes = data.EVENTS.TIMES;
    tLD = data.TP_TABLE.TargetLD(TP);
    tLU = data.TP_TABLE.TargetLU(TP);
    tRD = data.TP_TABLE.TargetRD(TP);
    tRU = data.TP_TABLE.TargetRU(TP);
    minY = data.TARGET_TABLE.Y(tLD)/100;
    maxY = data.TARGET_TABLE.Y(tLU)/100;
    LOAD = data.TP_TABLE.Load(TP);
    info.visc = data.LOAD_TABLE.D_e_visc(LOAD);
    L0 = data.TP_TABLE.InitTargetNonDom(TP);
    R0 = data.TP_TABLE.InitTargetDom(TP);
    info.inPhase = (L0 == R0);
    info.shift = data.TP_TABLE.FeedBackShift(TP)/100;
    info.W = data.TARGET_TABLE.Height(tLU)/100;
    info.A = maxY - minY;
    info.ID = log2(2*(maxY - minY)/info.W);
    info.scale = data.TP_TABLE.ScaleY(TP);
    info.offset = minY+info.shift;
    info.origin = (minY+maxY)/2;
    info.skipOsc = data.TP_TABLE.TrainOsc(TP);
    
    %Lets rename things a bit
    info.LW = info.W;
    info.RW = data.TARGET_TABLE.Height(tRU)/100;
    maxYL = maxY; minYL = minY;
    maxYR = data.TARGET_TABLE.Y(tRU)/100;
    minYR = data.TARGET_TABLE.Y(tRD)/100;
    info.minY = minYR;
    info.maxY = maxYR;
    info.LA = maxYL - minYL;
    info.RA = maxYR - minYR;
    info.LID = log2(2*info.LA/info.LW);
    info.RID = log2(2*info.RA/info.RW);
    info.Factor2 = info.RW;
end
        
