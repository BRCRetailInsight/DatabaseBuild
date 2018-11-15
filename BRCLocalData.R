#compile BRC bespoke data -> all contained on our sharepoint!
require(bsts)
require(readxl)



    #create xts from RSM data
  endateRSM=ISOdate(2018,10,1)
  adddateRSM=length(seq(from=ISOdate(2017,11,1), to=endateRSM, by="months"))-1 
  rsm_tot_m=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!cf8:cf",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
  rsm_food_m=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!cd8:cd",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
  rsm_nffood_m=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ce8:ce",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
  rsm_online_m=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!dm8:dm",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
  
  
  
  rsm=cbind(rsm_tot_m,rsm_food_m,rsm_nffood_m,rsm_online_m)
  names(rsm)=c("rsm_tot","rsm_food","rsm_nffood","rsm_online")

  dates <- seq(as.Date("1995-01-01"), length=nrow(rsm), by="months")
  dates2=LastDayInMonth(dates)
  RSM_xts <- xts(x=rsm, order.by=dates2)

  #RSM weights
  
  W_rsm_food=44.13694923

  W_rsm_nffood=55.86305