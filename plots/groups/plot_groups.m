function plot_groups(obj,factors,savepath_,idx)
    if nargin<7, idx=[6,13,14,15,17,18]; end
    if nargin<6, savepath_='';end
    if nargin<5, factors={'idr','idl','grp'}; end
    if nargin<4, error('Not enough input arguments'); end
    
    %Define or fetch some globals
    global do_legend;     do_legend=0;
    global do_anotations; do_anotations=0;
    global do_title;      do_title=0;
    global do_ylabel;     do_ylabel=1;
    global plot_type;     plot_type='subplot'; %'tight' 'figure' 'subplot'    
    global savepath;      savepath=savepath_;    
    global ext;           ext='png';
    global dpi;           dpi=300;
    global figsize;       figsize=[0,0,2400,1800];
    
    do_relative=1;
    
    vnames={'MT','accTime','decTime','accQ','IPerfEf',...
          'maxangle','d3D','d4D','Circularity',...
          'vfCircularity','vfTrajCircularity','Harmonicity',...
          'rho','flsPC','phDiffStd','MI','minPeakDelay','minPeakDelayNorm'};
      
    vstrs={'MT','AT','DT','AQ','IPE',...
          'MA','d3D','d4D','Circularity',...
          'VFC','VFT','H',...
          '\rho','FLS','\phi_{\sigma}','MI','dpeaks','dpeaks_{norm}'};

    units={' (s)',' (s)',' (s)','',' (bits/s)',...
          '(rad)','','','',...
          '','','',...
          '','','','','(s)','dpeaks_{norm} (s²)'};
      
    titles={'Movement Time','Acceleration Time','Deceleration Time','Acceleration Ratio','Effective Index of Performace',...
            'Maximal Angle','3D Distance','4D Distance','Circularity',...
            'Vector Field Circularity','Vector Field Trajectory Circularity','Harmonicity',...
            '\rho','flsPC','\phi_{\sigma}','Mutual Information','Minimal Peak Delay','Minimal Peak Delay Normalized'};
    
    %Select a subset of all variables if user demands so
    if ~isempty(idx)
        vnames=vnames(idx);
        vstrs=vstrs(idx);
        units=units(idx);
        titles=titles(idx);
    end
    
    %Rearrange data matrices by group if needed
    if size(obj.dataB,3)==10
        obj.dataB=group_participant_data(obj.dataB);
        obj.dataU=group_participant_data(obj.dataU);
    end
    
    %Create out dir if passed as argument
    if ~isempty(savepath) && ~exist(savepath,'dir') 
        mkdir(savepath);
    end
    
    %PLOT IT ALL
    for v=1:length(vnames)    
        %Get index for variable in data arrays
        v_bi=strcmp(vnames{v}, obj.vnamesB);
        v_un=strcmp(vnames{v}, obj.vnamesU);
        
        %Prepare matrices
        if any(v_un)
            bi=squeeze(obj.dataB(v_bi,:,:,:,:,:,:));
            un=squeeze(obj.dataU(v_un,:,:,:,:,:)); 
        else
            bi=squeeze(obj.dataB(v_bi,1,:,:,:,:,:));
        end

        %Absolute plots
        fprintf('Plotting variable %s\n',titles{v})
        plot_groups_var(DataSeries([vstrs{v},units{v}],bi,factors),titles{v});

        %Relative plots
        if any(v_un) && do_relative
            if strcmp(vstrs{v}(end),'}')
                vname=[vstrs{v}(1:end-1),'rel}',units{v}];
            else
                vname=[vstrs{v},'_{rel}',units{v}];
            end
            fprintf('Plotting variable Relative %s\n',titles{v})
            plot_groups_var(DataSeries(vname,bi,un,factors),['Relative ',titles{v}]);
        end
    end
end

