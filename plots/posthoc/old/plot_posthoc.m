function plot_posthoc_var(vname, data, vnames, flist,rel)
    if nargin<5, rel=0; end
    if nargin<4, error('need four input arguments'); end    
    
    
    %Fix labels for relative plots
    if rel
        vstr=[vname,'_relative']; 
    else
        vstr=vname;
    end
    
    if ~isempty(vstr) && ~exist(vstr,'dir') 
        mkdir(vstr);
    end
    
    %To plot ipsilateral variables always first in interactions
    if strcmp(vname(end),'R')
        rfirst=1;
    else
        rfirst=0;
    end
    
    %Proper figure labelling
    cnames={'Strong','Weak'};
    lnames={'Difficult','Easy'};
    rnames={'Difficult','medium','Easy'};
    snames={'pretest','test','posttest'};
    
    %Sort factor interaction list by the order of the interaction
    elementLengths = cellfun(@(x) length(x),flist);
    [~,sortIdx] = sort(elementLengths);
    flist = flist(sortIdx);
    
    %Iterate over interactions
    for f=1:length(flist)
       %Very custom sorting of groups
       factors=sortgroups(flist{f},rfirst);
       
       %Print some nice header
       disp('')
       disp(repmat('=',1,80))
       disp('Post-hoc analysis using Holm-Sidak pairwise comparisons on factors')
       disp(factors)
       
       %Rearrange data matrix to match that of factors
       vdata = rearrange_var_data(vname,data,vnames,factors);
       
       %Get post-hoc crosslevel comparisons for the interaction
       [f1mat,f2mat]=posthoc2(vname,data,vnames,factors);
       
       %Choose plotting according to number and type of factors
       switch length(factors)
           case 1               
               figure('name',factors{:},'numbertitle','off')
               ax=subplot(1,1,1);
               plot_bw(vdata,factors{1},vstr,ax);
               save_fig(vstr,factors)
           case 2
               figure('name',[factors{:}],'numbertitle','off')
               ax=subplot(1,1,1);
               [bar_data,gp]=plot_interaction(vdata,factors,vstr,ax);
               add_anotations(bar_data,gp,f1mat,f2mat);
               save_fig(vstr,factors)
           case 3
               figure('name',[factors{:}],'numbertitle','off')
               if strcmp('grp',factors{1})
                   for g=1:2
                       ax=subplot(1,2,g);
                       [bar_data,gp]=plot_interaction(squeeze(vdata(g,:,:,:)),factors(2:end),vstr,ax);
                       title(sprintf('%s Coupling',cnames{g}));
                       add_anotations(bar_data,gp,f1mat(g,:,:),f2mat(g,:,:));
                   end
                   save_fig(vstr,factors)
               elseif strcmp('idl',factors{1})
                   for l=1:2
                       ax=subplot(1,2,l);
                       [bar_data,gp]=plot_interaction(squeeze(vdata(l,:,:,:)),factors(2:end),vstr,ax);
                       title(['IDL ',lnames{l}]);
                       add_anotations(bar_data,gp,f1mat(l,:,:),f2mat(l,:,:));
                   end                   
                   save_fig(vstr,factors)
                elseif strcmp('idr',factors{1})
                   for r=1:3
                       ax=subplot(1,3,r);
                       [bar_data,gp]=plot_interaction(squeeze(vdata(r,:,:,:)),factors(2:end),vstr,ax);
                       title(['IDR ',rnames{r}]);
                       add_anotations(bar_data,gp,f1mat(r,:,:),f2mat(r,:,:));
                   end
                   save_fig(vstr,factors)
               end
           case 4
               [f1mat,f2mat]=posthoc2(vname,data,vnames,factors);
               figure('name',[factors{:}],'numbertitle','off')
               for g=1:2
                   if rfirst
                       for r=1:3
                           ax=subplot(2,3,r+(g-1)*3);
                           [bar_data,gp]=plot_interaction(squeeze(vdata(g,r,:,:,:)),factors(3:end),vstr,ax);
                           title(sprintf('%s Coupling - IDR %s',cnames{g},rnames{r}));
                           add_anotations(bar_data,gp,f1mat(g,r,:,:),f2mat(g,r,:,:));
                       end
                   else
                       for l=1:2
                           ax=subplot(2,2,l+(g-1)*2);
                           [bar_data,gp]=plot_interaction(squeeze(vdata(g,l,:,:,:)),factors(3:end),vstr,ax);
                           title(sprintf('%s Coupling - IDL %s',cnames{g},lnames{l}));
                           add_anotations(bar_data,gp,f1mat(g,l,:,:),f2mat(g,l,:,:));
                       end  
                   end
               end          
               save_fig(vstr,factors)
       end

    end
end

function add_anotations(bardata,gp,f1mat,f2mat)
    [f1,f1i]=size(f1mat);
    [f2,f2i]=size(f2mat);
    ymin=min(min(bardata(:,:,1)-bardata(:,:,2)));
    ymax=max(max(bardata(:,:,1)+bardata(:,:,2)));
    
    %Plot interaction of factor 1 across levels of factor 2
    for i=1:f1
        if ~any(f1mat(:)~=1)
            msg=sprintf('All significant for %s',gp.f1name);
            text(0.5,ymax,msg)
        elseif ~any(f1mat(:)~=0)
            msg=sprintf('All non significant for %s',gp.f1name);
            text(0.5,ymax,msg)
        else
            for j=1:f1i
                if f1mat(i,j)==0, continue; end
                [g1,g2]=get_groups(j,f2);
                if g1==1 && g2==3
                    x=g1-g1/10;
                    y=bardata(i,g1,1);
                    msg=sprintf('%s-%s',gp.f2{g1},gp.f2{g2});
                    text(x,y,msg,'BackgroundColor',[.3 .9 .3]);
                else
                    y=(bardata(i,g1,1)+bardata(i,g2,1))/2;
                    x=(g1+g2)/2;
                    msg=sprintf('%s-%s',gp.f2{g1},gp.f2{g2});
                    text(x,y,msg,'BackgroundColor',[.3 .9 .3]);
                end
            end
        end
    end
    %Plot interaction of factor 2 across levels of factor 1
    for i=1:f2
        if ~any(f2mat(:)~=1)
            msg=sprintf('All significant for %s',gp.f2name);
            text(0.5,ymax,msg)        
        elseif ~any(f2mat(:)~=0)
            msg=sprintf('All non significant for %s',gp.f2name);
            text(0.5,ymax,msg)
        else
            for j=1:f2i
                if f2mat(i,j)==0, continue; end
                [g1,g2]=get_groups(j,f1);
                if g1==1 && g2==3
                    y=bardata(g1,i,1)-bardata(g1,i,1)/10;
                    x=i;
                    msg=sprintf('%s|%s',gp.f1{g1},gp.f1{g2});
                    text(x,y,msg,'BackgroundColor',[.7 .9 .7]);
                else
                    y=(bardata(g1,i,1)+bardata(g2,i,1))/2;
                    x=i;
                    msg=sprintf('%s|%s',gp.f1{g1},gp.f1{g2});
                    text(x,y,msg,'BackgroundColor',[.7 .9 .7]);
                end
            end
        end
    end
end

function [g1,g2]=get_groups(j,flen)
    if flen==2
        g1=1;
        g2=2;
        return
    end
    switch j
        case 1
            g1=1;
            g2=2;
        case 2
            g1=2;
            g2=3;
        case 3
            g1=1;
            g2=3;
    end
end

function save_fig(vstr,factors)
    ext='jpg';

    figname = joinpath(vstr,[factors{:}]);
    if strcmp(ext,'fig')
        hgsave(gcf,figname,'all');
    else
        saveas(gcf,figname,ext);
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

function [bar_data,gp]=plot_interaction(data,factors,vname,ax)
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
        gp.f1={'ST','WK'};
        gp.f1name='group';
    elseif strcmp('ss',factors{1})
        gp.colors={[1,0.2,0.2],[0.2,0.2,1],[0.2,1,0.2]};
        gp.labels={'S1','S2','S3'};
        gp.f1=gp.labels;
        gp.f1name='session';
    elseif strcmp('idl',factors{1})
        gp.colors={[1,0.2,0.2],[0.2,0.2,1]};
        gp.labels={'IDL-Difficult','IDL-Easy'};
        gp.f1={'LD','LE'};
        gp.f1name='left id';
    else
        gp.colors={[1,0.2,0.2],[0.2,0.2,1],[0.2,1,0.2]};
        gp.labels={'IDR-Difficult','IDR-Medium','IDR-Easy'};
        gp.f1={'RD','RM','RE'};
        gp.f1name='rigth id';
    end
    
    if strcmp('grp',factors{2}) 
        gp.x=[1,2];       
        gp.xticklabels={'StrongCoupling','WeakCoupling'};
        gp.f2={'ST','WK'};
        gp.f2name='grp';
    elseif strcmp('ss',factors{2})
        gp.x=[1,2,3];
        gp.xticklabels={'S1','S2','S3'};
        gp.f2=gp.xticklabels;
        gp.f2name='session';
    elseif strcmp('idl',factors{2})
        gp.x=[1,2];        
        gp.xticklabels={'IDL-Diff','IDL-Easy'};
        gp.f2={'LD','LE'};
        gp.f2name='left id';
    else
        gp.x=[1,2,3];        
        gp.xticklabels={'IDR-Diff','IDR-Medium','IDR-Easy'};
        gp.f2={'RD','RM','RE'};
        gp.f2name='right id';
    end
end

function flist=sort_byfactno(flist)
    elementLengths = cellfun(@(x) length(x),flist);
    [~,sortIdx] = sort(elementLengths);
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