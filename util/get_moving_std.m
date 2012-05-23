function mov_std=get_moving_std(x,win,overlap)
    
    
    intervals=1:win-overlap:length(x)-win;
    %mov_std=zeros(round(x/(win-overlap)),1);
    mov_std=zeros(size(intervals));    
    for i=1:length(intervals)
        idx=intervals(i);
        mov_std(i)=std(x(idx:idx+win));
    end