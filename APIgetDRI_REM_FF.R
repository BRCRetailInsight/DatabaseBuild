require(readxl)
require(dplyr)

source("DRIData.R")

#,"XLConnect","rJava", "ReporteRs"
#enter last date you wish to upload for
endate= ISOdate(2018,06,1)

#add bespoke endates for monitors particularly when data have been entered into workbooks but not published
#must be a date after 2017,11,01
endateRSM=ISOdate(2018,06,1)
endateSPI=ISOdate(2018,06,1)
endateFF=ISOdate(2018,06,1)
endateDRI=ISOdate(2018,06,1)

adddate=length(seq(from=ISOdate(2017,11,1), to=endate, by="months"))-1 
adddateRSM=length(seq(from=ISOdate(2017,11,1), to=endateRSM, by="months"))-1 
adddateSPI=length(seq(from=ISOdate(2017,11,1), to=endateSPI, by="months"))-1 
adddateFF=length(seq(from=ISOdate(2017,11,1), to=endateFF, by="months"))-1 
adddateDRI=length(seq(from=ISOdate(2017,11,1), to=endateDRI, by="months"))-1 



##functions
#rollingweighted average

rollweightedav <- function(x,y,z,n){
  new=0
  for (i in n:nrow(x) ){
    a= crossprod(x[(i-(n-1)):i,y],x[(i-(n-1)):i,z])/sum(x[(i-(n-1)):i,z])
    new=cbind(new,a)
  }
  
  var=append(rep(NA,n-1),new[-1])
  var_new=as.numeric(var)     
  return(var_new)
}

#format numbers
scaleFUN <- function(x) sprintf("%.1f", x)


# Read-in DRI

DRI_Master=read.csv("DRI Master.csv")
DRI_Master=DRI_Master[,c("Mobile_Total.Retail_Share","Total.Retail_Total.Retail_Total.Visits")]

DRI_Master=change(DRI_Master,Var="Total.Retail_Total.Retail_Total.Visits" ,TimeVar="date",NewVar = paste("Visit_growth", sep="_"),slideBy=-12, type="percent")

DRI_Master=DRI_Master[,c("Mobile_Total.Retail_Share","Visit_growth")]
DRI_Master$date<-(seq(ISOdate(2014,08,1), by = "month", length.out = nrow(DRI_Master)))
names(DRI_Master)[1:2]=c("BRC-Hitwise Mobile Share of retail website visits (%)","BRC-Hitwise Growth in retailer website visits (yoy %)")

DRI_Master[,c("BRC-Hitwise Mobile Share of retail website visits (%)")]=DRI_Master[,c("BRC-Hitwise Mobile Share of retail website visits (%)")]*100

#REM

REM = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMasterRebuild201710 (Autosaved).xlsm",range="'Headlines & Charts'!e22:dn22",col_names = FALSE,col_types="numeric")*100))

# Footfall

FF=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!k6:k",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!q6:q",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_12mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!s6:s",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100

FF_Highst=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!h6:h",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_ShoppingCentre=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!j6:j",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_RetailPark=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!i6:i",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100

FF_Highst3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!m6:m",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_ShoppingCentre3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!o6:o",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_RetailPark3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!n6:n",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100


FF=cbind(FF,FF_3mth,FF_12mth,FF_Highst,FF_ShoppingCentre,FF_RetailPark,FF_Highst3mth,FF_ShoppingCentre3mth,FF_RetailPark3mth)
