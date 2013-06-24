#Analysis of Variance for Bimanual Fitts experiment
require(doMC)
source("aux_fcns.R")
source("plot_fcns_bi.R")
source("stat_fcns_bi.R")
source("plot_fcns_bi_did.R")
source("stat_fcns_bi_did.R")
source("plot_fcns_uni.R")
source("stat_fcns_uni.R")
registerDoMC()

#Prepare global paths
rootpath='/home/jorge/Dropbox/dev/Bimanual-Fitts/R'
Rname='refactor'
opath=paste(paste(rootpath,"stats",sep='/'),Rname,sep='/')
dir.create(opath,showWarnings=FALSE)
Rdatapath=paste(paste(rootpath,'dataframes',sep='/'),Rname,sep='/')
uLfile=paste(Rdatapath,"UniL_fitts.dat",sep='/')
uRfile=paste(Rdatapath,"UniR_fitts.dat",sep='/')
bfile=paste(Rdatapath,"Bi_fitts.dat",sep='/')
bdfile=paste(Rdatapath,"BiDelta_fitts.dat",sep='/')
#Select analysis to perform
do_bimanualDelta=TRUE
do_bimanual=TRUE
do_unimanual=TRUE
do_relative=TRUE
do_parallel=TRUE

do_summary=TRUE
do_aov=FALSE
do_lme=FALSE
do_lmer=FALSE
do_lmer_tukey=FALSE
do_ANOVA=TRUE
do_CompareANOVA=TRUE

do_barchart=FALSE
do_interaction=FALSE
do_boxplots=FALSE
do_density=FALSE

#Get size of data tables by preloading
factBiNo <-5
factUniNo<-4
bi <-read.csv(bfile)
bid <-read.csv(bdfile)
uni<-read.csv(uLfile)
colBiNo <-length(bi)
colBiDidNo <-length(bid)
colUniNo<-length(uni)
valBiNo <-colBiNo -factBiNo
valBiDidNo<-colBiDidNo - factUniNo
valUniNo<-colUniNo-factUniNo
remove(bi)
remove(bid)
remove(uni)

#Generate column format vectors
bcolfmt=c(rep("factor",factBiNo ),rep("numeric",valBiNo ),recursive=TRUE)
bdcolfmt=c(rep("factor",factUniNo ),rep("numeric",valBiDidNo ),recursive=TRUE)
ucolfmt=c(rep("factor",factUniNo),rep("numeric",valUniNo),recursive=TRUE)

#Load data from csv file
bidata<-read.csv(bfile,colClasses=bcolfmt)
biddata<-read.csv(bdfile,colClasses=bdcolfmt)
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

colBiDidNo_t<-length(biddata)
levels(biddata$grp)=c('C','U')
#levels(biddata$DID)=c('-2','-1','0-','1','2','0+')

#Generate the ranges of variables to be analyzed in tables
rangeB<-(factBiNo +1):(colBiNo_t)
rangeBd<-(factUniNo+1):(colBiDidNo)
rangeU<-(factUniNo+1):(colUniNo)
densityplots=names(bidata)[rangeB]

if (do_bimanual == TRUE) {
	if (do_parallel==TRUE) {
		foreach (vname=names(bidata)[rangeB]) %dopar% {
			vpath=paste(opath,vname,sep="/")
			dir.create(vpath,showWarnings=FALSE)
			print(paste('analyzing bimanual variable',vname))	
			bimanual_fcns(bidata,vname,vpath)
		}
	}
	else {
		for (vname in names(bidata)[rangeB]) {
			vpath=paste(opath,vname,sep="/")
			dir.create(vpath,showWarnings=FALSE)
			print(paste('analyzing bimanual variable',vname))	
			bimanual_fcns(bidata,vname,vpath)
		}	
	}
	
}

if (do_bimanualDelta == TRUE) {
	if (do_parallel==TRUE) {
		foreach (vname=names(biddata)[rangeBd]) %dopar% {
			vpath=paste(opath,paste('DID_',vname,sep=""),sep="/")
			dir.create(vpath,showWarnings=FALSE)
			print(paste('analyzing Delta ID bimanual variable',vname))	
			bimanualDelta_fcns(biddata,vname,vpath)
		}
	}
	else {
		for (vname in names(biddata)[rangeBd]) {
			vpath=paste(opath,paste('DID_',vname,sep=""),sep="/")
			dir.create(vpath,showWarnings=FALSE)
			print(paste('analyzing Delta ID bimanual variable',vname))	
			bimanualDelta_fcns(biddata,vname,vpath)
		}	
	}
	
}


if (do_unimanual == TRUE) {
	if (do_parallel==TRUE) {
		foreach (vname=names(uLdata)[rangeU]) %dopar% {
			vtrans=paste('UniL',vname,sep="")
			vpath=paste(opath,vtrans,sep="/")
			dir.create(vpath,showWarnings=FALSE)
			print(paste('analyzing Left unimanual variable',vname))
			unimanual_fcns(uLdata,vname,vpath)
		}
		foreach (vname=names(uRdata)[rangeU]) %dopar% {		
			vtrans=paste('UniR',vname,sep="")
			vpath=paste(opath,vtrans,sep="/")
			dir.create(vpath,showWarnings=FALSE)
			print(paste('analyzing Right unimanual variable',vname))
			unimanual_fcns(uRdata,vname,vpath)		
		}
	}
	else {
		for (vname in names(uLdata)[rangeU]) {
			vtrans=paste('UniL',vname,sep="")
			vpath=paste(opath,vtrans,sep="/")
			dir.create(vpath,showWarnings=FALSE)
			print(paste('analyzing Left unimanual variable',vname))
			unimanual_fcns(uLdata,vname,vpath)
		}
		for (vname in names(uRdata)[rangeU]) {
			vtrans=paste('UniR',vname,sep="")
			vpath=paste(opath,vtrans,sep="/")
			dir.create(vpath,showWarnings=FALSE)
			print(paste('analyzing Right unimanual variable',vname))
			unimanual_fcns(uRdata,vname,vpath)		
		}
	}
}	



