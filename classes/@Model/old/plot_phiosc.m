function plot_phiosc(out_phi,omegas)

    %Create all figures and subplots
    
    %Temporal trajectories of phases
    fig_phtray=figure('name','Temporal Trayectories of phi1 and phi2');
    axtrj1=subplot(2,1,1); hold on;
    ylabel('cos(phi1)')
    xlabel('time')
    axtrj2=subplot(2,1,2); hold on;
    ylabel('cos(phi2)')
    xlabel('time')
    
    %Temporal trajectories of phase first derivative
    fig_phdottray=figure('name','Temporal Trayectories of phidot1 and phidot2');
    axtrjdot1=subplot(2,1,1); hold on;
    ylabel('phidot1')
    xlabel('time')
    axtrjdot2=subplot(2,1,2); hold on;
    ylabel('phidot2')
    xlabel('time')
    
    %Phase spaces
    fig_phspace=figure('name','Phase space and cosinus phase space');
    axphspace1=subplot(2,2,1); hold on;
    ylabel('phidot1')
    xlabel('phi1')
    axphspace2=subplot(2,2,3); hold on;
    ylabel('phidot2')
    xlabel('phi2')    
    axphspacecos1=subplot(2,2,2); hold on;
    xlabel('cos(phi1)')
    ylabel('phidot1')
    axphspacecos2=subplot(2,2,4); hold on;
    xlabel('cos(phi2)')
    ylabel('phidot2')

   
    %Iterate over all simulations and overlap plots
    for i=1:length(out_phi)
        color1=[1,1,1/sqrt(i)];
        color2=[1/sqrt(i),1,1];
        out=out_phi{i};
        phi1=out(:,1);
        phi2=out(:,2);
        t=out(:,3);
        phidot1=diff(phi1)./diff(t);
        phidot2=diff(phi2)./diff(t);        
        idx=2:length(t); 
        
        %Plot trayectories
        scatter(axtrj1,t,cos(phi1),'.','MarkerFaceColor',color1); hold on;
        scatter(axtrj2,t,cos(phi2),'.','MarkerFaceColor',color2); hold on;
        scatter(axtrjdot1,t(idx),phidot1,'.','MarkerFaceColor',color1); hold on;
        scatter(axtrjdot2,t(idx),phidot2,'.','MarkerFaceColor',color2); hold on;
        
        %Plot phase space 
        scatter(axphspace1,phi1(idx),phidot1,'.','MarkerFaceColor',color1); hold on
        scatter(axphspace2,phi2(idx),phidot2,'.','MarkerFaceColor',color2); hold on        
        scatter(axphspacecos1,cos(phi1(idx)),phidot1,'.','MarkerFaceColor',color1);hold on
        scatter(axphspacecos2,cos(phi2(idx)),phidot2,'.','MarkerFaceColor',color2);hold on
    end
    
    %Legend related stuff
    legtxts={size(omegas)};
    for i=1:length(omegas)
        legtxts{i}=['\omega=' num2str(omegas(i))];
    end
    legend(axtrj1,legtxts);
    legend(axtrj2,legtxts);
    legend(axtrjdot1,legtxts);
    legend(axtrjdot2,legtxts);    
    legend(axphspace1,legtxts);
    legend(axphspace2,legtxts);
    legend(axphspacecos1,legtxts);
    legend(axphspacecos2,legtxts);
end