
#### REM Data ####

REM_emp = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",sheet = "Headlines & Charts", range = cell_limits(c(22, 5), c(22, NA)),col_names = FALSE,col_types="numeric")*100))
REM_FTemp3mth = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",sheet = "Headlines & Charts", range = cell_limits(c(24, 5), c(24, NA)),col_names = FALSE,col_types="numeric")*100))
REM_PTemp3mth = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",sheet = "Headlines & Charts", range = cell_limits(c(25, 5), c(25, NA)),col_names = FALSE,col_types="numeric")*100))
REM_hrs = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",sheet = "Headlines & Charts", range = cell_limits(c(28, 5), c(28, NA)),col_names = FALSE,col_types="numeric")*100))
REM_FThrs = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",sheet = "Headlines & Charts", range = cell_limits(c(29, 5), c(29, NA)),col_names = FALSE,col_types="numeric")*100))
REM_PThrs = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",sheet = "Headlines & Charts", range = cell_limits(c(30, 5), c(30, NA)),col_names = FALSE,col_types="numeric")*100))
REM_stores = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",sheet = "Headlines & Charts", range = cell_limits(c(20, 5), c(20, NA)),col_names = FALSE,col_types="numeric")*100))
REM_stores3mth = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",sheet = "Headlines & Charts", range = cell_limits(c(21, 5), c(21, NA)),col_names = FALSE,col_types="numeric")*100))

REM <- cbind(REM_emp, REM_FTemp3mth, REM_FThrs, REM_hrs, REM_PTemp3mth, REM_PThrs, REM_stores, REM_stores3mth)
colnames(REM) <- c("REM - Employment", "REM - FT Employment 3-mth", "REM - FT Hours", "REM - Hours", "REM - PT Employment 3-mth", "REM - PT Hours", "REM - Stores", "REM - Stores 3-mth")

rem_embargo <- data.frame(
  id = as.numeric(123:135),
  embargo = as.Date(c("2019-01-24", "2019-04-25", "2019-04-25", "2019-04-25", "2019-07-25", "2019-07-25", "2019-07-25", "2019-10-24", "2019-10-24", "2019-10-24", "2020-01-23", "2020-01-23", "2020-01-23")
  ))

row.names(REM) <- 1:nrow(REM)

REM$id <- as.numeric(row.names(REM))

REM <- merge(REM, rem_embargo, by = "id", all = TRUE)

REM <- REM[order(REM$id),]

remdates <- seq(as.Date("2008-10-01"), length=nrow(REM), by="months")
remdates <- LastDayInMonth(remdates)
REM_xts <- xts(x=REM, order.by=remdates)

REM_df <- data.frame(date = index(REM_xts), coredata(REM_xts))

REM_df$embargo <- as.Date(REM_df$embargo)

REM_embargo_df <- REM_df %>%
  filter(REM_df$date <= Sys.Date() & REM_df$embargo <= Sys.Date() | (REM_df$date <= "2019-01-31" & is.na(REM_df$embargo)))

remdates <- seq(as.Date("2008-10-01"), length=nrow(REM_embargo_df), by="months")
remdates <- LastDayInMonth(remdates)
REM_embargo_xts <- xts(x = REM_embargo_df, order.by = remdates)
