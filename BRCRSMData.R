#### RSM Data ####

RSM=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 87), c(NA, 87)),col_names = FALSE,col_types="numeric")*100
RSM_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 551), c(NA, 551)),col_names = FALSE,col_types="numeric")*100
RSM_12mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 682), c(NA, 682)),col_names = FALSE,col_types="numeric")*100
RSM_Online=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 120), c(NA, 120)),col_names = FALSE,col_types="numeric")*100
RSM_Online_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 143), c(NA, 143)),col_names = FALSE,col_types="numeric")*100
RSM_Online_12mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 166), c(NA, 166)),col_names = FALSE,col_types="numeric")*100
RSM_LFL=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 51), c(NA, 51)),col_names = FALSE,col_types="numeric")*100
RSM_Stores=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 797), c(NA, 797)),col_names = FALSE,col_types="numeric")*100
RSM_LFL_Stores=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 800), c(NA, 800)),col_names = FALSE,col_types="numeric")*100
RSM_LFL_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 513), c(NA, 513)),col_names = FALSE,col_types="numeric")*100
RSM_LFL_Food_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 511), c(NA, 511)),col_names = FALSE,col_types="numeric")*100
RSM_LFL_NF_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 512), c(NA, 512)),col_names = FALSE,col_types="numeric")*100

RSM_Food_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 549), c(NA, 549)),col_names = FALSE,col_types="numeric")*100
RSM_NF_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 550), c(NA, 550)),col_names = FALSE,col_types="numeric")*100
RSM_weeks=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", sheet = "UK RSM data", range = cell_limits(c(8, 11), c(NA, 11)),col_names = FALSE,col_types="numeric")

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

rsm_embargo <- data.frame(
  id = as.numeric(287:300),
  embargo = as.Date(embargoes$RSM_embargo,"%d/%m/%y" ))

RSM$id <- as.numeric(row.names(RSM))

RSM_all <- merge(RSM, rsm_embargo, by = "id", all = TRUE)

RSM_all <- RSM_all[order(RSM_all$id),]

rsmdates <- seq(as.Date("1995-01-01"), length=nrow(RSM_all), by="months")
rsmdates <- LastDayInMonth(rsmdates)
RSM_all_xts <- xts(x=RSM_all, order.by=rsmdates)

RSM_alldf <- data.frame(date = index(RSM_all_xts), coredata(RSM_all_xts))

RSM_alldf$embargo <- as.Date(RSM_alldf$embargo)

RSM_all_embargo_df <- RSM_alldf %>%
  filter(RSM_alldf$date <= Sys.Date() & RSM_alldf$embargo <= Sys.Date() | (RSM_alldf$date <= "2019-01-31" & is.na(RSM_alldf$embargo)))

rsmdates <- seq(as.Date("1995-01-01"), length=nrow(RSM_all_embargo_df), by="months")
rsmdates <- LastDayInMonth(rsmdates)
RSM_embargo_xts <- xts(x = RSM_all_embargo_df, order.by = rsmdates)
