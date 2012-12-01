function [H, badguys] = get_harm(x,a,pgb)
    if nargin<3, pgb=1; end
    xc=crossings(x);
    H=[0];
    badguys={};
    for i=1:length(xc)-1
        if x(xc(i)+100)<0
            [Ht,bg]=get_Harmonicity(x,a,xc(i):xc(i+1));
            H(end+1)=Ht;
            if ~isempty(bg)
                badguys{end+1}=bg{:};
            end
        end
    end
    if pgb && ~isempty(badguys)
        figure;
        plot(x,'b');
        hold on
        plot(a,'r');
        for bg=1:length(badguys)
            g=badguys{bg};
            vline(g(1),'k-')
            vline(g(2),'k--')
        end
    end
    
end