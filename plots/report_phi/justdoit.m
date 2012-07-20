function justdoit(xp,plots,pps)
    if nargin<3, pps=[1,5,6,8]; end
    if nargin<2, plots=[6]; end
    if nargin<1, xp=Experiment(); end

    for p=pps
        pp=xp(p);
%         if any(plots==1)
%             plot_participant_peakDelays3D(pp,['minPeakDelay_pp' num2str(p)]);
%         end
        for s=[1,3]
%             if any(plots==2)
%                 rootname=['windowedPSD_p' num2str(p) '_s' num2str(s) '_tr'];
%                 plot_specgram_phi(pp(s).bimanual{1,1,1},30,29/30,1,[rootname 'DD']);
%                 plot_specgram_phi(pp(s).bimanual{1,3,1},30,29/30,1,[rootname 'DE']);
%                 plot_specgram_phi(pp(s).bimanual{2,2,1},30,29/30,1,[rootname 'EM']);
%                 plot_specgram_phi(pp(s).bimanual{2,3,1},30,29/30,1,[rootname 'EE']);
%             end
%             if any(plots==3)
%                 rootname=['instOmega_p' num2str(p) '_s' num2str(s) '_tr'];
%                 plot_omega_phi(pp(s).bimanual{1,1,2},[rootname 'DD']);
%                 plot_omega_phi(pp(s).bimanual{1,2,3},[rootname 'DE']);
%                 plot_omega_phi(pp(s).bimanual{2,2,2},[rootname 'EM']);
%                 plot_omega_phi(pp(s).bimanual{2,3,2},[rootname 'EE']);
%             end
%             if any(plots==4)
%                 rootname=['MT_Freq_p' num2str(p) '_s' num2str(s) '_tr'];
%                 plot_mt_phi(pp(s).bimanual{1,1,2},[rootname 'DD']);
%                 plot_mt_phi(pp(s).bimanual{1,2,3},[rootname 'DE']);
%                 plot_mt_phi(pp(s).bimanual{2,2,2},[rootname 'EM']);
%                 plot_mt_phi(pp(s).bimanual{2,3,2},[rootname 'EE']);
%             end
%             if any(plots==5)
%                 rootname=['Distances_p' num2str(p) '_s' num2str(s) '_tr'];
%                 plot_distances(pp(s).bimanual{1,1,2},[rootname 'DD']);
%                 plot_distances(pp(s).bimanual{1,2,3},[rootname 'DE']);
%                 plot_distances(pp(s).bimanual{2,2,2},[rootname 'EM']);
%                 plot_distances(pp(s).bimanual{2,3,2},[rootname 'EE']);
%             end
            if any(plots==6)
                rootname=['AlphaOmega_p' num2str(p) '_s' num2str(s) '_tr'];
                plot_alpha_omega(pp(s).bimanual{1,1,2},[rootname 'DD']);
                plot_alpha_omega(pp(s).bimanual{1,2,3},[rootname 'DE']);
                plot_alpha_omega(pp(s).bimanual{2,2,2},[rootname 'EM']);
                plot_alpha_omega(pp(s).bimanual{2,3,2},[rootname 'EE']);
            end
        end
    end
end