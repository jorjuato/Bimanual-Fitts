require(lattice)
require(HH)

plot_interactions.uni <- function(mdata,vname,vpath){
    #Plot grp vs S    
    png(file=paste(vpath,"INT_grp_vs_S.png",sep="/"), bg="transparent", width=1400, height=1000)
    print(interaction2wt(get(vname)~grp+S,responselab=vname,main.in=paste(vname," Group vs Session"),mdata))
    dev.off()

    #Plot group vs ID
    form<-as.formula(paste(vname,"~ grp + ID"))
    png(file=paste(vpath,"Uni_INT_grp_vs_ID.png",sep="/"), bg="transparent", width=1400, height=1000)
    print(interaction2wt(form,responselab=vname,main.in=paste(vname," Group vs ID"),mdata))
    dev.off()
    
    #Plot group vs ID-S
    form<-as.formula(paste(vname,"~ grp + S + ID"))
    png(file=paste(vpath,"Uni_INT_grp_vs_ID-S.png",sep="/"), bg="transparent", width=1400, height=1000)
    print(interaction2wt(form,responselab=vname,main.in=paste(vname," Group vs S-ID"),mdata))
    dev.off()

    #Plot Session vs ID
    form=as.formula(paste(vname,"~ S + ID"))
    png(file=paste(vpath,"Uni_INT_S_vs_ID.png",sep="/"), bg="transparent", width=1400, height=1000)
    print(interaction2wt(form,responselab=vname,main.in=paste(vname," Session vs ID"),mdata))
    dev.off()
    
    #Plot participant vs ID
    form=as.formula(paste(vname,"~ pp + ID"))
    png(file=paste(vpath,"Uni_INT_PP_vs_ID.png",sep="/"), bg="transparent", width=1400, height=1000)    
    print(interaction2wt(form,responselab=vname,main.in=paste(vname,"  PP vs ID"),mdata))
    dev.off()
    
    #Plot participant vs IDR IDL, 1 per session    
    ip1<-interaction2wt(form,responselab=vname,subset=mdata$S==1,main.in=paste(vname,"  PP vs ID, S1"),mdata)
    ip2<-interaction2wt(form,responselab=vname,subset=mdata$S==4,main.in=paste(vname,"  PP vs ID, S4"),mdata)
    ip3<-interaction2wt(form,responselab=vname,subset=mdata$S==7,main.in=paste(vname,"  PP vs ID, S7"),mdata)
    png(file=paste(vpath,"Uni_PP_vs_ID_by-S.png",sep="/"), bg="transparent", width=2500, height=1500)
    plot(ip1,split=c(1,1,1,3))
    plot(ip2,split=c(1,2,1,3),newpage=FALSE)
    plot(ip3,split=c(1,3,1,3),newpage=FALSE)
    dev.off()
}
plot_boxplots.uni <- function(mdata,vname,vpath){
    ylim_var<-eval(parse(text=paste(paste('c(0,max(mdata$',vname,sep=''),'))',sep='')))
    #Plot grp vs S    
    png(file=paste(vpath,"Uni_grp_vs_S.png",sep="/"), bg="transparent", width=700, height=500)
    form=as.formula(paste(vname,"~ grp | S"))
    plot(bwplot(form,mdata,main = "Group vs Session"))
    dev.off()    
    
    #Plot group vs ID
    png(file=paste(vpath,"Uni_grp_vs_IDL-IDR.png",sep="/"), bg="transparent", width=700, height=500)
    form=as.formula(paste(vname,"~ grp | ID"))
    plot(bwplot(form,mdata,main = "Group vs ID"))
    dev.off()
    
    #Plot group vs IDR IDL, 1 per session    
    form<-as.formula(paste(vname,"~ grp | ID"))  
    bw1<-bwplot(form,mdata,main = "Group vs ID Session 1",subset=mdata$S==1,ylim=ylim_var)
    bw2<-bwplot(form,mdata,main = "Group vs ID Session 4",subset=mdata$S==4,ylim=ylim_var)
    bw3<-bwplot(form,mdata,main = "Group vs ID Session 7",subset=mdata$S==7,ylim=ylim_var)
    png(file=paste(vpath,"Uni_grp_vs_ID_by-S.png",sep="/"), bg="transparent", width=1400, height=1000)
    plot(bw1,split=c(1,1,3,1))
    plot(bw2,split=c(2,1,3,1),newpage=FALSE)
    plot(bw3,split=c(3,1,3,1),newpage=FALSE)
    dev.off()
    
    #Plot Session vs ID
    png(file=paste(vpath,"Uni_S_vs_ID.png",sep="/"), bg="transparent", width=700, height=500)
    form=as.formula(paste(vname,"~ S | ID"))
    plot(bwplot(form,mdata))
    dev.off()

    #Plot Session vs IDR IDL, 1 per group    
    form=as.formula(paste(vname,"~ S | ID"))
    bw1<-bwplot(form,mdata,main = "Session vs ID Coupled",subset=mdata$grp=='U',ylim=ylim_var)
    bw2<-bwplot(form,mdata,main = "Session vs ID Uncoupled",subset=mdata$grp=='C',ylim=ylim_var)
    png(file=paste(vpath,"Uni_S_vs_ID_grp.png",sep="/"), bg="transparent", width=1400, height=1000)
    plot(bw1,split=c(1,1,1,2))
    plot(bw2,split=c(1,2,1,2),newpage=FALSE)
    dev.off()
    
    #Plot participant vs IDR IDL
    png(file=paste(vpath,"Uni_PP_vs_ID.png",sep="/"), bg="transparent", width=700, height=500)
    form=as.formula(paste(vname,"~ pp | ID"))
    print(bwplot(form,mdata))
    dev.off()

    #Plot participant vs IDR IDL, 1 per session    
    form=as.formula(paste(vname,"~ pp | ID"))
    bw1<-bwplot(form,mdata,main = "Participant vs ID Session 1",subset=mdata$S==1,ylim=ylim_var)
    bw2<-bwplot(form,mdata,main = "Participant vs ID Session 4",subset=mdata$S==4,ylim=ylim_var)
    bw3<-bwplot(form,mdata,main = "Participant vs ID Session 7",subset=mdata$S==7,ylim=ylim_var)
    png(file=paste(vpath,"Uni_PP_vs_ID_by-S.png",sep="/"), bg="transparent", width=1400, height=1000)
    plot(bw1,split=c(1,1,1,3))
    plot(bw2,split=c(1,2,1,3),newpage=FALSE)
    plot(bw3,split=c(1,3,1,3),newpage=FALSE)
    dev.off()
    
    #Plot participant vs grp + S
    png(file=paste(vpath,"Uni_PP_vs_grp-S.png",sep="/"), bg="transparent", width=700, height=500)
    form=as.formula(paste(vname,"~ pp | grp + S"))
    print(bwplot(form,mdata))
    dev.off()
}

plot_barcharts.uni <- function(mdata,vname,vpath){
    form<-as.formula(paste("~",paste(vname,"|ID")))
    chart_g1_s1<-barchart(form,mdata,main = "Coupled Session 1",subset=(mdata$S==1 & mdata$grp=="U"),origin=0)
    chart_g1_s4<-barchart(form,mdata,main = "Coupled Session 4",subset=(mdata$S==4 & mdata$grp=="U"),origin=0)
    chart_g1_s7<-barchart(form,mdata,main = "Coupled Session 7",subset=(mdata$S==7 & mdata$grp=="U"),origin=0)
    chart_g2_s1<-barchart(form,mdata,main = "Uncoupled Session 1",subset=(mdata$S==1 & mdata$grp=="C"),origin=0)
    chart_g2_s4<-barchart(form,mdata,main = "Uncoupled Session 4",subset=(mdata$S==4 & mdata$grp=="C"),origin=0)
    chart_g2_s7<-barchart(form,mdata,main = "Uncoupled Session 7",subset=(mdata$S==7 & mdata$grp=="C"),origin=0)
    
    png(file=paste(vpath,"Uni_barchart.png",sep="/"), bg="transparent", width=1400, height=1000)
    plot(chart_g1_s1,split=c(1,1,3,2))
    plot(chart_g1_s4,split=c(2,1,3,2),newpage=FALSE)
    plot(chart_g1_s7,split=c(3,1,3,2),newpage=FALSE)
    plot(chart_g2_s1,split=c(1,2,3,2),newpage=FALSE)
    plot(chart_g2_s4,split=c(2,2,3,2),newpage=FALSE)
    plot(chart_g2_s7,split=c(3,2,3,2),newpage=FALSE)
    dev.off()    
}
