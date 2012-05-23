#Analysis of Variance for Bimanual Fitts experiment
require(doMC)
source("plot_fcns_bi.R")
source("stat_fcns_bi.R")
source("plot_fcns_uni.R")
source("stat_fcns_uni.R")
registerDoMC()

#Prepare global paths
rootpath='/home/jorge/KINARM'
Rname='4th'
opath=paste(paste(rootpath,"stats",sep='/'),Rname,sep='/')
Rdatapath=paste(paste(rootpath,'Rdata',sep='/'),Rname,sep='/')
uLfile=paste(Rdatapath,"UniL_fitts.dat",sep='/')
uRfile=paste(Rdatapath,"UniR_fitts.dat",sep='/')
bfile=paste(Rdatapath,"Bi_fitts.dat",sep='/')

#Select analysis to perform
do_aov=FALSE
do_lme=FALSE
do_lmer=FALSE
do_ANOVA=TRUE
do_CompareANOVA=TRUE
do_barchart=TRUE
do_interaction=TRUE
do_boxplots=TRUE
do_density=TRUE

#Load data from csv file
bcolfmt=c("factor","factor","factor","factor","factor",rep("numeric",33),recursive=TRUE)
ucolfmt=c("factor","factor","factor","factor"         ,rep("numeric",13),recursive=TRUE)
bidata<-read.csv(bfile,colClasses=bcolfmt)
uLdata<-read.csv(uLfile,colClasses=ucolfmt)
uRdata<-read.csv(uRfile,colClasses=ucolfmt)
bidata<-generate.relative.vars(bidata,uLdata,uRdata)
levels(bidata$grp)=c('C','U')
levels(bidata$IDR)=c('D','M','E')
levels(bidata$IDL)=c('D','E')
levels(uLdata$grp)=c('C','U')
levels(uRdata$grp)=c('C','U')
levels(uLdata$ID)=c('D','E')
levels(uRdata$ID)=c('D','M','E')
rangeB<-(6:64)
rangeU<-(5:17)
densityplots=names(bidata)[rangeB]

#Iterate over all Bimanual variables
foreach (vname=names(bidata)[rangeB]) %dopar% {
#for (vname in names(bidata)[rangeB]) {
    #Create path
    vpath=paste(opath,vname,sep="/")
    dir.create(vpath,showWarnings=FALSE)
    
    print(paste('analyzing variable',vname))
    
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

hstr='L'
foreach (vname=names(uLdata)[rangeU]) %dopar% {
#for (vname in names(uLdata)[rangeU]) {
    #Create path
    vpath=paste(opath,vname,sep="/")
    dir.create(vpath,showWarnings=FALSE)
    
    print(paste('analyzing variable',vname))
    
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
