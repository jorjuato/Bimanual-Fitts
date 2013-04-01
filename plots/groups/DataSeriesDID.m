classdef DataSeriesDID < handle
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
        
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function ds = DataSeriesDID(bi,factors)
            ds.factors=factors;
            ds.get_properties(bi);
            ds.fetch_data(bi);
            
            ds.ymin = nanmin(filterOutliers(bi(:)));
            ds.ymax = nanmax(filterOutliers(bi(:)));
            ds.yrange=ds.ymax-ds.ymin;
            ds.ylim=[ds.ymin-ds.yrange/10,ds.ymax+ds.yrange/10];
            if ds.ylim(1)<0 & ds.ymin>=0
                ds.ylim(1)=0;
            end
            ds.xmin = 0;
            ds.xmax = (3*ds.franges(2)+1)*ds.franges(1)-1;
            ds.get_xlabels_pos();
            
            % Factor 2, determines legend names and coloring scheme
            if strcmp(ds.factors{end},'grp')
                ds.names ={'Coupled','Uncoupled'};
                ds.colors={[[0.6,0.2,0.2] ; [0.8,0.2,0.2];[1,0.2,0.2]],...
                           [[0.2,0.2,1]   ; [0.2,0.2,0.8];[0.2,0.2,0.6]]};
            elseif strcmp(ds.factors{end},'did')
                ds.names ={'DID-zero','DID-small','DIDR-large'};
                ds.colors={[[0.6,0.2,0.2] ; [0.8,0.2,0.2];[1,0.2,0.2]],...
                           [[0.2,0.2,1]   ; [0.2,0.2,0.8];[0.2,0.2,0.6]],...
                           [[0.2,0.6,0.2] ; [0.2,0.8,0.2];[0.2,1,0.2]]};
            end
            
            % Factor 1 labels
            if strcmp(ds.factors{1},'grp')
                ds.xlabels={'Coupled','Uncoupled'};
            elseif strcmp(ds.factors{1},'did')
                ds.xlabels={'Zero','Small','Large'};
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function get_properties(ds,bi)
            %Diferenciate bimanual/unimanual variables
            if length(size(bi))==4
                [grp, ds.ss, did, reps]=size(bi);
                ds.two_hands=0;
            else
                [hno, grp, ds.ss, did, reps]=size(bi);
                ds.two_hands=1;
                ds.hnames={'Left Hand','Right Hand'};
            end
            
            %Compute ranges of factors
            ds.franges=zeros(1,length(ds.factors));
            for i=1:length(ds.factors)
                if strcmp(ds.factors{i},'grp')
                    ds.franges(i)=grp;
                elseif strcmp(ds.factors{i},'did')
                    ds.franges(i)=did;
                end
            end
            
            %Allocate data matrices depending on handedness
            if ds.two_hands
                ds.data = zeros(hno,ds.franges(1),ds.franges(2),ds.ss,2);                
            else
                ds.data = zeros(ds.franges(1),ds.franges(2),ds.ss,2);
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function fetch_data(ds,bi)            
            for f1=1:ds.franges(1)
                for f2=1:ds.franges(2)
                    [g,did]=ds.get_indexes([f1,f2]);
                    if ds.two_hands
                        for h=1:2
                            for s=1:ds.ss
                                ds.data(h,f1,f2,s,1)=nanmedian(squeeze(bi(h,g,s,did,:)));
                                ds.data(h,f1,f2,s,2)=nanste(squeeze(bi(h,g,s,did,:)));
                            end
                        end
                    else
                        for s=1:3
                            ds.data(f1,f2,s,1)=nanmedian(squeeze(bi(g,s,did,:)));
                            ds.data(f1,f2,s,2)=nanste(squeeze(bi(g,s,did,:)));
                        end
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [g,did] = get_indexes(ds,fvals)
            for i=1:length(ds.factors)
                if strcmp(ds.factors{i},'grp')
                    g=fvals(i);
                elseif strcmp(ds.factors{i},'did')
                    did=fvals(i);
                end
            end
        end   
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function gap = get_gap(ds,f1,f2)
            %   f3-blk-pos  + f2-blk-size  *  f2-blk-no
            gap=(ds.ss+0.5)*(f2-1)+((ds.ss+0.5)*ds.franges(2)+2)*(f1-1);
        end
        
        function get_xlabels_pos(ds)
           ds.xlabels_pos = zeros(ds.franges(1),2);
           for i=1:ds.franges(1)
               if ds.franges(2)==2
                   ds.xlabels_pos(i,1)=ds.get_gap(i,1)+3;
               else
                   ds.xlabels_pos(i,1)=ds.get_gap(i,2)+2;
               end
               ds.xlabels_pos(i,2)=ds.ymax+ds.ymax/15;
           end               
        end
    end
end