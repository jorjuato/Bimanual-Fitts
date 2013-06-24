function obj = get_all_data(xp,grp)
    if nargin<1,xp=Experiment();end
    if nargin<2,grp=0;end

    %Set some globals for data fetching
    global vtypes
    global C
    vtypes={'osc','vf','ls'};
    C=[2,3,6,8,9];

    
    %Define properties and names arrays
    obj = get_ANOVA_variables();
    if grp==1, g=2; else g=10; end
    hands=2; idl=2; idr=3; ss=3; r=3;
    
    
    %Do the real thing!
    tic
    obj.dataU=zeros(length(obj.vnamesU),hands,g,ss,idr,r);    
    obj.dataB=zeros(length(obj.vnamesB),hands,g,ss,idl,idr,r);
    obj = get_all_data_averaged(xp,obj);
    obj.dataL = squeeze(obj.dataU(:,1,:,:,:,:));
    obj.dataR = squeeze(obj.dataU(:,2,:,:,:,:));
    obj.dataRel = get_all_data_rel(obj);
    obj.dataD = merge_ID_factors(obj.dataB);
    toc
end


