function [out,outhist] = windowsignal(in,window,overlap,n)
    do_plot=1;
    insize=length(in);
    advance=round(window*(1-overlap));
    reps=round((insize-window+advance)/advance)-1;
    out=zeros(reps,window);
    outhist=zeros(reps,n);
    centers=linspace(min(in),max(in),n);
    for i=1:reps
        idx=1+advance*(i-1);
        %[insize,advance,reps, i,idx,idx+window-1]
        out(i,:)=in(idx:idx+window-1);
        ne=hist(out(i,:),centers);
        outhist(i,:)=ne;
    end
    if do_plot
        figure();
        %surf(outhist);
        imagesc(outhist);
        %centers
    end
end