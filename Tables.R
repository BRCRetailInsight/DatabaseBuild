

#run two files which collate the data
#BUt FIRST check "enddateRSM" in the BRC local data file -> it will need manually changing!!
source("BRCLocalData.R")
source("APIgetRSI.R")



#Create table

tbl_1=as.table(matrix(c(as.character(round(RSM_xts$rsm_tot[nrow(RSM_xts)],1)),
                        as.character(round(RSM_xts$rsm_tot[nrow(RSM_xts)-1],1)),
                        as.character(rsi_val$J3L2[nrow(rsi_val)]),
                        as.character(rsi_val$J3L2[nrow(rsi_val)-1]),
                        as.character(round(RSM_xts$rsm_food[nrow(RSM_xts)],1)),
                        as.character(round(RSM_xts$rsm_food[nrow(RSM_xts)-1],1)),
                        as.character(rsi_val$EAIA[nrow(rsi_val)]),
                        as.character(rsi_val$EAIA[nrow(rsi_val)-1]),
                        as.character(round(rsi_val$J3L3[nrow(rsi_val)],1)),
                        as.character(round(rsi_val$J3L3[nrow(rsi_val)]-1,1)),
                        as.character(round(rsi_val$J3L4[nrow(rsi_val)],1)),
                        as.character(round(rsi_val$J3L4[nrow(rsi_val)]-1,1)),
                        as.character(round(rsi_val$EAIT[nrow(rsi_val)],1)),
                        as.character(round(rsi_val$EAIT[nrow(rsi_val)]-1,1)),
                        as.character(round(rsi_val$EAIU[nrow(rsi_val)],1)),
                        as.character(round(rsi_val$EAIU[nrow(rsi_val)]-1,1)),
                      as.character(round(rsi_val$KP3T[nrow(rsi_val)],1)),
                        as.character(round(rsi_val$KP3T[nrow(rsi_val)]-1,1)),
                      as.character(round(RSM_xts$rsm_online[nrow(RSM_xts)],1)),
                      as.character(round(RSM_xts$rsm_online[nrow(RSM_xts)-1],1))),
                       nrow=10,ncol=2,byrow=TRUE))




colnames(tbl_1)=c("This Month","Last Month")
rownames(tbl_1)=c("Total RSM","Total RSI (J3L2)","Food RSM","Food RSI (EAIA)","RSI Large Businesses(J3L3)","RSI Small Businesses (J3L4)","RSI Large Food Businesses (EAIT)","RSI Small Food Businesses (EAIU)", "RSI Internet Sales (K3PT)", "RSM Online Non-Food")

#output to excel
write.csv(tbl_1,paste("RSI Comparison",Sys.Date(),".csv"))
