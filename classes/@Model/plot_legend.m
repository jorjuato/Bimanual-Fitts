function plot_legend(mdl,ax,rname,rrange)
    %Legend related stuff
    legtxts=cell(length(rrange),1);
    for r=1:length(rrange)
        legtxts{r}=[rname ' = ' num2str(rrange(r))];
    end
    legend(ax,legtxts);
end