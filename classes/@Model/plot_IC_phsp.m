function plot_IC_phsp(mdl,no)    
    if isempty(mdl.icset)
        error('You have to run at least one IC simulation')    
    elseif nargin<2 || no==0
        icset=mdl.icset{end};
    elseif no>0 && no<=length(mdl.icset)
        icset=mdl.icset{no};
    else
        error('Invalid number of simulation!')
    end

    %Plot in 2D-plane
    rr=length(icset);
    figure; 
    ax2d=subplot(1,1,1); 
    hold 'on';    
    for r=1:rr
        d=icset{end}{r};
        if mdl.stype<2
            PH=d.phmod(:,1);            
            PHd=abs(d.phdot);
            scatter(ax2d,PH,PHd,'.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
        else
            PH1=d.phmod(:,1);
            PH2=d.phmod(:,2);
            scatter(ax2d,PH1,PH2,'.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
        end
    end
end
