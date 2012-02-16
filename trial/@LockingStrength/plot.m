function plot(obj)
    %Check everything goes as expected
    %[p, q, ~, ~] = ls.get_locking_ratio(obj.LPxx,obj.RPxx_t,obj.peak_delta);
    figure; hold on
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
end