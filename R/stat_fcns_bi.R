require(multcomp)
require(nlme)
require(lme4)
require(languageR)
require(ez)
require(doBy)
require(stats)

# coding scheme for categorical variables matters
# run with dummy coding -> factory default in R, wrong results
#options(contrasts=c(unordered="contr.treatment", ordered="contr.poly"))
# effect coding for unordered factors (sum to zero, correct results)
options(contrasts=c(unordered="contr.sum",ordered="contr.poly"))


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

do.summary <- function(mdata,vname,vpath){
    statfcn <- function(x) { c(m = mean(x), s = sd(x)) } 
    sink(paste(vpath,'summary.out',sep="/"))
    print("Summary by group")
    form<-as.formula(paste(vname,"~ grp"))
    print(summaryBy(form, mdata,FUN=statfcn))
    #print("Summary by effective group")
    #form<-as.formula(paste(vname,"~ grpeff"))
    #print(summaryBy(form, mdata,FUN=statfcn))    
    print("Summary by session\n")
    form<-as.formula(paste(vname,"~ S"))
    print(summaryBy(form, mdata,FUN=statfcn))
    print("Summary by IDR+IDR\n")
    form<-as.formula(paste(vname,"~ IDL + IDR"))
    print(summaryBy(form, mdata,FUN=statfcn))
    print("Summary by group + Session\n")
    form<-as.formula(paste(vname,"~ grp + S"))
    print(summaryBy(form, mdata,FUN=statfcn))
    #print("Summary by effective group + Session\n")
    #form<-as.formula(paste(vname,"~ grpeff + S"))
    #print(summaryBy(form, mdata,FUN=statfcn))    
    print("Summary by Session + IDR + IDL \n")
    form<-as.formula(paste(vname,"~ S + IDL + IDR"))
    print(summaryBy(form, mdata,FUN=statfcn))
    print("Summary by group + IDR + IDL\n")
    form<-as.formula(paste(vname,"~ grp + IDL + IDR"))
    print(summaryBy(form, mdata,FUN=statfcn))
    #print("Summary by effective group + IDR + IDL\n")
    #form<-as.formula(paste(vname,"~ grpeff + IDL + IDR"))
    #print(summaryBy(form, mdata,FUN=statfcn))
    print("Summary by group + Session + IDR + IDL\n")
    form<-as.formula(paste(vname,"~ grp + S + IDL + IDR"))
    print(summaryBy(form, mdata,FUN=statfcn))
    #print("Summary by effective group + Session + IDR + IDL\n")
    #form<-as.formula(paste(vname,"~ grpeff + S + IDL + IDR"))
    #print(summaryBy(form, mdata,FUN=statfcn))
    sink()
}

do.aov <- function(mdata,vname,vpath){
    #Repeated Measures 5-WAY ANOVA with mixed within and between design, Type III SSE 
    form<-sprintf('aov.mod<-aov(%s~(S*IDR*IDL*grp)+Error(pp/(S*IDR*IDL)),mdata)',vname)
    sink(paste(vpath,'aov.out',sep="/"))    
    eval(parse(text=form))
    print("Repeated Measures 4-WAY ANOVA with within subject design, Type III SSE ")
    #drop1(aov.mod,test="F") # type III SS and F Tests 
    print(summary(aov.mod))
    sink()
}

do.lme <- function(mdata,vname,vpath){
    #Perform lme
    form<-sprintf('lme.mod<-lme(%s~S+IDR+IDL+grp, random = ~ 1 | pp, mdata)',vname)  
    sink(paste(vpath,'lme.out',sep="/"))
    eval(parse(text=form))
    print(summary(lme.mod))
    print(anova(lme.mod,type="marginal"))
    sink()
    
    #Perform Tukey post-hoc comparisons on lmer
    sink(paste(vpath,'lme_tukey.out',sep="/"))
    print("grp Tukey test")
    print(summary(glht(lme.mod,linfct=mcp(grp= "Tukey"))))
    print("S Tukey test")
    print(summary(glht(lme.mod,linfct=mcp(S= "Tukey"))))
    print("IDR Tukey test")
    print(summary(glht(lme.mod,linfct=mcp(IDL= "Tukey"))))
    print("IDL Tukey test")
    print(summary(glht(lme.mod,linfct=mcp(IDR= "Tukey"))))
    sink()
}

do.ANOVA <- function(mdata,vname,vpath){
    #Perform type III Repeated Measures 5-WAY ANOVA with mixed within and between design
    form<-sprintf('ez.mod = ezANOVA(data=mdata,dv=.(%s),wid=.(pp), within=.(S,IDR,IDL),between=.(grp),type=3, return_aov=FALSE)',vname)
    sink(paste(vpath,'anova.out',sep="/"))
    #cat("Repeated Measures 5-WAY ANOVA with mixed within and between design, Type III SSE ")
    eval(parse(text=form))
    print(paste(vname,"~S*IDR*IDL*grp + Error(pp/(S*IDR*IDL))"))
    print(ez.mod)
    sink()
    
    #Perform Tukey post-hoc comparisons
    sink(paste(vpath,'ez_bonferroni.out',sep="/"))
    cat("Post-hoc Tukey comparisons")
    
    print("grp Tukey test")
    form<-sprintf('pair.bon<-pairwise.t.test(mdata$%s, mdata$grp, paired = TRUE, p.adjust.method = "bonferroni")',vname)
    eval(parse(text=form))
    print(pair.bon)
    
    print("S Tukey test")
    form<-sprintf('pair.bon<-pairwise.t.test(mdata$%s, mdata$S, paired = TRUE, p.adjust.method = "bonferroni")',vname)
    eval(parse(text=form))
    print(pair.bon)
    
    print("IDR Tukey test")
    form<-sprintf('pair.bon<-pairwise.t.test(mdata$%s, mdata$IDR, paired = TRUE, p.adjust.method = "bonferroni")',vname)
    eval(parse(text=form))
    print(pair.bon)
    
    print("IDL Tukey test")
    form<-sprintf('pair.bon<-pairwise.t.test(mdata$%s, mdata$IDL, paired = TRUE, p.adjust.method = "bonferroni")',vname)
    eval(parse(text=form))
    sink()
}

do.compare.ANOVA <- function(mdata,vname,vpath){       
    full.mod<-lmer(  get(vname) ~ (1|pp) + (1|pp/S) + (1|pp/IDR) + (1|pp/IDL) + (1|pp/IDR:IDL) + (1|pp/S:IDR:IDL) + S*IDR*IDL*grp, mdata)
    nogrp.mod<-lmer( get(vname) ~ (1|pp) + (1|pp/S) + (1|pp/IDR) + (1|pp/IDL) + (1|pp/IDR:IDL) + (1|pp/S:IDR:IDL) + S*IDR*IDL, mdata)
    noS.mod<-lmer(   get(vname) ~ (1|pp) + (1|pp/IDR) + (1|pp/IDL) + (1|pp/IDR:IDL) + IDR*IDL*grp, mdata)
    noSgrp.mod<-lmer(get(vname) ~ (1|pp) + (1|pp/IDR) + (1|pp/IDL) + (1|pp/IDR:IDL) + IDR*IDL, mdata)
    
    sink(paste(vpath,'compare_anova.out',sep="/"))
    
    print("Full vs no Session")
    print(anova(full.mod,noS.mod))
    
    print("Full vs no Group")
    print(anova(full.mod,nogrp.mod))
    
    print("Full vs no Session and no Group")
    print(anova(full.mod,noSgrp.mod))    
    
    print("No Group vs no Session and no Group")
    print(anova(nogrp.mod,noSgrp.mod))
    
    print("No Session vs no Session and no Group")
    print(anova(noS.mod,noSgrp.mod))

    sink()
}

do.lmer <- function(mdata,vname,vpath){
    #Linear Mixed Model effects, using lmer
    sink(paste(vpath,'lmer.out',sep="/"))
    lmer.mod <- lmer(get(vname) ~ (1|pp) + (1|pp/S) + (1|pp/IDR) + (1|pp/IDL) + (1|pp/S:IDR:IDL) + grp*S*IDR*IDL, data=mdata)
    mcmc=pvals.fnc(lmer.mod,nsim=1000)
    print(mcmc$fixed)
    print(mcmc$ranef)
    print(summary(mcmc))
    print(anova(lmer.mod))
    print(summary(lmer.mod))
    sink()
}

do.lmer.tukey <- function(mdata,vname,vpath){
    #Linear Mixed Model effects, using lmer
    sink(paste(vpath,'lmer_tukey.out',sep="/"))
    #lmer.mod <- lmer(get(vname) ~ (1|pp) + (1|pp/grp) + (1|pp/S) + (1|pp/IDR) + (1|pp/IDL) + (1|pp/grp:S) + (1|pp/grp:IDR) + (1|pp/S:IDR:IDL) +(1|pp/S:IDR:IDL) + grp*S*IDR*IDL, data=mdata)
    lmer.mod <- lmer(get(vname) ~ (1|pp) + (1|pp/grp) + (1|pp/S) + (1|pp/IDR) + (1|pp/IDL) + (1|pp/S:IDR:IDL) + grp*S*IDR*IDL, data=mdata)

    #Perform Tukey post-hoc comparisons on lmer    
    print("IDR Tukey test")
    print(summary(glht(lmer.mod,linfct=mcp(IDR="Tukey",interaction_average=TRUE))))
    print("IDL Tukey test")
    print(summary(glht(lmer.mod,linfct=mcp(IDL="Tukey",interaction_average=TRUE))))
    print("S Tukey test")
    print(summary(glht(lmer.mod,linfct=mcp(S="Tukey",interaction_average=TRUE))))
    print("grp Tukey test")
    print(summary(glht(lmer.mod,linfct=mcp(grp="Tukey",interaction_average=TRUE))))
    
    #Use interaction factors...    
#    mdata$gS <- interaction(mdata$grp, mdata$S)
#    mdata$gR <- interaction(mdata$grp, mdata$IDR)
#    mdata$gL <- interaction(mdata$grp, mdata$IDL)
#    mdata$SR <- interaction(mdata$S, mdata$IDR)
#    mdata$SL <- interaction(mdata$S, mdata$IDL)
#    mdata$IDLR <- interaction(mdata$IDR, mdata$IDL)
#    mdata$gSR <- interaction(mdata$grp, mdata$S, mdata$IDR)
#    mdata$gSL <- interaction(mdata$grp, mdata$S, mdata$IDL)
#    mdata$SLR <- interaction(mdata$S, mdata$IDR, mdata$IDL)
#    mdata$gSLR <- interaction(mdata$grp, mdata$S, mdata$IDR, mdata$IDL)
    
#    print(summary(glht(lmer.mod,linfct=mcp(gS="Tukey"))))
#    print(summary(glht(lmer.mod,linfct=mcp(gR="Tukey"))))
#    print(summary(glht(lmer.mod,linfct=mcp(gL="Tukey"))))
#    print(summary(glht(lmer.mod,linfct=mcp(SR="Tukey"))))
#    print(summary(glht(lmer.mod,linfct=mcp(SL="Tukey"))))
#    print(summary(glht(lmer.mod,linfct=mcp(IDLR="Tukey"))))
#    print(summary(glht(lmer.mod,linfct=mcp(gSR="Tukey"))))
#    print(summary(glht(lmer.mod,linfct=mcp(gSL="Tukey"))))
#    print(summary(glht(lmer.mod,linfct=mcp(SLR="Tukey"))))    
#    print(summary(glht(lmer.mod,linfct=mcp(gSLR="Tukey"))))

    sink()
    
    #Other methods    
    #Define matrix of coeficients
    #K <- cbind(0,diag(length(fixef(lmer.mod))))
    #rownames(K) <- names(fixef(lmer.mod))
    #print(summary(glht(lmer.mod,linfct=K)))
    

    

}
