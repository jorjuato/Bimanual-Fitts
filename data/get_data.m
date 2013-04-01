function obj = get_data(xp,grp)
    if nargin<1,xp=Experiment();end
    if nargin<2,grp=0;end

    %Set some globals for data fetching
    global vtypes
    global C
    vtypes={'osc','vf','ls'};
    C=[2,3,6,8,9];
    obj=struct;
    
    %Define properties and names arrays
    get_variables(obj);
    if grp==1, g=2; else g=10; end
    hands=2; idl=2; idr=3; ss=3; r=3;
    
    
    %Do the real thing!
    tic
    obj.dataU=zeros(length(obj.vnamesU),hands,g,ss,idr,r);    
    obj.dataB=zeros(length(obj.vnamesB),hands,g,ss,idl,idr,r);
    get_data_averaged(xp,obj);
    obj.dataL = squeeze(obj.dataU(:,1,:,:,:,:));
    obj.dataR = squeeze(obj.dataU(:,2,:,:,:,:));
    obj.dataRel = get_data_rel(obj);
    obj.dataD = merge_ID_factors(obj.dataB);
    toc
end

function get_variables(obj)
    global vtypes
    obj.vnamesB={};
    obj.vtypesB={};
    obj.vnamesU={};
    obj.vtypesU={};
    for v=1:length(vtypes)
        if strcmp('osc',vtypes{v})
            vars=Oscillations.get_anova_variables();
            obj.vnamesB=[ obj.vnamesB, vars];
            obj.vnamesU=[ obj.vnamesU, vars];
            obj.vtypesB=[ obj.vtypesB, repmat(vtypes(v),1,length(vars))];
            obj.vtypesU=[ obj.vtypesU, repmat(vtypes(v),1,length(vars))];
        elseif strcmp('vf',vtypes{v})
            vars=VectorField.get_anova_variables();
            obj.vnamesB=[ obj.vnamesB, vars];
            obj.vnamesU=[ obj.vnamesU, vars];
            obj.vtypesB=[ obj.vtypesB, repmat(vtypes(v),1,length(vars))];
            obj.vtypesU=[ obj.vtypesU, repmat(vtypes(v),1,length(vars))];        
        else
            vars=LockingStrength.get_anova_variables();
            obj.vnamesB=[ obj.vnamesB, vars];
            obj.vtypesB=[ obj.vtypesB, repmat(vtypes(v),1,length(vars))];        
        end    
    end
end
