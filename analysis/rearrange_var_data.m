function vdata = rearrange_var_data(vname,data,vnames,factors)
    if nargin<4, error('Not enough input arguments'); end
    
    %Rearrange data matrices by group if needed
    if size(data,3)==10
        data=group_participant_data(data);
    end
    
    %Fetch raw data from array removing var dimension
    if vname(end)=='L'        
        v=strcmp(vname(1:end-1), vnames);
        vdata=squeeze(data(v,1,:,:,:,:,:));  
    elseif vname(end)=='R'        
        v=strcmp(vname(1:end-1), vnames);
        vdata=squeeze(data(v,2,:,:,:,:,:));
    else
        v=strcmp(vname, vnames);
        vdata=squeeze(data(v,1,:,:,:,:,:)); 
    end
    
    %Rearrange matrices according to the desired factors    
    vdata=rearrange_mat(vdata,factors);    

end

function [newmat] = rearrange_mat(data,keep_dim)
    dims={'grp','ss','idl','idr','rep'};
    del_dims=dims;
    oldorder=size(data);
    neworder=oldorder(:); %Vector of dimensions
    newshape={};          %Cell of vectors shapes (dim sizes)
    remaining=1;
    
    if isempty(keep_dim)
        newmat=data(:);
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
    
    %Then, put discarded dimensions as a single dimensional vector
    for d=1:length(del_dims)
        v=strcmp(del_dims{d},dims);
        idx=find(v==1);
        neworder(d+length(keep_dim))=idx;
        remaining=remaining*oldorder(idx);
    end
    newshape{end+1}=remaining;
    newmat=permute(data,neworder);
    newmat=reshape(newmat,newshape{:});
end