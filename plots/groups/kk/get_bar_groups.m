function bar_grps = get_bar_groups(bi,un,factors)
    if nargin==1
        factors = {'idl','idr','grp'};
        do_relative=0;
    elseif nargin==2
        factors=un;
        do_relative=0;
    elseif nargin==3
        do_relative=1;
        if any(un==0)
            disp('There are zeros in data!!!')
        end
    end
    
    %Diferenciate bimanual/unimanual variables
    if length(size(bi))==5
        [grp, ss, idl, idr, reps]=size(bi);
        two_hands=0;
        if do_relative
            error('Cannot do relative plots for bimanual variables')
        end
    else
        [hno, grp, ss, idl, idr, reps]=size(bi);
        two_hands=1;
    end

    %Compute ranges of factors
    franges=zeros(1,length(factors));
    for i=1:length(factors)
        if strcmp(factors{i},'grp')
            franges(i)=grp;
        elseif strcmp(factors{i},'idl')
            franges(i)=idl;
        elseif strcmp(factors{i},'idr')
            franges(i)=idr;
        end
    end

    %Allocate data matrices depending on handedness
    if two_hands
        bar_grps = zeros(hno,franges(1),franges(2),franges(3),ss,2);
    else
        bar_grps = zeros(franges(1),franges(2),franges(3),ss,2);
    end
    
    %Fetch data
    for f1=1:franges(1)
        for f2=1:franges(2)
            for f3=1:franges(3)
                [g,r,l]=get_indexes([f1,f2,f3],factors);
                if two_hands
                    for h=1:hno                 
                        for s=1:ss
                            if do_relative
                                if h==1 %left hand
                                    unirep=squeeze(un(h,g,s,l,:));
                                    birep=squeeze(bi(h,g,s,l,r,:));
                                    if any(unirep==0), continue; end
                                    relmean=nanmean(birep./unirep);
                                    relste=nanste(birep./unirep);
                                else
                                    unirep=squeeze(un(h,g,s,r,:));
                                    birep=squeeze(bi(h,g,s,l,r,:));
                                    if any(unirep==0), continue; end
                                    relmean=nanmean(birep./unirep);
                                    relste=nanste(birep./unirep);
                                end
                                bar_grps(h,f1,f2,f3,s,1)=relmean;
                                bar_grps(h,f1,f2,f3,s,2)=relste;
                                
                            else
                                bar_grps(h,f1,f2,f3,s,1)=nanmean(squeeze(bi(h,g,s,l,r,:)));
                                bar_grps(h,f1,f2,f3,s,2)=nanste(squeeze(bi(h,g,s,l,r,:)));
                            end
                        end
                    end
                else
                    for s=1:ss
                        bar_grps(f1,f2,f3,s,1)=nanmean(squeeze(bi(g,s,l,r,:)));
                        bar_grps(f1,f2,f3,s,2)=nanste(squeeze(bi(g,s,l,r,:)));
                    end
                end
            end
        end
    end
end

function [g,r,l] = get_indexes(fvals,factors)
    for i=1:length(factors)
        if strcmp(factors{i},'grp')
            g=fvals(i);
        elseif strcmp(factors{i},'idl')
            l=fvals(i);
        elseif strcmp(factors{i},'idr')
            r=fvals(i);
        end
    end
end
    