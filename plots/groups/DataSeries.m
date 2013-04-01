classdef DataSeries < handle
    properties
        data
        vname
        names
        hnames
        factors
        franges
        two_hands
        colors
        xlabels
        ylabels
        xlabels_pos
        ylabels_pos
        ymin
        ymax
        yrange
        ylim
        xmin
        xmax
        ss
    end
    
    properties (Dependent = true, SetAccess = private)
        legends
    end
    
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function legends = get.legends(ds)
            legends={};
            for i=1:length(ds.names)
                legends{i}=ds.names{i};
            end            
        end
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function ds = DataSeries(vname,bi,un,factors)
            if nargin==3
                ds.factors=un;
                ds.get_properties(bi);
                ds.fetch_data(bi);
                ds.ymin = nanmin(filterOutliers(bi(:)));
                ds.ymax = nanmax(filterOutliers(bi(:)));
                ds.yrange=ds.ymax-ds.ymin;
                ds.ylim=[ds.ymin-ds.yrange/10,ds.ymax+ds.yrange/10];
                if ds.ylim(1)<0 & ds.ymin>=0
                    ds.ylim(1)=0;
                end
            elseif nargin==4
                ds.factors=factors;
                ds.get_properties(bi);
                ds.fetch_relative_data(bi,un);
                if strfind(vname,'{rel}')
                    means=squeeze(ds.data(:,:,:,:,:,1));
                    stdes=squeeze(ds.data(:,:,:,:,:,2));
                    mmax=means+stdes;
                    mmin=means-stdes;
                    ds.ymin = min(mmin(:));
                    ds.ymax = max(mmax(:));
                    ds.yrange=ds.ymax-ds.ymin;
                    ds.ylim=[ds.ymin,ds.ymax];     
                    if (ds.ylim(1)<0 & ~any(means<0))
                        ds.ylim(1)=0;
                    end
                else
                    ds.ymin = nanmin(filterOutliers(bi(:)));
                    ds.ymax = nanmax(filterOutliers(bi(:)));
                    ds.yrange=ds.ymax-ds.ymin;
                    ds.ylim=[ds.ymin-ds.yrange/10,ds.ymax+ds.yrange/10];
                    if ds.ylim(1)<0 & ds.ymin>0
                        ds.ylim(1)=0;
                    end
                end
           
            end            
            ds.vname= vname;            
            ds.xmin = 0;
            ds.xmax = (3*ds.franges(3)+1)*ds.franges(2)+2;
            ds.get_labels_pos();            
            
            %Factor 3, determines legend names and coloring scheme
            if strcmp(ds.factors{end},'grp')
                ds.names ={'Strong','Weak'};
                ds.colors={[[1,0.2,0.2]   ;[0.8,0.2,0.2];[0.6,0.2,0.2]],...
                           [[0.2,0.2,1]   ;[0.2,0.2,0.8];[0.2,0.2,0.6]]};
            elseif strcmp(ds.factors{end},'idr')
                ds.names ={'IDR-Difficult','IDR-Medium','IDR-Easy'};
                ds.colors={[[1,0.2,0.2]   ;[0.8,0.2,0.2];[0.6,0.2,0.2]],...
                           [[0.2,0.2,1]   ;[0.2,0.2,0.8];[0.2,0.2,0.6]],...
                           [[0.2,1,0.2]   ;[0.2,0.8,0.2];[0.2,0.6,0.2]]};
            else
                ds.names ={'IDL-Difficult','IDL-Easy'};
                ds.colors={[[1,0.2,0.2]   ;[0.8,0.2,0.2];[0.6,0.2,0.2]],...
                           [[0.2,0.2,1]   ;[0.2,0.2,0.8];[0.2,0.2,0.6]]};
            end

            %Factor 2 labels
            if strcmp(ds.factors{2},'grp')
                ds.xlabels={'Strong','Weak'};
            elseif strcmp(ds.factors{2},'idl')
                ds.xlabels={'LD','LE'};
            else
                ds.xlabels={'RD','RM','RE'};
            end

            %Factor 1 labels
            if strcmp(ds.factors{1},'grp')
                ds.ylabels={'Strong','Weak'};
            elseif strcmp(ds.factors{1},'idl')
                ds.ylabels={'LD','LE'};
            else
                ds.ylabels={'RD','RM','RE'};
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function get_properties(ds,bi)
            %Diferenciate bimanual/unimanual variables
            if length(size(bi))==5
                [grp, ds.ss, idl, idr, reps]=size(bi);
                ds.two_hands=0;
            else
                [hno, grp, ds.ss, idl, idr, reps]=size(bi);
                ds.two_hands=1;
                ds.hnames={'Left Hand','Right Hand'};
            end
            
            %Compute ranges of factors
            ds.franges=zeros(1,length(ds.factors));
            for i=1:length(ds.factors)
                if strcmp(ds.factors{i},'grp')
                    ds.franges(i)=grp;
                elseif strcmp(ds.factors{i},'idl')
                    ds.franges(i)=idl;
                elseif strcmp(ds.factors{i},'idr')
                    ds.franges(i)=idr;
                end
            end
            
            %Allocate data matrices depending on handedness
            if ds.two_hands
                ds.data = zeros(hno,ds.franges(1),ds.franges(2),ds.franges(3),ds.ss,2);                
            else
                ds.data = zeros(ds.franges(1),ds.franges(2),ds.franges(3),ds.ss,2);
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function fetch_relative_data(ds,bi,un)
            for f1=1:ds.franges(1)
                for f2=1:ds.franges(2)
                    for f3=1:ds.franges(3)
                        [g,r,l]=ds.get_indexes([f1,f2,f3]);
                        for h=1:2               
                            for s=1:ds.ss
                                if h==1 %left hand
                                    unirep=squeeze(un(h,g,s,l,:));
                                    birep=squeeze(bi(h,g,s,l,r,:));
                                    if any(unirep==0), continue; end
                                    relmean=nanmean(birep./unirep);
                                    relste=nanste(birep./unirep);
                                else
                                    unirep=squeeze(un(h,g,s,r,:));
                                    birep=squeeze(bi(h,g,s,l,r,:));
                                    if any(unirep==0), continue; end
                                    relmean=nanmean(birep./unirep);
                                    relste=nanste(birep./unirep);
                                end
                                ds.data(h,f1,f2,f3,s,1)=relmean;
                                ds.data(h,f1,f2,f3,s,2)=relste;
                            end
                        end
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function fetch_data(ds,bi)            
            for f1=1:ds.franges(1)
                for f2=1:ds.franges(2)
                    for f3=1:ds.franges(3)
                        [g,r,l]=ds.get_indexes([f1,f2,f3]);
                        if ds.two_hands
                            for h=1:2                 
                                for s=1:ds.ss
                                    ds.data(h,f1,f2,f3,s,1)=nanmedian(squeeze(bi(h,g,s,l,r,:)));
                                    ds.data(h,f1,f2,f3,s,2)=nanste(squeeze(bi(h,g,s,l,r,:)));
                                end
                            end
                        else
                            for s=1:3
                                ds.data(f1,f2,f3,s,1)=nanmedian(squeeze(bi(g,s,l,r,:)));
                                ds.data(f1,f2,f3,s,2)=nanste(squeeze(bi(g,s,l,r,:)));
                            end
                        end
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [g,r,l] = get_indexes(ds,fvals)
            for i=1:length(ds.factors)
                if strcmp(ds.factors{i},'grp')
                    g=fvals(i);
                elseif strcmp(ds.factors{i},'idl')
                    l=fvals(i);
                elseif strcmp(ds.factors{i},'idr')
                    r=fvals(i);
                end
            end
        end   
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function gap = get_gap(ds,f2,f3)
            %   f3-blk-pos  + f2-blk-size  *  f2-blk-no
            gap=(ds.ss+0.5)*(f3-1)+((ds.ss+0.5)*ds.franges(3)+2)*(f2-1);
        end
        
        function get_labels_pos(ds)
           ds.xlabels_pos = zeros(ds.franges(2),2);
           ds.ylabels_pos = [ds.xmax+1,ds.ymax/2];
           for i=1:ds.franges(2)
               if ds.franges(3)==2
                   ds.xlabels_pos(i,1)=ds.get_gap(i,1)+3;
               else
                   ds.xlabels_pos(i,1)=ds.get_gap(i,2)+2;
               end
               ds.xlabels_pos(i,2)=ds.ymax+ds.ymax/10;
           end               
        end
    end
end