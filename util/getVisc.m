function ViscList = getVisc(data)
%Get a sorted list of Widths used in the experiment
    ViscList = zeros(0,0);
    TPList = zeros(0,0);
    
    % This loop select only the TP used in the experiment
    % which can be different from those in TARGET_TABLE/TP_TABLE
    for tr=1:length(data)
        TPList(tr) = data(tr).TRIAL.TP;        
    end
    
    %Get Viscosities used
    LOADS = data(1).TP_TABLE.Load(TPList);
    ViscTmp = data(1).LOAD_TABLE.D_e_visc(LOADS);
    
    %This loop removes repetition in viscosities
    for i=1:length(ViscTmp)
        if isempty(find(ViscList == ViscTmp(i), 1))
            ViscList(end+1) = ViscTmp(i);
        end
    end
    ViscList = sort(ViscList);
end