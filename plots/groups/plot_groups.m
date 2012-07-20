function plot_groups(dataBi,dataUn,varnamesBi,varnamesUn, vartypesBi, vartypesUn)
    if nargin<4, error('Not enough input arguments'); end
    
    %PLOT IT ALL
    plot_groups_MT(dataBi,dataUn,varnamesBi,varnamesUn);
    plot_groups_avgMT(dataBi,dataUn,varnamesBi,varnamesUn);
    plot_groups_Phase(dataBi,varnamesBi);
    plot_groups_Frequency(dataBi,dataUn,varnamesBi,varnamesUn);
    plot_groups_Locking(dataBi,varnamesBi);
    plot_groups_Harmonicity(dataBi,dataUn,varnamesBi,varnamesUn);
    plot_groups_peakDelay(dataBi,varnamesBi);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  plot_groups_MT(bi,un,biNames,unNames)
    if nargin<2, error('Not enough input arguments'); end
    
    %Define or fetch some globals
    global do_legend
    do_legend=1;
    plot_type='subplot';
    rootname='MovementTime';
    data_series= get_data_series({2,1,3});
    
    %Fetch all data for bars
    v1=strcmp('MT', biNames);
    v2=strcmp('MT', unNames);
    MTbi  = squeeze(bi(v1,:,:,:,:,:,:));      
    MTun  = squeeze(un(v2 ,:,:,:,:,:));
    bar_grps = get_bar_groups(MTbi,MTun,data_series);    
    
    %Select the type of plot
    plot_bars_bi(bar_grps,data_series,plot_type,rootname);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  plot_groups_avgMT(bi,un,biNames,unNames)
    if nargin<2, error('Not enough input arguments'); end
    %WONT WORK!!!!!
    %Define or fetch some globals
    global do_legend
    do_legend=1;
    plot_type='figure';
    rootname='OverallMT';
    data_series= get_data_series({2,1,3});
    
    %Fetch all data for bars
    v1=strcmp('MT', biNames);
    v2=strcmp('MT', unNames);
    MTb = squeeze(bi(v1,:,:,:,:,:,:));      
    MTu = squeeze(un(v2 ,:,:,:,:,:));
    bar_grps = get_bar_groups(MTb,MTu,data_series);    
    
    %Plot the thing!
    plot_bars_bi(bar_grps,data_series,plot_type,rootname);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  plot_groups_Harmonicity(bi,un,biNames,unNames)
    if nargin<2, error('Not enough input arguments'); end
    
    %Define or fetch some globals
    global do_legend
    do_legend=1;
    plot_type='figure';
    rootname='Harmonicity';
    data_series=get_data_series({2,1,3});
    
    %Fetch all data for bars
    v1=strcmp('Harmonicity', biNames);
    v2=strcmp('Harmonicity', unNames);
    Hb = squeeze(bi(v1,:,:,:,:,:,:));
    Hu = squeeze(un(v2 ,:,:,:,:,:));
    bar_grps = get_bar_groups(Hb,Hu,data_series);
    plot_bars_bi(bar_grps,data_series,plot_type,rootname);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  plot_groups_Frequency(bi,un,biNames,unNames)
    if nargin<2, error('Not enough input arguments'); end
    %WONT WORK!!!!
    %Define or fetch some globals
    global do_legend
    do_legend=1;
    plot_type='figure';
    rootname='Frequency';
    data_series=get_data_series({2,1,3});
    
    %Fetch all data for bars
    v1=strcmp('f', biNames);
    v2=strcmp('f', unNames);
    Fb=squeeze(bi(v1,:,:,:,:,:,:));
    Fu=squeeze(un(v2,:,:,:,:,:));
    
    bar_grps = get_bar_groups(Fb,Fu,data_series);    
    plot_bars_bi(bar_grps,data_series,plot_type,rootname);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  plot_groups_Phase(bi,biNames)
    if nargin<2, error('Not enough input arguments'); end

    %Define or fetch some globals
    global do_legend
    do_legend=1;
    plot_type='figure';
    data_series= get_data_series({1,2});
    %Fetch all data for bars
    vnames={'phDiffMean','phDiffStd','MI','minPeakDelayNorm','minPeakDelay'};
    vars={};
    for v=1:length(vnames)
        v1=strcmp(vnames{v}, biNames);
        vars{v} = squeeze(bi(v1,:,:,:,:,:,:));
    end
    bar_grps = get_bar_groups(vars,data_series);
    
    %Plot the thing
    plot_bars_grouped(bar_grps,data_series,plot_type,vnames);    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  plot_groups_Locking(bi,biNames)
    if nargin<2, error('Not enough input arguments'); end

    %Define or fetch some globals
    global do_legend
    do_legend=1;
    plot_type='figure';
    data_series=get_data_series({1,2});
    
    %Fetch all data for bars
    vnames={'flsPC','flsAmp','rho'};
    vars={};
    for v=1:length(vnames)
        v1=strcmp(vnames{v}, biNames);
        vars{v} = squeeze(bi(v1,:,:,:,:,:,:));
    end
    bar_grps = get_bar_groups(vars,data_series);
    
    plot_bars_grouped(bar_grps,data_series,plot_type,vnames);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ds= get_data_series(order)
    if length(order)==3
        ds=struct( 'name' ,{'Coupled','Uncoupled','Unimanual'},...
                   'color',{[[0.6,0.2,0.2] ; [0.8,0.2,0.2];[1,0.2,0.2]],...
                            [[0.2,0.2,1]   ; [0.2,0.2,0.8];[0.2,0.2,0.6]],...
                            [[0.2,0.6,0.2] ; [0.2,0.8,0.2];[0.2,1,0.2]]},...
                   'order',order,...
                   'width',{1,0.7,0.5});
    else
        ds=struct( 'name' ,{'Coupled','Uncoupled'},...
                   'color',{[[0.6,0.2,0.2] ; [0.8,0.2,0.2];[1,0.2,0.2]],...
                            [[0.2,0.2,1]   ; [0.2,0.2,0.8];[0.2,0.2,0.6]]},...
                   'order',order,...
                   'width',{0.8,0.5});       
    end
end
                    