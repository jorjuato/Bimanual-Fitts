#Analysis of Variance for Bimanual Fitts experiment
require(doMC)
source("plot_fcns_bi.R")
source("stat_fcns_bi.R")
source("plot_fcns_uni.R")
source("stat_fcns_uni.R")
registerDoMC()

#Prepare global paths
rootpath='/home/jorge/KINARM'
Rname='resampled'
opath=paste(paste(rootpath,"stats",sep='/'),Rname,sep='/')
dir.create(opath,showWarnings=FALSE)
Rdatapath=paste(paste(rootpath,'Rdata',sep='/'),Rname,sep='/')
uLfile=paste(Rdatapath,"UniL_fitts.dat",sep='/')
uRfile=paste(Rdatapath,"UniR_fitts.dat",sep='/')
bfile=paste(Rdatapath,"Bi_fitts.dat",sep='/')

#Select analysis to perform
do_summary=TRUE
do_aov=FALSE
do_lme=FALSE
do_lmer=FALSE
do_ANOVA=TRUE
do_CompareANOVA=FALSE
do_barchart=FALSE
do_interaction=FALSE
do_boxplots=FALSE
do_density=FALSE
do_unimanual=FALSE
do_relative=FALSE

#Get size of data tables by preloading
factBiNo <-5
factUniNo<-4
bi <-read.csv(bfile)
uni<-read.csv(uLfile)
colBiNo <-length(bi)
colUniNo<-length(uni)
valBiNo <-colBiNo -factBiNo
valUniNo<-colUniNo-factUniNo
remove(bi)
remove(uni)

#Generate column format vectors
bcolfmt=c(rep("factor",factBiNo ),rep("numeric",valBiNo ),recursive=TRUE)
ucolfmt=c(rep("factor",factUniNo),rep("numeric",valUniNo),recursive=TRUE)

#Load data from csv file
bidata<-read.csv(bfile,colClasses=bcolfmt)
uLdata<-read.csv(uLfile,colClasses=ucolfmt)
uRdata<-read.csv(uRfile,colClasses=ucolfmt)

#Generate relative variables, if requested 
if (do_relative) bidata<-generate.relative.vars(bidata,uLdata,uRdata)


colBiNo_t<-length(bidata)
#bidata$grpeff<-factor(abs(bidata$rho-1)<0.1)
levels(bidata$grp)=c('C','U')
#levels(bidata$grpeff)=c('U','C')
levels(bidata$IDR)=c('D','M','E')
levels(bidata$IDL)=c('D','E')
levels(uLdata$grp)=c('C','U')
levels(uRdata$grp)=c('C','U')
levels(uLdata$ID)=c('D','E')
levels(uRdata$ID)=c('D','M','E')

#Generate the ranges of variables to be analyzed in tables
rangeB<-(factBiNo +1):(colBiNo_t-factBiNo-1)
rangeU<-(factUniNo+1):(colUniNo-factUniNo-1)
densityplots=names(bidata)[rangeB]

#Iterate over all Bimanual variables
#foreach (vname=names(bidata)[rangeB]) %dopar% {
for (vname in names(bidata)[rangeB]) {
    #Create path
    vpath=paste(opath,vname,sep="/")
    dir.create(vpath,showWarnings=FALSE)
    
    print(paste('analyzing variable',vname))
    
    if (do_summary) do.summary(bidata,vname,vpath)
    
    if (do_aov) do.aov(bidata,vname,vpath)
    
    if (do_lme) do.lme(bidata,vname,vpath)
    
    if (do_ANOVA) do.ANOVA(bidata,vname,vpath)
    
    if (do_CompareANOVA) do.compare.ANOVA(bidata,vname,vpath)
    
    if (do_lmer) do.lmer(bidata,vname,vpath)

    if (do_barchart) plot_barcharts(bidata,vname,vpath)
    
    if (do_interaction) plot_interactions(bidata,vname,vpath)
    
    if (do_boxplots) plot_boxplots(bidata,vname,vpath)
    
    #if (do_density && vname %in% densityplots) plot_densityplot(bidata,vname,vpath)
    if (do_density) plot_densityplot(bidata,vname,vpath)
}

if (do_unimanual == FALSE) return

hstr='L'
#foreach (vname=names(uLdata)[rangeU]) %dopar% {
for (vname in names(uLdata)[rangeU]) {
    #Create path
    vpath=paste(opath,vname,sep="/")
    dir.create(vpath,showWarnings=FALSE)
    
    print(paste('analyzing variable',vname))
    
    if (do_summary) do.summary.uni(uLdata,vname,vpath)
    
    if (do_aov) do.aov.uni(uLdata,vname,vpath)
    
    if (do_lme) do.lme.uni(uLdata,vname,vpath)
    
    if (do_ANOVA) do.ANOVA.uni(uLdata,vname,vpath)
    
    if (do_CompareANOVA) do.compare.ANOVA.uni(uLdata,vname,vpath)
    
    if (do_lmer) do.lmer.uni(uLdata,vname,vpath)

    if (do_barchart) plot_barcharts.uni(uLdata,vname,vpath)
    
    if (do_interaction) plot_interactions.uni(uLdata,vname,vpath)
    
    if (do_boxplots) plot_boxplots.uni(uLdata,vname,vpath)
    
    if (do_density && vname %in% densityplots) plot_densityplot.uni(uLdata,vname,vpath)
}

hstr='R'
foreach (vname=names(uRdata)[rangeU]) %dopar% {
#for (vname in names(uRdata)[rangeU]) {
    #Create path
    vpath=paste(opath,vname,sep="/")
    dir.create(vpath,showWarnings=FALSE)
    
    print(paste('analyzing variable',vname))
    
    if (do_summary) do.summary.uni(uRdata,vname,vpath)
    
    if (do_aov) do.aov.uni(uRdata,vname,vpath)
    
    if (do_lme) do.lme.uni(uRdata,vname,vpath)
    
    if (do_ANOVA) do.ANOVA.uni(uRdata,vname,vpath)
    
    if (do_CompareANOVA) do.compare.ANOVA.uni(uRdata,vname,vpath)
    
    if (do_lmer) do.lmer.uni(uRdata,vname,vpath)

    if (do_barchart) plot_barcharts.uni(uRdata,vname,vpath)
    
    if (do_interaction) plot_interactions.uni(uRdata,vname,vpath)
    
    if (do_boxplots) plot_boxplots.uni(uRdata,vname,vpath)
    
    if (do_density && vname %in% densityplots) plot_densityplot.uni(uRdata,vname,vpath)
}
