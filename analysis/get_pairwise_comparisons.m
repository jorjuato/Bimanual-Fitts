function [f1mat,f2mat]=get_pairwise_comparisons(holmmat,data,factors,verbose)
    %Retrieves from holm matrix the crosslevel pairwise comparisons for the two latest
    %factors in the interaction. For interactions with order higher than 2,
    %it stores the comparisons belonging to each level of the remaining factors 
    %in a new dimension of the output matrices f1mat and f2mat.
    if nargin<4, verbose=0; end
    flen=size(data);
    reps=flen(end);
    
    if verbose
        disp(repmat('=',1,80))
    end
    switch length(factors)
        case 1
            if verbose
                disp('Not necessary to do a cross level analysis');
            end
            f1mat=[];
            f2mat=[];
        case 2
            if flen(2)==2
                f1mat=zeros(flen(1),1);                
            else
                f1mat=zeros(flen(1),3);
            end
            if flen(1)==2
                f2mat=zeros(flen(2),1);                
            else
                f2mat=zeros(flen(2),3);
            end
            if verbose
                fprintf('Crosslevel interactions for factors %s vs %s\n',factors{1},factors{2})
            end
            
            for f1=1:flen(1)
                if flen(2)==2
                    f1mat(f1,1)=get_holm(holmmat,[f1,1],[f1,2],flen(1:end-1));
                    if verbose
                        fprintf('1-2=%d\n',f1mat(f1,1)) 
                    end
                else
                    f1mat(f1,1)=get_holm(holmmat,[f1,1],[f1,2],flen(1:end-1));
                    f1mat(f1,2)=get_holm(holmmat,[f1,2],[f1,3],flen(1:end-1));
                    f1mat(f1,3)=get_holm(holmmat,[f1,1],[f1,3],flen(1:end-1));
                    if verbose
                        fprintf('1-2=%d 2-3=%d 1-3=%d\n',f1mat(f1,1),f1mat(f1,2),f1mat(f1,3))
                    end
                end
            end
            if verbose
                fprintf('Crosslevel interactions for factors %s vs %s\n',factors{2},factors{1})
            end
            for f2=1:flen(2)
                if flen(1)==2
                    f2mat(f2,1)=get_holm(holmmat,[1,f2],[2,f2],flen(1:end-1));
                    if verbose
                        fprintf('1-2=%d\n',f2mat(f2,1))
                    end
                else
                    f2mat(f2,1)=get_holm(holmmat,[1,f2],[2,f2],flen(1:end-1));
                    f2mat(f2,2)=get_holm(holmmat,[2,f2],[3,f2],flen(1:end-1));
                    f2mat(f2,3)=get_holm(holmmat,[1,f2],[3,f2],flen(1:end-1));
                    if verbose
                        fprintf('1-2=%d 2-3=%d 1-3=%d\n',f2mat(f2,1),f2mat(f2,2),f2mat(f2,3))
                    end
                end
            end
            
            
        case 3
            if flen(3)==2
                f1mat=zeros(flen(1),flen(2),1);                
            else
                f1mat=zeros(flen(1),flen(2),3);
            end
            
            if flen(2)==2
                f2mat=zeros(flen(1),flen(3),1);                
            else
                f2mat=zeros(flen(1),flen(3),3);
            end
            
            for g1=1:flen(1)
                if verbose
                    fprintf('Crosslevel interactions for factors %s vs %s with factor %s = %d\n',factors{2},factors{3},factors{1},g1)
                end
                for f1=1:flen(2)
                    if flen(3)==2
                        f1mat(g1,f1,1)=get_holm(holmmat,[g1,f1,1],[g1,f1,2],flen(1:end-1));
                        if verbose
                            fprintf('1-2=%d\n',f1mat(g1,f1,1))                        
                        end
                    else
                        f1mat(g1,f1,1)=get_holm(holmmat,[g1,f1,1],[g1,f1,2],flen(1:end-1));
                        f1mat(g1,f1,2)=get_holm(holmmat,[g1,f1,2],[g1,f1,3],flen(1:end-1));
                        f1mat(g1,f1,3)=get_holm(holmmat,[g1,f1,1],[g1,f1,3],flen(1:end-1));
                        if verbose
                            fprintf('1-2=%d 2-3=%d 1-3=%d\n',f1mat(g1,f1,1),f1mat(g1,f1,2),f1mat(g1,f1,3))
                        end
                    end
                end
                if verbose
                    fprintf('Crosslevel interactions for factors %s vs %s with factor %s = %d\n',factors{3},factors{2},factors{1},g1)
                end
                for f2=1:flen(3)
                    if flen(2)==2
                        f2mat(g1,f2,1)=get_holm(holmmat,[g1,1,f2],[g1,2,f2],flen(1:end-1));
                        if verbose
                            fprintf('1-2=%d\n',f2mat(g1,f2,1))
                        end
                    else
                        f2mat(g1,f2,1)=get_holm(holmmat,[g1,1,f2],[g1,2,f2],flen(1:end-1));
                        f2mat(g1,f2,2)=get_holm(holmmat,[g1,2,f2],[g1,3,f2],flen(1:end-1));
                        f2mat(g1,f2,3)=get_holm(holmmat,[g1,1,f2],[g1,3,f2],flen(1:end-1));
                        if verbose
                            fprintf('1-2=%d 2-3=%d 1-3=%d\n',f2mat(g1,f2,1),f2mat(g1,f2,2),f2mat(g1,f2,3))
                        end
                    end
                end
            end
            
        case 4
            if flen(4)==2
                f1mat=zeros(flen(1),flen(2),flen(3),1);                
            else
                f1mat=zeros(flen(1),flen(2),flen(3),3);
            end
            
            if flen(3)==2
                f2mat=zeros(flen(1),flen(2),flen(4),1);              
            else
                f2mat=zeros(flen(1),flen(2),flen(4),3);
            end
            
            for g1=1:flen(1)
                for g2=1:flen(2)
                    if verbose
                        fprintf('Crosslevel interactions for factors %s vs %s with factor %s = %d and factor %s = %d\n',factors{3},factors{4},factors{1},g1,factors{2},g2)
                    end
                    for f1=1:flen(3)
                        if flen(4)==2
                            f1mat(g1,g2,f1,1)=get_holm(holmmat,[g1,g2,f1,1],[g1,g2,f1,2],flen(1:end-1));
                            if verbose
                                fprintf('1-2=%d\n',f1mat(g1,g2,f1,1))
                            end
                        else
                            f1mat(g1,g2,f1,1)=get_holm(holmmat,[g1,g2,f1,1],[g1,g2,f1,2],flen(1:end-1));
                            f1mat(g1,g2,f1,2)=get_holm(holmmat,[g1,g2,f1,2],[g1,g2,f1,3],flen(1:end-1));
                            f1mat(g1,g2,f1,3)=get_holm(holmmat,[g1,g2,f1,1],[g1,g2,f1,3],flen(1:end-1));
                            if verbose
                                fprintf('1-2=%d 2-3=%d 1-3=%d\n',f1mat(g1,g2,f1,1),f1mat(g1,g2,f1,2),f1mat(g1,g2,f1,3))
                            end
                        end
                    end
                    if verbose
                        fprintf('Crosslevel interactions for factors %s vs %s with factor %s = %d and factor %s = %d\n',factors{4},factors{3},factors{1},g1,factors{2},g2)
                    end
                    for f2=1:flen(4)
                        if flen(3)==2
                            f2mat(g1,g2,f2,1)=get_holm(holmmat,[g1,g2,1,f2],[g1,g2,2,f2],flen(1:end-1));
                            if verbose
                                fprintf('1-2=%d\n',f2mat(g1,g2,f2,1))
                            end
                        else
                            f2mat(g1,g2,f2,1)=get_holm(holmmat,[g1,g2,1,f2],[g1,g2,2,f2],flen(1:end-1));
                            f2mat(g1,g2,f2,2)=get_holm(holmmat,[g1,g2,2,f2],[g1,g2,3,f2],flen(1:end-1));
                            f2mat(g1,g2,f2,3)=get_holm(holmmat,[g1,g2,1,f2],[g1,g2,3,f2],flen(1:end-1));
                            if verbose
                                fprintf('1-2=%d 2-3=%d 1-3=%d\n',f2mat(g1,g2,f2,1),f2mat(g1,g2,f2,2),f2mat(g1,g2,f2,3))
                            end
                        end
                    end
                end
            end
            
    end
    if verbose
        disp(repmat('=',1,80))
    end
end
function hval = get_holm(holmmat,p1,p2,flen)
    %Another triky code, it maps the all2all pairs matrix
    %holm with a factor levels based index space.
   switch length(flen)
       case 2
            c1=(p1(1)-1)*flen(2)+p1(2);
            c2=(p2(1)-1)*flen(2)+p2(2);
        
       case 3
            c1=(p1(1)-1)*flen(2)*flen(3)+(p1(2)-1)*flen(3)+p1(3);
            c2=(p2(1)-1)*flen(2)*flen(3)+(p2(2)-1)*flen(3)+p2(3);
       case 4
            c1=(p1(1)-1)*flen(2)*flen(3)*flen(4)+(p1(2)-1)*flen(3)*flen(4)+(p1(3)-1)*flen(4)+p1(4);
            c2=(p2(1)-1)*flen(2)*flen(3)*flen(4)+(p2(2)-1)*flen(3)*flen(4)+(p2(3)-1)*flen(4)+p2(4);
   end
   hval=holmmat(c1,c2);
end