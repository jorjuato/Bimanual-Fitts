function plot_phsp(mdl)
    if isempty(mdl.t)
        mdl.run()
    end

    i=mdl.idx;

    %Phase planes
    if mdl.stype==1
        %Phase planes
        figure('name','Phase phane of cosinus ph and phdot');

        plot(mdl.phcos(i),mdl.phdot)
        xlabel('cos(ph)')
        ylabel('phdot')
    else
        %Phase planes cosinus
        figure('name','Phase phane of cosinus ph1 and ph2');
        subplot(2,1,1);
        plot(mdl.phcos(i,1),mdl.phdot(:,2))
        xlabel('cos(ph1)')
        ylabel('ph1dot')

        subplot(2,1,2);
        plot(mdl.phcos(i,2),mdl.phdot(:,2))
        xlabel('cos(ph2)')
        ylabel('ph2dot')
        
        %Phase planes sinus
        figure('name','Phase phane  of sinus ph1 and ph2');
        subplot(2,1,1);
        plot(mdl.phsin(i,1),mdl.phdot(:,2))
        xlabel('sin(ph1)')
        ylabel('ph1dot')

        subplot(2,1,2);
        plot(mdl.phsin(i,2),mdl.phdot(:,2))
        xlabel('sin(ph2)')
        ylabel('ph2dot')   

        %Phase planes sinus-cosinus
        figure('name','Phase phane  of phi1 and phi2');
        subplot(2,1,1);
        plot(mdl.phcos(:,1),mdl.phsin(:,1))
        xlabel('cos(ph1)')
        ylabel('sin(ph1)')

        subplot(2,1,2);
        plot(mdl.phcos(:,2),mdl.phsin(:,2))
        xlabel('cos(ph2)')
        ylabel('ph2dot')
    end
end        