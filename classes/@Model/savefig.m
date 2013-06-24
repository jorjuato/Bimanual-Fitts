function savefig(mdl,fig,figname)
    if nargin<3, figname=fig; fig=gcf; end
    
    if strfind('\phi_{\sigma}',figname)
        figname='phasediffstd';
    end
    figname = joinpath(mdl.conf.savepath,figname);
    if ~isempty(mdl.conf.savepath) && exist(mdl.conf.savepath,'dir')
        if strcmp(mdl.conf.ext,'fig')
            hgsave(fig,figname,'all');
        else
            set(fig, 'PaperUnits', 'inches', 'PaperPosition', mdl.conf.figsize/mdl.conf.dpi);
            print(fig,['-d',mdl.conf.ext],sprintf('-r%d',mdl.conf.dpi),figname);     
        end           
    end
end