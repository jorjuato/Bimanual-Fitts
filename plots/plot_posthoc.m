function plot_posthoc(vname, data, vnames, flist)
    if nargin<4, error('need four input arguments'); end
    
    cnames={'Strong','Weak'};
    rfirst=1;
    
    flist=sort_byfactno(flist);
    for f=1:length(flist)
       factors=sortgroups(flist{f},rfirst)
       vdata = rearrange_var_data(vname,data,vnames,factors);       
       switch length(factors)
           case 1               
               figure('name',factors{:},'numbertitle','off')
               ax=subplot(1,1,1);
               plot_bw(vdata,factors{1},vname,ax);
               posthoc2(vname,data,vnames,factors)
           case 2
               figure('name',[factors{:}],'numbertitle','off')
               ax=subplot(1,1,1);
               plot_interaction(vdata,factors,vname,ax);
               posthoc2(vname,data,vnames,factors)
           case 3
               figure('name',[factors{:}],'numbertitle','off')
               if strcmp('grp',factors{1})
                   for g=1:2
                       ax=subplot(1,2,g);
                       plot_interaction(squeeze(vdata(g,:,:,:)),factors(2:end),vname,ax);
                       title(sprintf('%s Coupling',cnames{g}));
                   end
                   posthoc2(vname,data,vnames,factors)
               elseif strcmp('idl',factors{1})
                   for l=1:2
                       ax=subplot(1,2,l);
                       plot_interaction(squeeze(vdata(l,:,:,:)),factors(2:end),vname,ax);
                       title(sprintf('IDL %d',l));
                   end
                   posthoc2(vname,data,vnames,factors)
                elseif strcmp('idr',factors{1})
                   for r=1:3
                       ax=subplot(1,3,r);
                       plot_interaction(squeeze(vdata(r,:,:,:)),factors(2:end),vname,ax);
                       title(sprintf('IDR %d',l));
                   end
                   posthoc2(vname,data,vnames,factors)                   
               end
           case 4
               figure('name',[factors{:}],'numbertitle','off')
               for g=1:2
                   if rfirst
                       for l=1:3
                           ax=subplot(2,3,l+(g-1)*3);
                           plot_interaction(squeeze(vdata(g,l,:,:,:)),factors(3:end),vname,ax);
                           title(sprintf('%s Coupling - IDR %d',cnames{g},l));
                       end
                   else
                       for l=1:2
                           ax=subplot(2,2,l+(g-1)*2);
                           plot_interaction(squeeze(vdata(g,l,:,:,:)),factors(3:end),vname,ax);
                           title(sprintf('%s Coupling - IDL %d',cnames{g},l));
                       end  
                   end
               end
               posthoc2(vname,data,vnames,factors)
       end

    end
end

function plot_bw(data,factor,vname,ax)
    if nargin<4, figure;ax=subplot(1,1,1); end
    gp=get_props({'',factor});
    boxplot(ax,data')
    title(factor)
    ylabel(vname);
    set(ax,'XTick',gp.x,'XTicklabel',gp.xticklabels);    
end

function plot_interaction(data,factors,vname,ax)
    if nargin<4, figure;ax=subplot(1,1,1); end

    %Get bar groups for plotting
    [f1,f2,kk]=size(data);
    bar_data=zeros(f1,f2,2);
    for i=1:f1
        for j=1:f2
            bar_data(i,j,1)=mean(data(i,j,:));
            bar_data(i,j,2)=std(data(i,j,:));
        end
    end

    %Get graphic properties of factors
    gp=get_props(factors);
    h=cell(f1,1);
    hold on
    for i=1:f1
        h{i}=errorbar(ax,gp.x,bar_data(i,:,1),bar_data(i,:,2),'Color',gp.colors{i});        
    end
    hold off
    ylabel(vname);
    set(ax,'XTick',gp.x,'XTicklabel',gp.xticklabels);    
    legend(gp.labels')
    title(sprintf('%s vs %s',factors{1},factors{2}));
end

function gp = get_props(factors)
    gp=struct();

    if strcmp('grp',factors{1}) 
        gp.colors={[1,0.2,0.2],[0.2,0.2,1]};
        gp.labels={'StrongCoupling','WeakCoupling'};
    elseif strcmp('ss',factors{1})
        gp.colors={[1,0.2,0.2],[0.2,0.2,1],[0.2,1,0.2]};
        gp.labels={'S1','S2','S3'};
    elseif strcmp('idl',factors{1})
        gp.colors={[1,0.2,0.2],[0.2,0.2,1]};
        gp.labels={'IDL-Difficult','IDL-Easy'};
    else
        gp.colors={[1,0.2,0.2],[0.2,0.2,1],[0.2,1,0.2]};
        gp.labels={'IDR-Difficult','IDR-Medium','IDR-Easy'};
    end
    
    if strcmp('grp',factors{2}) 
        gp.x=[1,2];       
        gp.xticklabels={'StrongCoupling','WeakCoupling'};
    elseif strcmp('ss',factors{2})
        gp.x=[1,2,3];
        gp.xticklabels={'S1','S2','S3'};
    elseif strcmp('idl',factors{2})
        gp.x=[1,2];        
        gp.xticklabels={'IDL-Diff','IDL-Easy'};
    else
        gp.x=[1,2,3];        
        gp.xticklabels={'IDR-Diff','IDR-Medium','IDR-Easy'};    
    end
end

function flist=sort_byfactno(flist)
    %# extract the first number from each element of array_A
    elementLengths = cellfun(@(x) length(x),flist);
    %# sort (the ~ discards the first output argument of sort)
    [~,sortIdx] = sort(elementLengths);
    %# sort array_A using the proper sort order
    flist = flist(sortIdx);
end

function fout = sortgroups(fin,rfirst)
    fout=cell(1,length(fin));
    grp=strcmp('grp',fin);
    ss=strcmp('ss',fin);
    idl=strcmp('idl',fin);
    idr=strcmp('idr',fin);
    if rfirst == 1
        if any(grp)
            fout{1}='grp';
            if any(idr)
                fout{2}='idr';
                if any(idl)
                    fout{3}='idl';
                    if any(ss)
                        fout{4}='ss';
                    end
                elseif any(ss)
                    fout{3}='ss';
                end
            elseif any(idl)
                fout{2}='idl';
                if any(ss)
                    fout{3}='ss';
                end
            elseif any(ss)
                fout{2}='ss';
            end
        elseif any(idr)
            fout{1}='idr';
            if any(idl)
                fout{2}='idl';
                if any(ss)
                    fout{3}='ss';
                end
            elseif any(ss)
                fout{2}='ss';
            end
        elseif any(idl)
            fout{1}='idl';
            if any(ss)
                fout{2}='ss';
            end
        elseif any(ss)
            fout{1}='ss';
        else
            error('Something is wrong with your factors. Please check')
        end
    else
        if any(grp)
            fout{1}='grp';
            if any(idl)
                fout{2}='idl';
                if any(idr)
                    fout{3}='idr';
                    if any(ss)
                        fout{4}='ss';
                    end
                elseif any(ss)
                    fout{3}='ss';
                end
            elseif any(idr)
                fout{2}='idr';
                if any(ss)
                    fout{3}='ss';
                end
            elseif any(ss)
                fout{2}='ss';
            end
        elseif any(idl)
            fout{1}='idl';
            if any(idr)
                fout{2}='idr';
                if any(ss)
                    fout{3}='ss';
                end
            elseif any(ss)
                fout{2}='ss';
            end
        elseif any(idr)
            fout{1}='idr';
            if any(ss)
                fout{2}='ss';
            end
        elseif any(ss)
            fout{1}='ss';
        else
            error('Something is wrong with your factors. Please check')
        end        
    end        
end