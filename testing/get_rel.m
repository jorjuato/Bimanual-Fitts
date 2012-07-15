function data=get_rel(bidata,udata)
    %Define or get some globals
    global ppbygrp;
    
    eps=0.05;
    [h, pp, ss, idl, idr, reps]=size(bidata); 
    if min(bidata(:))>=eps && (1-max(bidata(:)))<=eps
        is_sigmoid=1;
    else
        is_sigmoid=0;
    end
    data = zeros(h,idl,idr,pp*ss,reps);
    %size(data)
    for l=1:idl
        for r=1:idr
            %all data for a certain IDL;IDL is part of the same series
            cnt=0;
            for p=ppbygrp                
                for s=1:ss
                    cnt=cnt+1;
                    if sum(squeeze(udata(1,p,s,l,:)))==0
                        'left...'
                        l
                        s
                        p
                        squeeze(udata(1,p,s,l,:))
                        '...'
                    elseif sum(squeeze(udata(2,p,s,r,:)))==0
                        'right...'
                        r
                        s
                        p
                        squeeze(udata(2,p,s,r,:))
                        '...'
                    end
                    if is_sigmoid
                        data(1,l,r,cnt,1:3)=squeeze(bidata(1,p,s,l,r,:))-squeeze(udata(1,p,s,l,:));
                        data(2,l,r,cnt,1:3)=squeeze(bidata(2,p,s,l,r,:))-squeeze(udata(2,p,s,r,:)); 
                    else
                        data(1,l,r,cnt,1:3)=squeeze(bidata(1,p,s,l,r,:)).\squeeze(udata(1,p,s,l,:));
                        data(2,l,r,cnt,1:3)=squeeze(bidata(2,p,s,l,r,:)).\squeeze(udata(2,p,s,r,:));
                    end                    
                end
            end
        end
    end
end

% 
% function data=get_rel(bidata,udata,ppbygrp)
%     [h, pp, ss, idl, idr, reps]=size(bidata); 
%     %??? pp*ss only!
%     %data = zeros(h,idl,idr,pp*ss*idl*idr,reps);
%     if min(bidata(:))==0 && max(bidata(:))==1
%         is_sigmoid=1;
%     else
%         is_sigmoid=0;
%     end
%     data = zeros(h,idl,idr,pp*ss,reps);
%     for l=1:idl
%         for r=1:idr
%             %all data for a certain IDL;IDL is part of the same series
%             cnt=0;
%             for p=ppbygrp                
%                 for s=1:ss
%                     cnt=cnt+1;
%                     if is_sigmoid
%                         data(1,l,r,cnt,1:3)=squeeze(bidata(1,p,s,l,r,:))'-nanmedian(squeeze(udata(1,p,s,l,:)));
%                         data(2,l,r,cnt,1:3)=squeeze(bidata(2,p,s,l,r,:))'-nanmedian(squeeze(udata(2,p,s,r,:))); 
%                     else
%                         data(1,l,r,cnt,1:3)=squeeze(bidata(1,p,s,l,r,:))'\nanmedian(squeeze(udata(1,p,s,l,:)));
%                         data(2,l,r,cnt,1:3)=squeeze(bidata(2,p,s,l,r,:))'\nanmedian(squeeze(udata(2,p,s,r,:)));
%                     end
% %                     data(1,l,r,cnt,isnan(data(1,l,r,cnt,:)))=0;
% %                     data(2,l,r,cnt,isnan(data(2,l,r,cnt,:)))=0;
% %                     data(1,l,r,cnt,isinf(data(1,l,r,cnt,:)))=0;
% %                     data(2,l,r,cnt,isinf(data(2,l,r,cnt,:)))=0;
%                     
%                 end
%             end
%         end
%     end
% end