% Plots kinematic properties of data from a bimanual Fitts experiment withvariation of 
% either the phase (in-phase/anti-phase) or the viscosity.
% All plotting functionare included in the file. It should work
% with DS structures generated with getMultiResults_fb because it doesn't  
% depend on any parameter of DS structure, only its dimensions.

function  posterplot_LearningMT2(MTR,MTL,MTRu,MTLu)    
    [grp, ss, idl, idr, reps]=size(MTR);    
    hands=2;
    %Fetch all data for bars
    bar_grps = zeros(hands,grp,(idl+1)*idr,ss,2);
    for g=1:grp
        i=0;j=0;
        for r=1:idr
            for l=1:idl        
                i=i+1;
                j=j+1;
                for s=1:ss
                    bar_grps(1,g,i,s,1)=mean(MTL(g,s,l,r,:));
                    bar_grps(1,g,i,s,2)=std(MTL(g,s,l,r,:));       
                    bar_grps(2,g,j,s,1)=mean(MTR(g,s,l,r,:));
                    bar_grps(2,g,j,s,2)=std(MTR(g,s,l,r,:));
                end            
                if l==idl
                    i=i+1;
                    for s=1:ss
                        bar_grps(1,g,i,s,1)=mean(MTLu(g,s,idl,:));
                        bar_grps(1,g,i,s,2)=std(MTLu(g,s,idl,:));
                    end
                end
            end
            j=j+1;
            for s=1:ss
                bar_grps(2,g,j,s,1)=mean(MTRu(g,s,idr,:));
                bar_grps(2,g,j,s,2)=std(MTRu(g,s,idr,:));
            end
        end
    end
    %Plot coupled group bars for MTL
    figure
    for hand=1:hands
        subplottight(2,1,hand)
        for g=1:grp
            %Do the bar-errors plotting
            if g==1
                h = bar(squeeze(bar_grps(hand,g,:,:,1)),'grouped');
                xtmp = fliplr(getBarCentroids(get(get(h(2),'children'),'xdata')));
                for i=1:length(x)
                    n=floor(i/3);
                    xtmp(i)=xtmp(i)+1*n;
                end
                %Replot with new X positions
                h = bar(x,squeeze(bar_grps(hand,g,:,:,1)),'grouped');                
            else
                hold on
                h = bar(fliplr(x{2}),squeeze(bar_grps(hand,g,:,:,1)),'grouped');
            end
            %Set bars appereance: color and width
            set(h,'BarWidth',1/g); 
            colors={[1,0,0],[0.8,0,0],[0.6,0,0];[0,0,0.6],[0,0,0.8],[0,0,1]};
            for i=1:length(h)
                set(h(i),'FaceColor',colors{g,i});
                x{i} = getBarCentroids(get(get(h(i),'children'),'xdata'));
                %errorbar(x,bar_grps(:,i,1),bar_grps(:,i,2),'k', 'linestyle','none', 'linewidth', 0.5);
            end
            %Plot guiding lines and remove useless ticks
            hline([0.5,1],{'k--','k--'})%,{'0.5s','1s'})
            hline(1,'k-')
            set(gca,'YTick',[]);
            set(gca,'XTick',[]);
            if hand==2
                set(gca, 'YDir', 'reverse');
            end
        end
        hold off
    end
end


function subplottight(n,m,i)
    [c,r] = ind2sub([m n], i);
    subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n])
end