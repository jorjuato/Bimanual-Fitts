#Analysis of Variance for Bimanual Fitts experiment
source("plot_fcns.R")
source("stat_fcns.R")

# coding scheme for categorical variables matters
# run with dummy coding -> factory default in R, wrong results
options(contrasts=c(unordered="contr.treatment", ordered="contr.poly"))
# effect coding for unordered factors (sum to zero, correct results)
#options(contrasts=c(unordered="contr.sum",       ordered="contr.poly"))

#Prepare global paths
dfile="./fitts.dat"
opath="./anal"

#Select analysis to perform
do_aov=FALSE
do_lme=FALSE
do_lmer=FALSE
do_ANOVA=FALSE
do_CompareANOVA=FALSE
do_barchart=TRUE
do_interaction=TRUE
do_boxplots=TRUE
do_density=TRUE

#Globally define format of data files FIXXX


#Load data from csv file
colfmt=c("factor","factor","factor","factor","factor",rep("numeric",31),recursive=TRUE)
mdata<-read.csv(dfile,colClasses=colfmt)
levels(mdata$grp)=c('C','U')
levels(mdata$IDR)=c('D','M','E')
levels(mdata$IDL)=c('D','E')
mdata<-generate.relative.vars(mdata)

densityplots=names(mdata)[6:36] #It will plot density plots for all variables


#Iterate over all variables
for (vname in names(mdata)[6:36]) {
    #Create path
    vpath=paste(opath,vname,sep="/")
    dir.create(vpath,showWarnings=FALSE)
    
    if (do_aov) do.aov(mdata,vname,vpath)
    
    if (do_lme) do.lme(mdata,vname,vpath)
    
    if (do_ANOVA) do.ANOVA(mdata,vname,vpath)
    
    if (do_CompareANOVA) do.Compare.ANOVA(mdata,vname,vpath)
    
    if (do_lmer) do.lmer(mdata,vname,vpath)

    if (do_barchart) plot_barcharts(mdata,vname,vpath)
    
    if (do_interaction) plot_interactions(mdata,vname,vpath)
    
    if (do_boxplots) plot_boxplots(mdata,vname,vpath)
    
    if (do_density && vname %in% densityplots) plot_densityplot(mdata,vname,vpath)

}
