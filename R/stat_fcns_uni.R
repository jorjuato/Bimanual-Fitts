require(multcomp)
require(nlme)
require(lme4)
require(ez)
require(doBy)

# coding scheme for categorical variables matters
# run with dummy coding -> factory default in R, wrong results
#options(contrasts=c(unordered="contr.treatment", ordered="contr.poly"))
# effect coding for unordered factors (sum to zero, correct results)
options(contrasts=c(unordered="contr.sum",ordered="contr.poly"))

do.summary.uni <- function(mdata,vname,vpath){
    statfcn = function(x) { c(m = mean(x), s = sd(x)) }
    sink(paste(vpath,'summary.out',sep="/"))
    
    print("Summary by group")
    form<-as.formula(paste(vname,"~ grp"))
    print(summaryBy(form, mdata,FUN=statfcn))
    
    print("Summary by session\n")
    form<-as.formula(paste(vname,"~ S"))
    print(summaryBy(form, mdata,FUN=statfcn))
    
    print("Summary by ID\n")
    form<-as.formula(paste(vname,"~ ID"))
    print(summaryBy(form, mdata,FUN=statfcn))
    
    print("Summary by group + Session\n")
    form<-as.formula(paste(vname,"~ grp + S"))
    print(summaryBy(form, mdata,FUN=statfcn))
    
    print("Summary by Session + ID\n")
    form<-as.formula(paste(vname,"~ S + ID"))
    print(summaryBy(form, mdata,FUN=statfcn))
    
    print("Summary by group + ID\n")
    form<-as.formula(paste(vname,"~ grp + ID"))
    print(summaryBy(form, mdata,FUN=statfcn))
    
    print("Summary by group + Session + ID\n")
    form<-as.formula(paste(vname,"~ grp + S + ID"))
    print(summaryBy(form, mdata,FUN=statfcn))
    
    sink()
}

do.aov.uni <- function(mdata,vname,vpath){
    #Repeated Measures 5-WAY ANOVA with mixed within and between design, Type III SSE
    form<-sprintf('aov.mod<-aov( %s ~ S*ID*grp + Error(pp/(S*ID)), mdata)', vname)
    sink(paste(vpath,'aov_uni.out',sep="/"))
    eval(parse(text=form))
    #drop1(aov.mod,~.,test="F") # type III SS and F Tests 
    print(summary(aov.mod))
    sink()
}


do.lme.uni <- function(mdata,vname,vpath){
    #Perform lme    
    form<-sprintf('lme.mod<-lme(%s~S+ID+grp, random = ~ 1 | pp,mdata)',vname)
    sink(paste(vpath,'lme_uni.out',sep="/"))    
    eval(parse(text=form))
    print(summary(lme.mod))
    print(anova(lme.mod,type="marginal"))
    sink()
    
    #Perform Tukey post-hoc comparisons on lme
    sink(paste(vpath,'lme_tukey.out',sep="/"))
    print("grp Tukey test")
    print(summary(glht(lme.mod,linfct=mcp(grp= "Tukey"))))
    print("S Tukey test")
    print(summary(glht(lme.mod,linfct=mcp(S= "Tukey"))))
    print("ID Tukey test")
    print(summary(glht(lme.mod,linfct=mcp(ID= "Tukey"))))
    sink()
}

do.ANOVA.uni <- function(mdata,vname,vpath){
    #Perform type III Repeated Measures 5-WAY ANOVA with mixed within and between design
    form<-sprintf('ez.mod = ezANOVA(data=mdata,dv=.(%s),wid=.(pp), within=.(S,ID),between=.(grp),type=3, return_aov=FALSE)',vname)
    sink(paste(vpath,'anova.out',sep="/"))
    eval(parse(text=form))
    print(paste(vname,"~(S*ID*grp)+Error(pp/(S*ID))+grp"))
    print(ez.mod)
    sink()
}

do.compare.ANOVA.uni <- function(mdata,vname,vpath){       
    full.mod<-lmer(  get(vname) ~ (1|pp) + (1|pp/ID) + (1|pp/S) + (1|pp/S:ID) + S + ID + grp, mdata)
    nogrp.mod<-lmer( get(vname) ~ (1|pp) + (1|pp/ID) + (1|pp/S) + (1|pp/S:ID) + S + ID, mdata)
    noS.mod<-lmer(   get(vname) ~ (1|pp) + (1|pp/ID) + ID + grp, mdata)
    noSgrp.mod<-lmer(get(vname) ~ (1|pp) + (1|pp/ID) + ID, mdata)
    
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

do.lmer.uni <- function(mdata,vname,vpath){
    #Linear Mixed Model effects, using lmer
    form<-sprintf('lmer.mod <- lmer( %s ~ (1|pp) + (1|pp/S) + (1|pp/ID) + (1|pp/S:ID) +  grp*S*ID, data=mdata)',vname)
    sink(paste(vpath,'lmer.out',sep="/"))
    eval(parse(text=form))
    mcmc=pvals.fnc(lmer.mod,nsim=1000)
    print(mcmc$fixed)
    print(anova(lmer.mod))
    print(summary(lmer.mod))
    print(lmer.mod)
    sink()
}

do.lmer.uni.tukey <- function(mdata,vname,vpath){
    #Linear Mixed Model effects, using lmer
    form<-sprintf('lmer.mod <- lmer( %s ~ (1|pp) + (1|pp/S) + (1|pp/ID) + (1|pp/S:ID) +  grp*S*ID, data=mdata)',vname)
    sink(paste(vpath,'lmer_tukey.out',sep="/"))
    eval(parse(text=form))
    
    #Perform Tukey post-hoc comparisons on lmer
    print("ID Tukey test")
    print(summary(glht(lmer.mod,linfct=mcp(ID="Tukey",interaction_average=TRUE))))
    print("S Tukey test")
    print(summary(glht(lmer.mod,linfct=mcp(S="Tukey",interaction_average=TRUE))))
    print("grp Tukey test")
    print(summary(glht(lmer.mod,linfct=mcp(grp="Tukey",interaction_average=TRUE))))
    sink()
}
