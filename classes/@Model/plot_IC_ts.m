function plot_IC_ts(mdl,no)
    if isempty(mdl.icset)
        error('You have to run at least one IC simulation')    
    elseif nargin<2 || no==0
        icset=mdl.icset{end};
    elseif no>0 && no<=length(mdl.icset)
        icset=mdl.icset{no};
    else
        error('Invalid number of simulation!')
    end

    figure;
    if mdl.stype<2
        ax1=subplot(3,1,1); hold on; ylabel('position');title('position');grid on
        ax2=subplot(3,1,2); hold on; ylabel('velocity');title('velocity');grid on
        ax3=subplot(3,1,3); hold on; ylabel('omega');title('omega');grid on
    else
        ax1=subplot(3,2,1); hold on;ylabel('position1');title('position1');grid on
        ax2=subplot(3,2,2); hold on;ylabel('velocity1');title('velocity1');grid on
        ax3=subplot(3,2,3); hold on;ylabel('omega1');title('omega1');grid on
        ax4=subplot(3,2,4); hold on;ylabel('position2');title('position2');grid on
        ax5=subplot(3,2,5); hold on;ylabel('velocity2');title('velocity2');grid on
        ax6=subplot(3,2,6); hold on;ylabel('omega2');title('omega2');grid on
    end

    %Plot in 2D-plane
    rr=length(icset);
    for r=1:rr
        d=icset{end}{r};
        if mdl.stype<2
            scatter(ax1, d.t,  d.phcos,       '.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
            scatter(ax2, d.t,  d.phcosdot,    '.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
            scatter(ax3, d.t,  abs(d.phdot),  '.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
        else
            scatter(ax1, d.t,  d.phcos(:,1),     '.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
            scatter(ax2, d.t, d.phcosdot(:,1),  '.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
            scatter(ax3, d.t, abs(d.phdot(:,1)),'.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
            scatter(ax4, d.t,  d.phcos(:,2),     '.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
            scatter(ax5, d.t, d.phcosdot(:,2),  '.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
            scatter(ax6, d.t, abs(d.phdot(:,2)),     '.','MarkerFaceColor',[1/sqrt(r),1,1/sqrt(r)]);
        end
    end
end
