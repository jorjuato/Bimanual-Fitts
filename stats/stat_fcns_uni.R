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
    sink(paste(vpath,'aov_uni.out',sep="/"))
    aov.mod<-aov(get(vname)~(S*ID*grp)+Error(pp/(S*ID))+grp,mdata)
    print(summary(aov.mod))
    drop1(aov.mod,~.,test="F") # type III SS and F Tests 
    #print(anova(aov.mod))
    sink()

    #Perform Tukey post-hoc comparisons on aov
    sink(paste(vpath,'aov_uni_tukey.out',sep="/"))
    print("Group Tukey test")
    print(summary(glht(aov.mod,linfct=mcp(grp= "Tukey"))))
    print("Session Tukey test")
    print(summary(glht(aov.mod,linfct=mcp(S= "Tukey"))))
    print("IDR Tukey test")
    print(summary(glht(aov.mod,linfct=mcp(IDL= "Tukey"))))
    print("IDL Tukey test")
    print(summary(glht(aov.mod,linfct=mcp(IDR= "Tukey"))))
    sink()
}


do.lme.uni <- function(mdata,vname,vpath){
    #Perform lme    
    sink(paste(vpath,'lme_uni.out',sep="/"))
    lme.mod<-lme(get(vname)~S+ID+grp, random = ~ 1 | pp / (S+ID),mdata)
    print(summary(lme.mod))
    print(summary(Anova(lme.mod)))
    sink()
    
    #Perform Tukey post-hoc comparisons on lmer
    sink(paste(vpath,'lme_uni_tukey.out',sep="/"))
    print("Group Tukey test")
    print(summary(glht(lme.mod,linfct=mcp(grp= "Tukey"))))
    print("Session Tukey test")
    print(summary(glht(lme.mod,linfct=mcp(S= "Tukey"))))
    print("IDR Tukey test")
    print(summary(glht(lme.mod,linfct=mcp(IDL= "Tukey"))))
    print("IDL Tukey test")
    print(summary(glht(lme.mod,linfct=mcp(IDR= "Tukey"))))
    #print(TukeyHSD(lme.mod))
    sink()
}

do.ANOVA.uni <- function(mdata,vname,vpath){
    #Perform type III Repeated Measures 5-WAY ANOVA with mixed within and between design     
    sink(paste(vpath,'anova_uni.out',sep="/"))
    ez.mod<-ezANOVA(data=mdata,dv=as.name(vname),wid=.(pp), within=.(S,ID),between=.(grp),type=3)
    print(paste(vname,"~(S*ID*grp)+Error(pp/(S*ID))+grp"))
    print(ez.mod)
    sink()
}

do.compare.ANOVA.uni <- function(mdata,vname,vpath){       
    full.mod<-lmer(get(vname) ~ (1|pp) + (1|pp/S) + (1|pp/ID) + (1|pp/S:ID) + S+ID+grp,mdata)
    noS.mod<-lmer(get(vname) ~ (1|pp) + ID+grp,mdata)
    nogrp.mod<-lmer(get(vname) ~ (1|pp) + S+ID,mdata)
    noSgrp.mod<-lmer(get(vname) ~ (1|pp) + ID,mdata)
    
    sink(paste(vpath,'compare_anova_uni.out',sep="/"))
    an1<-anova(full.mod,noS.mod)
    print("Full vs no Session")
    #print(summary(an1))
    print(an1)
    an2<-anova(full.mod,nogrp.mod)
    print("Full vs no Group")
    #print(summary(an2))
    print(an2)
    an3<-anova(full.mod,noSgrp.mod)
    print("Full vs no Session and no Group")
    #print(summary(an3))
    print(an3)
    an4<-anova(nogrp.mod,noSgrp.mod)
    print("No Group vs no Session and no Group")
    #print(summary(an4))
    print(an4)
    an5<-anova(noS.mod,noSgrp.mod)
    print("No Session vs no Session and no Group")
    #print(summary(an5))
    print(an5)
    sink()
}

do.lmer.uni <- function(mdata,vname,vpath){
    #Linear Mixed Model effects, using lmer
    sink(paste(vpath,'lmer_uni.out',sep="/"))
    #lmer.mod <- lmer(get(vname)~S*IDR*IDL*grp + (1|pp) + (1|pp:grp) + (1|pp:S), data=mdata)
    lmer.mod <- lmer(get(vname) ~ (1|pp) + grp*S*ID, data=mdata)
    mcmc=pvals.fnc(lmer.mod,nsim=1000)
    print(mcmc$fixed)
    print(summary(anova(lmer.mod)))
    print(summary(lmer.mod))
    print(lmer.mod)
    sink()

    #Perform Tukey post-hoc comparisons on lmer
    sink(paste(vpath,'lmer_tukey_uni.out',sep="/"))
    K <- cbind(0,diag(length(fixef(lmer.mod))))
    rownames(K) <- names(fixef(lmer.mod))
    print(summary(glht(lmer.mod,linfct=K)))
    sink()
#        print("Group Tukey test")
#        print(summary(glht(lmer.mod,linfct=mcp(grp= "Tukey"))))
#        print("Session Tukey test")
#        print(summary(glht(lmer.mod,linfct=mcp(S= "Tukey"))))
#        print("IDR Tukey test")
#        print(summary(glht(lmer.mod,linfct=mcp(IDL= "Tukey"))))
#        print("IDL Tukey test")
#        print(summary(glht(lmer.mod,linfct=mcp(IDR= "Tukey"))))
#        sink()
}
