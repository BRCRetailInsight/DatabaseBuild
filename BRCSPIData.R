

#add bespoke endates for monitors particularly when data have been entered into workbooks but not published
endateSPI=ISOdate(2018,11,1)

adddateSPI=length(seq(from=ISOdate(2017,11,1), to=endateSPI, by="months"))-1 

#setwd("Z:/Monitors/spi/Data/All SPI Data/ForDataCollation")

SPI_All=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx", sheet = "Annual change", range = cell_limits(c(2, 3), c(NA, 3)),col_names = FALSE,col_types="numeric")*100
SPI_Food=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx", sheet = "Annual change", range = cell_limits(c(2, 4), c(NA, 4)),col_names = FALSE,col_types="numeric")*100
SPI_NF=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx", sheet = "Annual change", range = cell_limits(c(2, 5), c(NA, 5)),col_names = FALSE,col_types="numeric")*100
SPI_Clothes=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx", sheet = "Annual change", range = cell_limits(c(2, 10), c(NA, 10)),col_names = FALSE,col_types="numeric")*100
SPI_Furniture=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx", sheet = "Annual change", range = cell_limits(c(2, 11), c(NA, 11)),col_names = FALSE,col_types="numeric")*100
SPI_Elect=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx", sheet = "Annual change", range = cell_limits(c(2, 12), c(NA, 12)),col_names = FALSE,col_types="numeric")*100
SPI_DIY=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx", sheet = "Annual change", range = cell_limits(c(2, 13), c(NA, 13)),col_names = FALSE,col_types="numeric")*100
SPI_Books=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx", sheet = "Annual change", range = cell_limits(c(2, 14), c(NA, 14)),col_names = FALSE,col_types="numeric")*100
SPI_HB=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx", sheet = "Annual change", range = cell_limits(c(2, 15), c(NA, 15)),col_names = FALSE,col_types="numeric")*100
SPI_ONF=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx", sheet = "Annual change", range = cell_limits(c(2, 16), c(NA, 16)),col_names = FALSE,col_types="numeric")*100
SPI_Fresh=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx", sheet = "Annual change", range = cell_limits(c(2, 7), c(NA, 7)),col_names = FALSE,col_types="numeric")*100
SPI_Ambient=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx", sheet = "Annual change", range = cell_limits(c(2, 8), c(NA, 8)),col_names = FALSE,col_types="numeric")*100

spi_df <- cbind(SPI_All, SPI_Ambient, SPI_Books, SPI_Clothes, SPI_DIY, SPI_Elect, SPI_Food, SPI_Fresh, SPI_Furniture, SPI_HB, SPI_NF, SPI_ONF)
spi_df <- head(spi_df, -7)
colnames(spi_df) <- c("SPI_All", "SPI_Ambient", "SPI_Books", "SPI_Clothes", "SPI_DIY", "SPI_Elect", "SPI_Food", "SPI_Fresh", "SPI_Furniture", "SPI_HB", "SPI_NF", "SPI_ONF")

spi_embargo <- data.frame(
  id = as.numeric(144:157),
  embargo = as.Date(c("2018-11-28", "2019-01-04", "2019-01-30", "2019-02-27", "2019-04-03", "2019-05-01", "2019-05-29", "2019-07-03", "2019-07-31", "2019-08-28", "2019-10-02", "2019-10-30", "2019-11-27", "2020-01-03")
  ))

spi_df$id <- as.numeric(row.names(spi_df))

spi_all_show <- merge(spi_df, spi_embargo, by = "id", all = TRUE)

spi_all_show <- spi_all_show[order(spi_all_show$id),]

dates <- seq(as.Date("2006-12-01"), length=nrow(spi_all_show), by="months")
dates <- LastDayInMonth(dates)
spi_all_show <- xts(x=spi_all_show, order.by=dates)

spi_all_showdf <- data.frame(date = index(spi_all_show), coredata(spi_all_show))

spi_all_showdf$embargo <- as.Date(spi_all_showdf$embargo)

spi_all_embargo_df <- spi_all_showdf %>%
  filter(spi_all_showdf$date <= Sys.Date() & spi_all_showdf$embargo <= Sys.Date() | (spi_all_showdf$date <= "2019-01-31" & is.na(spi_all_showdf$embargo)))

dates <- seq(as.Date("2006-12-01"), length=nrow(spi_all_embargo_df), by="months")
dates <- LastDayInMonth(dates)
spi_all_embargo_xts <- xts(x=spi_all_embargo_df, order.by = dates)

