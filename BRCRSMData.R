#### RSM Data ####

RSM=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ci8:ci",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ue8:ue",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_12mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!zf8:zf",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_Online=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!dp8:dp",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_Online_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!em8:em",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_Online_12mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!fj8:fj",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ay8:ay",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_Stores=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!adq8:adq",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL_Stores=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!adt8:adt",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ss8:ss",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL_Food_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!sq8:sq",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL_NF_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!sr8:sr",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100

RSM_Food_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!uc8:uc",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_NF_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ud8:ud",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_weeks=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!k8:k",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")

RSM=cbind(RSM,RSM_3mth,RSM_12mth,RSM_Online,RSM_Online_3mth,RSM_Online_12mth,RSM_LFL,RSM_Stores,RSM_LFL_Stores,RSM_LFL_3mth,RSM_LFL_Food_3mth,RSM_LFL_NF_3mth,RSM_Food_3mth,RSM_NF_3mth)

#row.names(RSM)=seq(from=as.Date("1995/1/1"), by = "month", length.out = nrow(RSM))
names(RSM)[1]="Total Sales (% yoy change):BRC-KPMG RSM"
names(RSM)[2]="Total Sales 3 month average (% yoy change): BRC-KPMG RSM "
names(RSM)[3]="Total Sales 12 month average (% yoy change):BRC-KPMG RSM "
names(RSM)[4]="Online Non-Food Sales (% yoy change):BRC-KPMG RSM"
names(RSM)[5]="Online Non-Food Sales 3 month average (% yoy change):BRC-KPMG RSM"
names(RSM)[6]="Online Non-Food Sales 12 month average (% yoy change):BRC-KPMG RSM"
names(RSM)[7]="Like for Like Sales (% yoy change):BRC-KPMG RSM"
names(RSM)[8]="In-Store Non-Food Sales 3 month average (% yoy change)"
names(RSM)[9]="In-Store Non-Food Like-for-Like sales 3 month average (% yoy change)"

names(RSM)[10]="Like for Like Sales 3 month average (% yoy change):BRC-KPMG RSM"
names(RSM)[11]="Food Like for Like Sales 3 month average (% yoy change):BRC-KPMG RSM"
names(RSM)[12]="Non-Food Like for Like Sales 3 month average (% yoy change):BRC-KPMG RSM"

names(RSM)[13]="Food Sales 3 month average (% yoy change)"
names(RSM)[14]="Food Sales Non-Food 3 month average (% yoy change)"