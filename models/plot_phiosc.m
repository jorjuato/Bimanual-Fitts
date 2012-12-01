function plot_phiosc(out_phi,omegas)

    %Create all figures and subplots
    fig_tray=figure;
    set(fig_tray,'name','Temporal Trayectories of phi1 and phi2');
    axtray1=subplot(1,2,1); hold on;
    ylabel('phi1 and phi2')
    xlabel('time')
    axtray2=subplot(1,2,2); hold on;
    xlabel('time')
    
    fig_phspace=figure;
    set(fig_phspace,'name','Phase space and cosinus phase space');
    axphspace=subplot(1,3,1); hold on;
    ylabel('phi2')
    xlabel('phi1')
    axphspacecos=subplot(1,3,2); hold on;
    ylabel('cos(phi2)')
    xlabel('cos(phi1)')
    axphspacediff=subplot(1,3,3); hold on;
    ylabel('freq2)')
    xlabel('freq1)')
    
    fig_xxdot=figure;
    set(fig_xxdot,'name','Phase vs Frequency plots for phi1 and phi2');
    ax_xx1=subplot(1,2,1); hold on
    ylabel('freq1')
    xlabel('phi1')
    ax_xx2=subplot(1,2,2); hold on
    ylabel('freq2')
    xlabel('phi2')   
    
    %Iterate over all simulations and overlap plots
    for i=1:length(out_phi)
        col1=[1,1,1/sqrt(i)];
        col2=[1/sqrt(i),1,1];
        out=out_phi{i};
        phi1=out(:,1);
        phi2=out(:,2);
        t=out(:,3);
        %Plot trayectories
        scatter(axtray1,t,cos(phi1),'.','MarkerFaceColor',col1); hold on;
        scatter(axtray2,t,cos(phi2),'.','MarkerFaceColor',col2);
        %Plot phase space 
        scatter(axphspace,phi1,phi2,'.','MarkerFaceColor',col1); hold on
        scatter(axphspacecos,cos(phi1),cos(phi2),'.','MarkerFaceColor',col2);
        scatter(axphspacediff,diff(phi1)./t(1:end-1),diff(phi2)./t(1:end-1),'.','MarkerFaceColor',col2);
        %Plot phase vs frequency
        scatter(ax_xx1,phi1(2:end),diff(phi1)./t(1:end-1),'.','MarkerFaceColor',col1); hold on
        scatter(ax_xx2,phi2(2:end),diff(phi2)./t(1:end-1),'.','MarkerFaceColor',col2);
    end
    
    %Legend related stuff
    legtxts={size(omegas)};
    for i=1:length(omegas)
        legtxts{i}=['\omega=' num2str(omegas(i))];
    end
    legend(axtray1,legtxts);
    legend(axtray2,legtxts);
    legend(axphspace,legtxts);
    legend(axphspacecos,legtxts);
    legend(axphspacediff,legtxts);
    legend(ax_xx1,legtxts);
    legend(ax_xx2,legtxts);
        
