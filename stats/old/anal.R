#Analysis of Variance for Bimanual Fitts experiment

require(ez)

#Prepare global paths
data_path="./data"
oscdata_path="./data/osc"
lsdata_path="./data/ls"


#Get all data files generated in Matlab
osc_files=list.files(oscdata_path)
ls_files=list.files(lsdata_path)
rootname="res"

#Auxiliar function to control display of results
print.results <- function(name,results) {
    print(name)
    print(results)
}

#Iterate over oscillation-like variables
sink("osc_anova.txt")
for (fname in osc_files) {
    #Prepare some strings for eval
    vargroup="osc"
    varname=unlist(strsplit(fname,'\\.'))[1]
    lefts=paste(list(rootname,vargroup,varname),sep=".")
    rights="tmp"
    
    #Load data from csv file
    mdata<-read.csv(
            paste('data/osc',fname,sep="/"),
            colClasses=c("factor",
                         "factor",
                         "factor",
                         "factor",
                         "factor",
                         "factor",
                         "numeric"),
            type=3
    )
    
    #Perform type II Repeated Measures 5-WAY ANOVA with mixed within and between design     
    tmp<-ezANOVA(
        data=mdata,
        dv=.(value),
        wid=.(participant),
        within=.(session,IDRight,IDLeft,hand),
        between=.(group),
        return_aov=TRUE
    )
    
    #Create variable to store and save, display data
    eval(paste(lefts,rights,sep="="))
    print.results(varname,tmp)
}

#ITerate over lockingstrength-like variables
sink("ls_anova.txt")
for (fname in ls_files) {
    #Prepare some strings for eval
    vargroup="ls"
    varname=unlist(strsplit(fname,'\\.'))[1]
    lefts=paste(list(rootname,vargroup,varname),sep=".")
    rights="tmp"
    
    #Load data from csv file
    mdata<-read.csv(
            paste('data/ls',fname,sep="/"),
            colClasses=c("factor",
                         "factor",
                         "factor",
                         "factor",
                         "factor",
                         "numeric"),
            type=3
    )
    
    #Perform type II Repeated Measures 5-WAY ANOVA with mixed within and between design     
    tmp<-ezANOVA(
        data=mdata,
        dv=.(value),
        wid=.(participant),
        within=.(session,IDRight,IDLeft),
        between=.(group),
        return_aov=TRUE
    )
    
    #Create variable to store and save, display data
    eval(paste(lefts,rights,sep="="))
    print.results(varname,tmp)
}


