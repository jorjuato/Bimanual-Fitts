function plot(obj,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname=[];end
    if nargin<2, graphPath=[];end

    if ischar(graphPath)
        fig = figure('visible','off');
    elseif ~iscell(graphPath)
        fig = figure();
    end
    hold on
    plot(obj.freqs,obj.LPxx,'r');
    plot(obj.freqs,obj.RPxx_t,'b');
    plot(obj.freqs,obj.RPxx,'g');
    xlim([0,10]);
    text(4,5.5,strcat('Freq locking strength PC=',num2str(obj.flsPC)));
    text(4,5.0,strcat('Freq locking strength Amp=',num2str(obj.flsAmp)));
    text(4,4.5,strcat('Phase locking std=',num2str(obj.phDiffStd)));
    text(4,4.0,strcat('Freq ratio after rescaling=',num2str(obj.p/obj.q)));
    text(4,3.5,strcat('Freq ratio before rescaling=',num2str(obj.rho)));
    hold off;
    disp(obj);
    if ischar(graphPath)
        %Generate random sequence and append to the end (based on seconds or whatever)
        filename = 'LockingStrength';
        figname = joinpath(joinpath(graphPath,rootname),filename);
        saveas(fig,figname,ext);
        close(fig);
    end
end