function phD = getPhaseDiff(Lph,Rph,freqQ)
    phD = Lph.*freqQ-Rph;
    %Method 1
    %phD = rem(Lph - Rph,2*pi);
    %if idx == 1
    %    phD = abs(phD-pi)-pi;
    %    phD = abs(phD+pi)-pi;
    %    phD = abs(phD-pi)-pi;
    %else
    %    phD = abs(phD);
    %end
    %Method 2
    % phD = Lph-Rph;
    % phD = abs(mod(Lph - Rph,2*pi)-pi);
    % if idx2 == 1
    %     phD = rem(Lph - Rph,2*pi);
    %     phD = abs(phD-pi)-pi;
    %     phD = abs(phD-pi)-pi;
    % else
    %     phD = rem(Lph - Rph,pi);
    %     phD = abs(phD-pi/2)-pi/2;
    %     phD = abs(phD-pi/2)-pi/2;
    % end
end