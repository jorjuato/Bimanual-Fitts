function [newdata,flabels] = get_posthoc_groups(data,factors)
    %fprop={'grp',2;'ss',3;'idl',2;'idr',3};
    flen=size(data);
    reps=flen(end);
    flabels={};
    
    switch length(factors)
        case 1
            groupno=flen(1);
            newdata=zeros(groupno*reps,2);
            g=0;
            endidx=1;
            for f1=1:flen(1)
                g=g+1;
                flabels{g}=[factors{1},num2str(f1)];
                rng=endidx:endidx+reps-1;
                newdata(rng,2)=g;
                newdata(rng,1)=squeeze(data(f1,:));
                endidx=endidx+reps;
            end
        case 2
            groupno=flen(1)*flen(2);
            newdata=zeros(groupno*reps,2);
            g=0;
            endidx=1;
            for f1=1:flen(1)
                for f2=1:flen(2)
                    g=g+1;
                    flabels{g}=[factors{1},num2str(f1),factors{2},num2str(f2)];
                    rng=endidx:endidx+reps-1;
                    newdata(rng,2)=g;
                    newdata(rng,1)=squeeze(data(f1,f2,:));                    
                    endidx=endidx+reps;
                end
            end
        case 3
            groupno=flen(1)*flen(2)*flen(3);
            newdata=zeros(groupno*reps,2);
            g=0;
            endidx=1;
            for f1=1:flen(1)
                for f2=1:flen(2)
                    for f3=1:flen(3)
                        g=g+1;
                        flabels{g}=[factors{1},num2str(f1),factors{2},num2str(f2),factors{3},num2str(f3)];
                        rng=endidx:endidx+reps-1;
                        newdata(rng,2)=g;
                        newdata(rng,1)=squeeze(data(f1,f2,f3,:));
                        endidx=endidx+reps;
                        
                    end
                end
            end
        case 4
            groupno=flen(1)*flen(2)*flen(3)*flen(4);
            newdata=zeros(groupno*reps,2);
            g=0;
            endidx=1;
            for f1=1:flen(1)
                for f2=1:flen(2)
                    for f3=1:flen(3)
                        for f4=1:flen(4)
                            g=g+1;
                            flabels{g}=[factors{1},num2str(f1),factors{2},num2str(f2),factors{3},num2str(f3),factors{4},num2str(f4)];
                            rng=endidx:endidx+reps-1;
                            newdata(rng,2)=g;
                            newdata(rng,1)=squeeze(data(f1,f2,f3,f4,:));
                            endidx=endidx+reps;
                            
                        end
                    end
                end
            end
    end
end

