function plot_shit(pp,vname,hand,l,r)
    if nargin<3, hand=''; end
        
    legends={};
    figure;
    hold on; 
    xstr='ph_hist';
    vstr=[vname,'_hist'];
    
    if nargin==4
        if strcmp(hand,'uniL') || strcmp(hand,'L')
            for i=1:3;
                for rep=1:3;
                    tr=pp(i).uniLeft{l,rep};
                    scatter(tr.ts.(xstr),tr.ts.(vstr),'.');
                    legends{end+1}=sprintf('S=%d L=%d rep=%d',i,l,rep);
                end
            end
        else
            for i=1:3;
                for rep=1:3;
                    tr=pp(i).uniRight{l,rep};
                    scatter(tr.ts.(xstr),tr.ts.(vstr),'.');
                    legends{end+1}=sprintf('S=%d R=%d rep=%d',i,l,rep);
                end
            end
        end        
    elseif nargin==5
        vstr=[hand,vname,'_hist'];
        xstr=[hand,xstr];
        for i=1:3;
            for rep=1:3;
                tr=pp(i).bimanual{l,r,rep};
                scatter(tr.ts.(xstr),tr.ts.(vstr),'.');
                legends{end+1}=sprintf('S=%d L=%d R=%d rep=%d',i,l,r,rep);
            end
        end
    else
        rep=1;
        if isempty(hand)
            vstr=[vname,'_hist'];        
            for i=1:3;
                for r=1:3;
                    %for rep=1:3;
                        tr=pp(i).uniRight{r,rep};
                        scatter(tr.ts.(xstr),tr.ts.(vstr),'.');
                        legends{end+1}=sprintf('S=%d R=%d rep=%d',i,r,rep);
                    %end
                end
            end
        else
            vstr=[hand,vname,'_hist'];
            xstr=[hand,xstr];        
            for i=1:3;
                for l=1:2;
                    for r=1:3;
                        %for rep=1:3; 
                            tr=pp(i).bimanual{l,r,rep};
                            scatter(tr.ts.(xstr),tr.ts.(vstr),'.');
                            legends{end+1}=sprintf('S=%d L=%d R=%d rep=%d',i,l,r,rep); 
                        %end
                    end
                end
            end
        end
    end
    legend(legends);
    xlim([-pi,pi]);
end

%legends={};figure; hold; for i=1:3;for l=1:2;for r=1:3;for rep=1:3; tr=p1(i).bimanual{l,r,rep};scatter(tr.ts.Lph_hist,tr.ts.Lxnorm_hist);legends{end+1}=sprintf('S=%d L=%d R=%d rep=%d',i,l,r,rep); end;end;end;end; legend(legends)