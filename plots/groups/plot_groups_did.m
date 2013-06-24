function plot_groups_did(obj,factors)
    if nargin<2
        error('Not enough input arguments');
    elseif nargin==2
        factors={'grp','did'};
    end
    
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
    
    vars={'rho','flsPC','phDiffStd','MI','minPeakDelay','minPeakDelayNorm','D3D','D4D'};
    titles={'rho','flsPC','phDiffStd','MI','minPeakDelay','minPeakDelayNorm','D3D','D4D'};
    
    %Rearrange data matrices by group if needed
    if size(obj.dataD,3)==10
        obj.dataD=group_participant_data(obj.dataD);
    end
    
    %PLOT IT ALL
    for v=1:length(vars)    
        %Get index for variable in data arrays
        v1=strcmp(vars{v}, obj.vnamesB);
        
        %Prepare matrices
        bi=squeeze(obj.dataD(v1,:,:,:,:));

        %Absolute plots
        plot_groups_did_var(DataSeriesDID(bi,factors),titles{v});
    end
end


