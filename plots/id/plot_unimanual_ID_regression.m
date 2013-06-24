function plot_unimanual_ID_regression(obj)
    i=strcmp('MT',obj.vnamesB);
    j=strcmp('IDOwnEf',obj.vnamesU);
    mtr=obj.dataR(i,:);
    mtl=obj.dataL(i,:,:,:,[1,2]);
    idr=obj.dataR(j,:);
    idl=obj.dataL(j,:,:,:,[1,2]);
    mt=[mtr(:);mtl(:)];
    id=[idr(:);idl(:)];
    mdl=LinearModel.fit(id,mt,'VarNames',{'ID','MT'})
    plot(mdl);
end
    
