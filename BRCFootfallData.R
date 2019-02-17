### Footfall Data ####

FF=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx", sheet = "Annual", range = cell_limits(c(6, 11), c(NA, 11)),col_names = FALSE,col_types="numeric")*100
FF_3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx", sheet = "Annual", range = cell_limits(c(6, 17), c(NA, 17)),col_names = FALSE,col_types="numeric")*100
FF_12mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx", sheet = "Annual", range = cell_limits(c(6, 19), c(NA, 19)),col_names = FALSE,col_types="numeric")*100

FF_Highst=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx", sheet = "Annual", range = cell_limits(c(6, 8), c(NA, 8)),col_names = FALSE,col_types="numeric")*100
FF_ShoppingCentre=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx", sheet = "Annual", range = cell_limits(c(6, 10), c(NA, 10)),col_names = FALSE,col_types="numeric")*100
FF_RetailPark=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx", sheet = "Annual", range = cell_limits(c(6, 9), c(NA, 9)),col_names = FALSE,col_types="numeric")*100

FF_Highst3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",sheet = "Annual", range = cell_limits(c(6, 13), c(NA, 13)),col_names = FALSE,col_types="numeric")*100
FF_ShoppingCentre3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx", sheet = "Annual", range = cell_limits(c(6, 15), c(NA, 15)),col_names = FALSE,col_types="numeric")*100
FF_RetailPark3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx", sheet = "Annual", range = cell_limits(c(6, 14), c(NA, 14)),col_names = FALSE,col_types="numeric")*100

FF=cbind(FF,FF_3mth,FF_12mth,FF_Highst,FF_ShoppingCentre,FF_RetailPark,FF_Highst3mth,FF_ShoppingCentre3mth,FF_RetailPark3mth)

names(FF)[1]="Footfall UK (% yoy change):BRC-Springboard"
names(FF)[2]="Footfall UK 3 month average (% yoy change):BRC-Springboard"
names(FF)[3]="Footfall UK 12 month average (% yoy change):BRC-Springboard"
names(FF)[4]="Footfall High Street (% yoy change):BRC-Springboard"
names(FF)[5]="Footfall Shopping Centre (% yoy change):BRC-Springboard"
names(FF)[6]="Footfall Retail Park (% yoy change):BRC-Springboard"
names(FF)[7]="Footfall High Street 3 month average (% yoy change):BRC-Springboard"
names(FF)[8]="Footfall Shopping Centre 3 month average (% yoy change):BRC-Springboard"
names(FF)[9]="Footfall Retail Park 3 month average (% yoy change):BRC-Springboard"

ff_embargo <- data.frame(
  id = as.numeric(97:110),
  embargo = as.Date(c("2018-12-10", "2019-01-14", "2019-02-11", "2019-03-11", "2019-04-15", "2019-05-13", "2019-06-10", "2019-07-15", "2019-08-12", "2019-09-09", "2019-10-14", "2019-11-11", "2019-12-09", "2020-01-13")
  ))

FF$id <- as.numeric(row.names(FF))

FF <- merge(FF, ff_embargo, by = "id", all = TRUE)

FF <- FF[order(FF$id),]

ffdates <- seq(as.Date("2010-11-01"), length=nrow(FF), by="months")
ffdates <- LastDayInMonth(ffdates)
FF_xts <- xts(x=FF, order.by=ffdates)

FF_df <- data.frame(date = index(FF_xts), coredata(FF_xts))

FF_df$embargo <- as.Date(FF_df$embargo)

FF_embargo_df <- FF_df %>%
  filter(FF_df$date <= Sys.Date() & FF_df$embargo <= Sys.Date() | (FF_df$date <= "2019-01-31" & is.na(FF_df$embargo)))

ffdates <- seq(as.Date("2010-11-01"), length=nrow(FF_embargo_df), by="months")
ffdates <- LastDayInMonth(ffdates)
FF_embargo_xts <- xts(x = FF_embargo_df, order.by = ffdates)
