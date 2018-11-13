#compile BRC bespoke data -> all contained on our sharepoint!

#create xts from RSM data
endateRSM=ISOdate(2018,09,1)
adddateRSM=length(seq(from=ISOdate(2017,11,1), to=endateRSM, by="months"))-1 
RSM=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!cf8:cf",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
dates <- seq(as.Date("1995-01-01"), length=285, by="months")
RSM_xts <- xts(x=RSM, order.by=dates)
RSM_xts <- to.monthly(RSM_xts, OHLC=FALSE)