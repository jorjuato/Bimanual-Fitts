function [fields, xlabels, ylabels] = get_plotted_properties(obj)
    fields = {...
        'time_series'...
        ,'phase_plane'...
        ,'hook_plane'...
        }; %names=names{idx};

    ylabels = {...
        'Position/Speed(m;m/s)'...
        ,'Speed(m/s)'...
        ,'Accel (m/s^2)'...
        }; %ylabels=ylabels{idx};

    xlabels = {...
        'Time (ms)'...
        ,'Position (m)'...
        ,'Position (m)'...
        }; %xlabels=xlabels{idx};
end
    %properties
        %freqs
        %Lf
        %Rf
        %Rph
        %Lph
        %LPxx
        %LPxx_t
        %RPxx
        %RPxx_t
        %p
        %q
        %peak_delta=3;
    %end % properties
    
    %properties (Dependent = true, SetAccess = private)
        %flsPC
        %flsAmp
        %phDiffMean
        %phDiffStd
        %rho
    %end
