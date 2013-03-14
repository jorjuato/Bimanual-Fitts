function bar_grps = get_bar_groups(bi,un,ds)
    if nargin==2
        bar_grps = get_grouped_bars(bi,un);
    elseif nargin==3
        bar_grps = get_bi_bars(bi,un,ds);
    end
end

function bar_grps = get_bi_bars(bi,un,ds)
    [hno, grp, ss, idl, idr, reps]=size(bi);
    
    %Fetch all data for bars
    bar_grps = zeros(hno,grp+0,idl*idr,ss,2);
    for g=1:(grp+0)
        ord=ds(g).order;
        cnt=0;
        for r=1:idr
            for l=1:idl 
                cnt=cnt+1;
                for h=1:hno
                    if g==3
                        %Unimanual plots added as 3rd group
                        for s=1:ss
                            bar_grps(h,ord,cnt,s,1)=nanmean(un(h,1,s,l,:));
                            bar_grps(h,ord,cnt,s,2)=nanstd(un(h,1,s,l,:));
                        end
                    else                    
                        for s=1:ss
                            bar_grps(h,ord,cnt,s,1)=nanmean(bi(h,g,s,l,r,:));
                            bar_grps(h,ord,cnt,s,2)=nanstd(bi(h,g,s,l,r,:));   
                        end            
                    end
                end
            end
        end
    end
end

function bar_grps = get_grouped_bars(vars,ds)
    [hno, grp, ss, idl, idr, reps]=size(vars{1});
    %Fetch all data for bars
    bar_grps = zeros(length(vars),grp,idl*idr,ss,2);
    for v=1:length(vars)
        data=vars{v};
        for g=1:grp
            ord=ds(g).order;
            cnt=0;
            for r=1:idr
                for l=1:idl     
                    cnt=cnt+1;
                    for s=1:ss
                        bar_grps(v,ord,cnt,s,1)=nanmean(data(1,g,s,l,r,:));
                        bar_grps(v,ord,cnt,s,2)=nanstd(data(1,g,s,l,r,:));
                    end
                end
            end
        end   
    end
end