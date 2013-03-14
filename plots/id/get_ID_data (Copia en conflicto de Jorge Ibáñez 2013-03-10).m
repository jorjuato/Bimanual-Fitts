function [IDown,IDother,MTown,rho] = get_ID_data(biData,biNames,plot_mode)
    if nargin<2, error('Not enough input arguments'); end
    if nargin<3, plot_mode='grp'; end
    
    %Rearrange data matrices by group if needed
    if isempty(findstr('pp', plot_mode)) && size(biData,3)==10
        biData=group_participant_data(biData);
    end
        
    switch plot_mode
        case 'all'
            [IDown,IDother,MTown,rho] = get_ID_data_fcn(biData,biNames,{});
        case 'grp'
            [IDown,IDother,MTown,rho] = get_ID_data_fcn(biData,biNames,{'grp'});
        case 'ss'
            [IDown,IDother,MTown,rho] = get_ID_data_fcn(biData,biNames,{'ss'});
        case 'pp'
            [IDown,IDother,MTown,rho] = get_ID_data_fcn(biData,biNames,{'grp'});
        case 'grp-ss'
            [IDown,IDother,MTown,rho] = get_ID_data_fcn(biData,biNames,{'grp','ss'});
        case 'ss-grp'
            [IDown,IDother,MTown,rho] = get_ID_data_fcn(biData,biNames,{'ss','grp'});
        case 'pp-ss'
            [IDown,IDother,MTown,rho] = get_ID_data_fcn(biData,biNames,{'grp','ss'});
        case 'ss-pp'
            [IDown,IDother,MTown,rho] = get_ID_data_fcn(biData,biNames,{'ss','grp'});
    end
end

function [IDown,IDother,MTown,rho] = get_ID_data_fcn(biData,biNames,keep_dim)
    %Get data by rearranging matrices, one at a time
    v=strcmp('IDOwnEf', biNames);
    IDown=squeeze(biData(v,:,:,:,:,:,:)); %Remove var dimension
    IDown=rearrange_mat(IDown,keep_dim);
    v=strcmp('IDOtherEf', biNames);
    IDother=squeeze(biData(v,:,:,:,:,:,:));%Remove var dimension
    IDother=rearrange_mat(IDother,keep_dim);
    v=strcmp('MTOwn', biNames);
    MTown=squeeze(biData(v,:,:,:,:,:,:));%Remove var dimension
    MTown=rearrange_mat(MTown,keep_dim);
    v=strcmp('rho', biNames);
    rho=squeeze(biData(v,:,:,:,:,:,:));%Remove var dimension
    rho=rearrange_mat(rho,keep_dim);
end

function [newmat] = rearrange_mat(biData,keep_dim)
    dims={'hand','grp','ss','idl','idr','rep'};
    del_dims=dims;
    oldorder=size(biData);
    neworder=oldorder(:); %Vector of dimensions
    newshape={};          %Cell of dim sizes
    remaining=1;
    
    if isempty(keep_dim)
        newmat=biData(:);
        return
    end
    
    %First, put the dimensions you want to keep
    for d=1:length(keep_dim)
        v=strcmp(keep_dim{d},dims);
        idx=find(v==1);
        neworder(d)=idx;
        newshape{d}=oldorder(idx);
        v=strcmp(keep_dim{d},del_dims);
        del_dims(v==1)=[];    
    end
    
    %Then, put discarded dimensions
    for d=1:length(del_dims)
        v=strcmp(del_dims{d},dims);
        idx=find(v==1);
        neworder(d+length(keep_dim))=idx;
        remaining=remaining*oldorder(idx);
    end
    newshape{end+1}=remaining;
    newmat=permute(biData,neworder);
    newmat=reshape(newmat,newshape{:});
end