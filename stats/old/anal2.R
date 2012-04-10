#Analysis of Variance for Bimanual Fitts experiment

#Prepare global paths
data_path="./data"
out_path="./anal"
rootname=paste(list(out_path,"res"),sep="/")

#Get all data files generated in Matlab
file_list=list.files(data_path)

#Globally define format of data files
colfmt=c("factor","factor","factor","factor","factor","factor","numeric")

#Auxiliar function to control display of results
print.results <- function(name,results) {
    print(name)
    print(summary(results))
}

#Iterate over all variables
for (fname in file_list) {
    #Some string games
    varname=unlist(strsplit(fname,'\\.'))[1]
    varpath=paste(list(out_path,varname),sep="/")
    filepath=paste('data',fname,sep="/")
    
    #Select output file for txt data
    sink(paste(list(varpath,'anova.out'),sep="/"))

    #Load data from csv file
    mdata<-read.csv(filepath,colClasses=colfmt,type=3)
    
    #Perform type II Repeated Measures 5-WAY ANOVA with mixed within and between design
    res<-aov(value~(S*IDR*IDL*grp)+Error(pp/(S*IDR*IDL))+grp,mdata)
                    
    #Perform Tukkey post-hoc comparisons
    
    #Create variable to store and save, display data
    print.results(varname,res)
    
    #Plot boxplots
    
    
}
