

generate.relative.vars <- function(bidata,uLdata,uRdata){
    vnames=names(uLdata)[-(1:4)]         
    #foreach (vname=vnames) %dopar% {
    for (vname in vnames) {        
        for (hand in c('R','L')) {
            bivname=paste(vname,hand,sep='')
            for (i in 1:nrow(bidata)) {            
                pp<- as.numeric(bidata[i,'pp'])            
                S <- as.numeric(levels(bidata$S)[bidata[i,'S']])
                ID<- as.numeric(bidata[i,paste('ID',hand,sep='')])
                form=sprintf("val<-mean( u%sdata$%s[ u%sdata$pp==%d & u%sdata$S==%d & u%sdata$ID==%d ] )", hand,vname,hand,pp,hand,S,hand,ID)
                eval(parse(text=form))
                form=sprintf("bidata$%srel[[i]]<-bidata$%s[[i]]/val",bivname,bivname)
                eval(parse(text=form))
            }
        }
    }
#    bidata$MTBiAll<-bidata$MTL+bidata$MTR
#    bidata$MTUniAll<-uLdata$MT+uRdata$MT
#    bidata$MTAllRel<-bidata$MTBiAll+bidata$MTUniAll
    return(bidata)
}


bimanual_fcns <- function(bidata,vname,vpath){
	if (do_summary == TRUE) do.summary(bidata,vname,vpath)
	
	if (do_aov == TRUE) do.aov(bidata,vname,vpath)
	
	if (do_lme == TRUE) do.lme(bidata,vname,vpath)
	
	if (do_ANOVA == TRUE) do.ANOVA(bidata,vname,vpath)
	
	if (do_CompareANOVA == TRUE) do.compare.ANOVA(bidata,vname,vpath)
	
	if (do_lmer == TRUE) do.lmer(bidata,vname,vpath)
	
	if (do_lmer_tukey == TRUE) do.lmer.tukey(bidata,vname,vpath)

	if (do_barchart == TRUE) plot_barcharts(bidata,vname,vpath)
	
	if (do_interaction == TRUE) plot_interactions(bidata,vname,vpath)
	
	if (do_boxplots == TRUE) plot_boxplots(bidata,vname,vpath)
	
	if (do_density && vname %in% densityplots) plot_densityplot(bidata,vname,vpath)
}

bimanualDelta_fcns <- function(biddata,vname,vpath){
	if (do_summary == TRUE) do.summary.did(biddata,vname,vpath)
	
	if (do_aov == TRUE) do.aov.did(biddata,vname,vpath)
	
	if (do_lme == TRUE) do.lme.did(biddata,vname,vpath)
	
	if (do_ANOVA == TRUE) do.ANOVA.did(biddata,vname,vpath)
	
	if (do_CompareANOVA == TRUE) do.compare.ANOVA.did(biddata,vname,vpath)
	
	if (do_lmer == TRUE) do.lmer.did(biddata,vname,vpath)
	
	if (do_lmer_tukey == TRUE) do.lmer.tukey.did(biddata,vname,vpath)

	if (do_barchart == TRUE) plot_barcharts.did(biddata,vname,vpath)
	
	if (do_interaction == TRUE) plot_interactions.did(biddata,vname,vpath)
	
	if (do_boxplots == TRUE) plot_boxplots.did(biddata,vname,vpath)
	
	if (do_density && vname %in% densityplots) plot_densityplot.did(biddata,vname,vpath)
}

unimanual_fcns <- function(udata,vname,vpath){
    if (do_summary) do.summary.uni(udata,vname,vpath)
    
    if (do_aov) do.aov.uni(udata,vname,vpath)
    
    if (do_lme) do.lme.uni(udata,vname,vpath)
    
    if (do_ANOVA) do.ANOVA.uni(udata,vname,vpath)
    
    if (do_CompareANOVA) do.compare.ANOVA.uni(udata,vname,vpath)
    
    if (do_lmer) do.lmer.uni(udata,vname,vpath)
    
    if (do_lmer_tukey) do.lmer.uni.tukey(udata,vname,vpath)

    if (do_barchart) plot_barcharts.uni(udata,vname,vpath)
    
    if (do_interaction) plot_interactions.uni(udata,vname,vpath)
    
    if (do_boxplots) plot_boxplots.uni(udata,vname,vpath)
    
    if (do_density && vname %in% densityplots) plot_densityplot.uni(udata,vname,vpath)
}
