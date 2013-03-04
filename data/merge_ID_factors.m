function data = merge_ID_factors(bidata,mode)
    if nargin==1, mode='3levels'; end
    if nargin==0, error('Need data to merge!!'); end
    
    llevels=[1,3];
    if strcmp(mode,'3levels')
        deltaID=[0,1,2];
    elseif strcmp(mode,'6levels')
        deltaID=-2:2;
    end
    [vno, hno, pp, ss, idl, idr, reps]=size(bidata);
    
    if pp==2
        error('Need participant based data!');
    end
    
    switch mode
        case '3levels'
            data=zeros(vno,hno, pp, ss, length(deltaID), reps);
            for v=1:vno
                for h=1:hno
                    for p=1:pp
                        for s=1:ss
                            for l=1:idl
                                for r=1:idr
                                    did=abs(r-llevels(l));
                                    i=find(deltaID==did);                                    
                                    data(v,h,p,s,i,:)=squeeze(bidata(v,h,p,s,l,r,:));
                                end
                            end
                        end
                    end
                end
            end        
        case '6levels'
            data=zeros(vno,hno, pp, ss, length(deltaID), reps);
            for v=1:vno
                for h=1:hno
                    for p=1:pp
                        for s=1:ss
                            for l=1:idl
                                for r=1:idr
                                    did=r-llevels(l);
                                    if did==0 && r==3
                                        did=3;
                                    end
                                    i=find(deltaID==did);                                    
                                    data(v,h,p,s,i,:)=squeeze(bidata(v,h,p,s,l,r,:));
                                end
                            end
                        end
                    end
                end
            end
        case 'subsample'
            data=zeros(vno,hno, pp, ss, length(deltaID), reps);
            for v=1:vno
                for h=1:hno
                    for p=1:pp
                        for s=1:ss
                            flag=0;
                            for l=1:idl
                                for r=1:idr
                                    did=r-llevels(l);
                                    i=find(deltaID==did);
                                    if i==0 && flag==0
                                        flag=1; %Whe are on first round 
                                        %Select 3 different trials out of 6
                                        sel_idx=randi([1,6],1,3);
                                        while length(unique(sel_idx))<3
                                            sel_idx=randi([1,6],1,3);
                                        end
                                        %Now save in data those smaller
                                        %than 4 (present in the first round)
                                        sel=sel_idx(sel_idx<4);
                                        for idx=1:length(sel)
                                            data(v,h,p,s,i,idx)=bidata(v,h,p,s,l,r,sel(idx));
                                        end
                                    elseif i==0 && flag==1
                                        %We are on second round
                                        %Save in data those bigger than 3                                         
                                        sel=sel_idx(sel_idx>3)-3;
                                        offset=3-lenght(sel);                                        
                                        for idx=1:length(sel)
                                            data(v,h,p,s,i,offset+idx)=bidata(v,h,p,s,l,r,sel(idx));
                                        end
                                    else
                                        %For all the other, just save 3 reps
                                        data(v,h,p,s,i,:)=squeeze(bidata(v,h,p,s,l,r,:));
                                    end
                                end
                            end
                        end
                    end
                end
            end
        case 'average'
            data=zeros(vno,hno, pp, ss, length(deltaID));
            for v=1:vno
                for h=1:hno
                    for p=1:pp
                        for s=1:ss
                            for l=1:idl
                                for r=1:idr
                                    did=r-llevels(l);
                                    i=find(deltaID==did);
                                    if i==0, continue; end % we deal with it later
                                    data(v,h,p,s,i)=mean(bidata(v,h,p,s,l,r,:));
                                end
                            end
                            data(v,h,p,s,3)=mean(cat(2,squeeze(bidata(v,h,p,s,1,1,:))',...
                                                       squeeze(bidata(v,h,p,s,2,3,:))'));
                        end
                    end
                end
            end
        case 'all'
            data=zeros(vno,hno, pp, ss, length(deltaID), reps*2)*NaN;
            for v=1:vno
                for h=1:hno
                    for p=1:pp
                        for s=1:ss
                            flag=0;
                            for l=1:idl
                                for r=1:idr
                                    did=r-llevels(l);
                                    i=find(deltaID==did);
                                    if i==0 
                                        if flag==0
                                            flag=1; %Whe are on first round 
                                            data(v,h,p,s,i,1:3)=squeeze(bidata(v,h,p,s,l,r,:));
                                        else
                                            data(v,h,p,s,i,4:6)=squeeze(bidata(v,h,p,s,l,r,:));
                                        end
                                    else
                                        data(v,h,p,s,i,1:3)=squeeze(bidata(v,h,p,s,l,r,:));
                                    end
                                end
                            end
                        end
                    end
                end
            end
    end
end