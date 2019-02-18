source("DRIData.R")

# Read-in DRI


DRI_Master=read.csv("DRI Master.csv")
DRI_Master=DRI_Master[,c("Mobile_Total.Retail_Share","Total.Retail_Total.Retail_Total.Visits")]

DRI_Master=DataCombine::change(DRI_Master,Var="Total.Retail_Total.Retail_Total.Visits" ,TimeVar="date",NewVar = paste("Visit_growth", sep="_"),slideBy=-12, type="percent")

DRI_Master=DRI_Master[,c("Mobile_Total.Retail_Share","Visit_growth")]
DRI_Master$date<-(seq(ISOdate(2014,08,1), by = "month", length.out = nrow(DRI_Master)))
names(DRI_Master)[1:2]=c("BRC-Hitwise Mobile Share of retail website visits (%)","BRC-Hitwise Growth in retailer website visits (yoy %)")

DRI_Master[,c("BRC-Hitwise Mobile Share of retail website visits (%)")]=DRI_Master[,c("BRC-Hitwise Mobile Share of retail website visits (%)")]*100

dri_embargo <- data.frame(
  id = as.numeric(52:65),
  embargo = as.Date(embargoes$DRI_embargo,"%d/%m/%y"))

DRI_Master$id <- as.numeric(row.names(DRI_Master))

DRI_Master <- merge(DRI_Master, dri_embargo, by = "id", all = TRUE)

DRI_Master <- DRI_Master[order(DRI_Master$id),]

dridates <- seq(as.Date("2014-08-01"), length=nrow(DRI_Master), by="months")
dridates <- LastDayInMonth(dridates)
DRI_Master_xts <- xts(x=DRI_Master, order.by=dridates)

DRI_Masterdf <- data.frame(date = index(DRI_Master_xts), coredata(DRI_Master_xts))

DRI_Masterdf$embargo <- as.Date(DRI_Masterdf$embargo)

DRI_Master_embargo <- DRI_Masterdf %>%
  filter(DRI_Masterdf$date <= Sys.Date() & DRI_Masterdf$embargo <= Sys.Date() | (DRI_Masterdf$date <= "2019-01-31" & is.na(DRI_Masterdf$embargo)))

dridates <- seq(as.Date("2014-08-01"), length=nrow(DRI_Master_embargo), by="months")
dridates <- LastDayInMonth(dridates)
DRI_embargo_xts <- xts(x = DRI_Master_embargo, order.by = dridates)
