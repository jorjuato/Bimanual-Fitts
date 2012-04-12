#Analysis of Variance for Bimanual Fitts experiment
source("plot_fcns_bi.R")
source("stat_fcns_bi.R")
source("plot_fcns_uni.R")
source("stat_fcns_uni.R")
# coding scheme for categorical variables matters
# run with dummy coding -> factory default in R, wrong results
options(contrasts=c(unordered="contr.treatment", ordered="contr.poly"))
# effect coding for unordered factors (sum to zero, correct results)
#options(contrasts=c(unordered="contr.sum",       ordered="contr.poly"))

#Prepare global paths
uLfile="./UniL_fitts.dat"
uRfile="./UniR_fitts.dat"
bfile="./Bi_fitts.dat"
opath="./anal"

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

#Globally define format of data files FIXXX


#Load data from csv file
bcolfmt=c("factor","factor","factor","factor","factor",rep("numeric",33),recursive=TRUE)
ucolfmt=c("factor","factor","factor","factor"         ,rep("numeric",13),recursive=TRUE)
bidata<-read.csv(bfile,colClasses=bcolfmt)
uLdata<-read.csv(uLfile,colClasses=ucolfmt)
uRdata<-read.csv(uRfile,colClasses=ucolfmt)
levels(bidata$grp)=c('C','U')
levels(bidata$IDR)=c('D','M','E')
levels(bidata$IDL)=c('D','E')
levels(uLdata$grp)=c('C','U')
levels(uRdata$grp)=c('C','U')
levels(uLdata$ID)=c('D','E')
levels(uRdata$ID)=c('D','M','E')

bidata<-generate.relative.vars(bidata,uLdata,uRdata)
rangeB<-(6:64)
rangeU<-(5:17)
densityplots=names(bidata)[rangeB] #It will plot density plots for all variables


#Iterate over all Bimanual variables
#for (vname in names(bidata)[rangeB]) {
#    #Create path
#    vpath=paste(opath,vname,sep="/")
#    dir.create(vpath,showWarnings=FALSE)
    
#    if (do_aov) do.aov(bidata,vname,vpath)
    
#    if (do_lme) do.lme(bidata,vname,vpath)
    
#    if (do_ANOVA) do.ANOVA(bidata,vname,vpath)
    
#    if (do_CompareANOVA) do.compare.ANOVA(bidata,vname,vpath)
    
#    if (do_lmer) do.lmer(bidata,vname,vpath)

#    if (do_barchart) plot_barcharts(bidata,vname,vpath)
    
#    if (do_interaction) plot_interactions(bidata,vname,vpath)
    
#    if (do_boxplots) plot_boxplots(bidata,vname,vpath)
    
#    if (do_density && vname %in% densityplots) plot_densityplot(bidata,vname,vpath)
#}

#Iterate over all variables for unimanual Right
for (udata in c(uLdata,uRdata)) {
    if (legnth(levels(udata$ID))==2)
        hstr='L'
    else
        hstr='R'
    next    
    for (vname in names(udata)[rangeU]) {
        #Create path
        vpath=paste(opath,vname,sep="/")
        dir.create(vpath,showWarnings=FALSE)
        
        if (do_aov) do.aov.uni(udata,vname,vpath,hstr)
        
        if (do_lme) do.lme.uni(udata,vname,vpath,hstr)
        
        if (do_ANOVA) do.ANOVA.uni(udata,vname,vpath,hstr)
        
        if (do_CompareANOVA) do.compare.ANOVA.uni(udata,vname,vpath,hstr)
        
        if (do_lmer) do.lmer.uni(udata,vname,vpath,hstr)

        if (do_barchart) plot_barcharts.uni(udata,vname,vpath,hstr)
        
        if (do_interaction) plot_interactions.uni(udata,vname,vpath,hstr)
        
        if (do_boxplots) plot_boxplots.uni(udata,vname,vpath,hstr)
        
        if (do_density && vname %in% densityplots) plot_densityplot.uni(udata,vname,vpath,hstr)
    }
}
