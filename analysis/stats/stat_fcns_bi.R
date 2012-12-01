require(multcomp)
require(nlme)
require(lme4)
require(ez)
require(doBy)

# coding scheme for categorical variables matters
# run with dummy coding -> factory default in R, wrong results
#options(contrasts=c(unordered="contr.treatment", ordered="contr.poly"))
# effect coding for unordered factors (sum to zero, correct results)
#options(contrasts=c(unordered="contr.sum",ordered="contr.poly"))


generate.relative.vars <- function(bidata,uLdata,uRdata){
    #DISCARDED: "Rf" "rho" "phDiffStd" "phDiffMean"   "flsPC" "Lf" "flsAmp" "Lf","Rf",
    #PROBLEMATIC  ,
    vnames=c("accTimeL", "accTimeR", "accQR", "decTimeL", "accQL", "decTimeR",
             "circularityR", "circularityL", "maxangleR", "maxangleL",
             "q1L", "q1R", "q2L", "q2R", "q3L", "q3R", "q4L","q4R",
             "IPerfEfL", "IPerfL",  "IPerfEfR", "IPerfR", 
             "MTR", "MTL", "peakVelR", "peakVelL")
             
    foreach (vname=vnames) %dopar% {    
        hand<-substr(vname, nchar(vname), nchar(vname))
        for (i in 1:nrow(bidata)) {            
            pp <- as.numeric(bidata[i,'pp'])            
            S <- as.numeric(levels(bidata$S)[bidata[i,'S']])
            ID<- as.numeric(bidata[i,paste('ID',hand,sep='')])
            if (hand=='R')
                form="val<-mean(uRdata$U%s[uRdata$pp==%d & uRdata$S==%d & uRdata$ID==%d])"
            else
                form="val<-mean(uLdata$U%s[uLdata$pp==%d & uLdata$S==%d & uLdata$ID==%d])"
            eval(parse(text=sprintf(form,vname,pp,S,ID)))
            eval(parse(text=sprintf("bidata$%srel[[i]]<-bidata$%s[[i]]/val",vname,vname)))
        }
    }
    #bidata$MTBiAll<-bidata$MTL+bidata$MTR
    #bidata$MTUniAll<-uLdata$UMT+uRdata$UMT
    #bidata$MTAllRel<-bidata$MTBiAll+bidata$MTUniAll
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
    sink(paste(vpath,'aov.out',sep="/"))
#    print("Repeated Measures 5-WAY ANOVA with mixed within and between design, Type III SSE ")
#    aov.mod<-aov(get(vname)~(S*IDR*IDL*grp)+Error(pp/(S*IDR*IDL))+grp,mdata)
#    print(summary(aov.mod))
#    drop1(aov.mod,test="F") # type III SS and F Tests 
#    print(anova(aov.mod))
    
    print("Repeated Measures 5-WAY ANOVA with within subject design, Type III SSE ")
    aov.mod<-aov(get(vname)~(S*IDR*IDL*grp)+Error(pp/(S*IDR*IDL*grp)),mdata)
    print(summary(aov.mod))
    drop1(aov.mod,test="F") # type III SS and F Tests 
    print(anova(aov.mod))
    sink()

    #Perform Tukey post-hoc comparisons on aov
    sink(paste(vpath,'aov.tukey.out',sep="/"))
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

do.lme <- function(mdata,vname,vpath){
    #Perform lme    
    sink(paste(vpath,'lme.out',sep="/"))
    lme.mod<-lme(get(vname)~S+IDR+IDL+grp, random = ~ 1 | pp / (S+IDR+IDL),mdata)
    print(summary(lme.mod))
    print(summary(Anova(lme.mod)))
    sink()
    
    #Perform Tukey post-hoc comparisons on lmer
    sink(paste(vpath,'lme.tukey.out',sep="/"))
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

do.ANOVA <- function(mdata,vname,vpath){
    #Perform type III Repeated Measures 5-WAY ANOVA with mixed within and between design     
    sink(paste(vpath,'anova.out',sep="/"))
    cat("Repeated Measures 5-WAY ANOVA with mixed within and between design, Type III SSE ")
    eval(parse(text=paste('ez.mod = ezANOVA(data=mdata,dv=',vname,',wid=.(pp), within=.(S,IDR,IDL),between=.(grp),type=3)')))
    #ez.mod<-ezANOVA(data=mdata,dv=',vname,',wid=.(pp), within=.(S,IDR,IDL),between=.(grp),type=3)
    print(paste(vname,"~(S*IDR*IDL*grp)+Error(pp/(S*IDR*IDL))+grp"))
    print(ez.mod)
    sink()
}

do.compare.ANOVA <- function(mdata,vname,vpath){       
    full.mod<-lmer(get(vname) ~ (1|pp) + (1|pp/S) + (1|pp/IDR) + (1|pp/IDL) + (1|pp/S:IDR:IDL) + S+IDR+IDL+grp,mdata)
    noS.mod<-lmer(get(vname) ~ (1|pp) + IDR+IDL+grp,mdata)
    nogrp.mod<-lmer(get(vname) ~ (1|pp) + S+IDR+IDL,mdata)
    noSgrp.mod<-lmer(get(vname) ~ (1|pp) + IDR+IDL,mdata)
    
    sink(paste(vpath,'compare_anova.out',sep="/"))
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

do.lmer <- function(mdata,vname,vpath){
    #Linear Mixed Model effects, using lmer
    sink(paste(vpath,'lmer.out',sep="/"))
    #lmer.mod <- lmer(get(vname)~S*IDR*IDL*grp + (1|pp) + (1|pp:grp) + (1|pp:S), data=mdata)
    lmer.mod <- lmer(get(vname) ~ (1|pp) + grp*S*IDR*IDL, data=mdata)
    mcmc=pvals.fnc(lmer.mod,nsim=1000)
    print(mcmc$fixed)
    print(summary(anova(lmer.mod)))
    print(summary(lmer.mod))
    print(lmer.mod)
    sink()

    #Perform Tukey post-hoc comparisons on lmer
    sink(paste(vpath,'lmer.tukey.out',sep="/"))
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
