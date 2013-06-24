function plot_single_phsp(mdl)
    if isempty(mdl.t)
        mdl.run()
    end

    %Phase planes
    if mdl.stype<2
        %Phase planes on angular variables (ph,phdot)
        figure('name','Phase phane of angular and cartesian variables');
        subplot(1,2,1);hold on;
        title('Angular phase plane');
        scatter(mdl.ph_phhist,abs(mdl.omega_hist),'.')        
        qz=zeros(length(mdl.vf{1}),1)';
        quiver(mdl.vf{1},qz,mdl.vf{2},qz)
        xlabel('ph')
        ylabel('phdot')
        xlim([-pi,pi])
        ylim([-1 -min(mdl.phdot)])
        hline(0,'k');
        
        %Phase planes on cartesian coordinates (x,v)
        subplot(1,2,2);
        title('Cartesian phase plane');
        scatter(mdl.phcos,mdl.phcosdot,'.')
        xlabel('position')
        ylabel('velocity')
        xlim([-1,1]);
        hline(0,'k');
        vline(0,'k');
    else
        %Phase planes on angular variables (ph,phdot)
        figure('name','Phase phane of cosinus ph1 and ph2');
        subplot(2,1,1);
        scatter(mdl.phmod(:,1),abs(mdl.phdot(:,1)),'.')
        xlabel('ph1')
        ylabel('ph1dot')
        xlim([-pi,pi])
        ylim([-1 -min(mdl.phdot(:,1))])

        subplot(2,1,2);
        scatter(mdl.ph(:,2),abs(mdl.phdot(:,2)),'.')
        xlabel('ph2')
        ylabel('ph2dot')
        xlim([-pi,pi])
        ylim([-1 -min(mdl.phdot(:,2))])

        %Phase planes on cartesian coordinates (x,v)
        figure('name','Phase phanes  of (x1,v1) and (x2,v2)');
        subplot(2,2,1);
        scatter(mdl.phcos(:,1),mdl.phcosdot(:,1),'.')
        xlabel('Left position')
        ylabel('Left velocity')

        subplot(2,2,2);
        scatter(mdl.phcos(:,2),mdl.phcosdot(:,2),'.')
        xlabel('Right position')
        ylabel('Right velocity')
        
        %Normalized Phase planes on cartesian coordinates (x,v)
        %figure('name','Normalized phase phane  of (x1,v1) and (x2,v2)');
        subplot(2,2,3);
        scatter(mdl.phcos(:,1),mdl.phcosdot(:,1)/max(abs(mdl.phcosdot(:,1))),'.')
        xlabel('Left position')
        ylabel('Left velocity')
        xlim([-1,1]);
        ylim([-1,1]);

        subplot(2,2,4);
        scatter(mdl.phcos(:,2),mdl.phcosdot(:,2)/max(abs(mdl.phcosdot(:,2))),'.')
        xlabel('Right position')
        ylabel('Right velocity')
        xlim([-1,1]);
        ylim([-1,1]);
    end
end        