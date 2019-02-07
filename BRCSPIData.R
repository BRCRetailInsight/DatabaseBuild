
#### Shop Price Inflation ####

#add bespoke endates for monitors particularly when data have been entered into workbooks but not published
endateSPI=ISOdate(2018,11,1)

adddateSPI=length(seq(from=ISOdate(2017,11,1), to=endateSPI, by="months"))-1 

setwd("Z:/Monitors/spi/Data/All SPI Data/ForDataCollation")

SPI_All=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx",range=paste("Annual change!c2:c",133+adddateSPI,sep=""),col_names = FALSE,col_types="numeric")*100
SPI_Food=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx",range=paste("Annual change!d2:d",133+adddateSPI,sep=""),col_names = FALSE,col_types="numeric")*100
SPI_NF=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx",range=paste("Annual change!e2:e",133+adddateSPI,sep=""),col_names = FALSE,col_types="numeric")*100
SPI_Clothes=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx",range=paste("Annual change!j2:j",133+adddateSPI,sep=""),col_names = FALSE,col_types="numeric")*100
SPI_Furniture=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx",range=paste("Annual change!k2:k",133+adddateSPI,sep=""),col_names = FALSE,col_types="numeric")*100
SPI_Elect=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx",range=paste("Annual change!l2:l",133+adddateSPI,sep=""),col_names = FALSE,col_types="numeric")*100
SPI_DIY=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx",range=paste("Annual change!m2:m",133+adddateSPI,sep=""),col_names = FALSE,col_types="numeric")*100
SPI_Books=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx",range=paste("Annual change!n2:n",133+adddateSPI,sep=""),col_names = FALSE,col_types="numeric")*100
SPI_HB=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx",range=paste("Annual change!O2:O",133+adddateSPI,sep=""),col_names = FALSE,col_types="numeric")*100
SPI_ONF=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx",range=paste("Annual change!O2:O",133+adddateSPI,sep=""),col_names = FALSE,col_types="numeric")*100
SPI_Fresh=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx",range=paste("Annual change!g2:g",133+adddateSPI,sep=""),col_names = FALSE,col_types="numeric")*100
SPI_Ambient=read_excel("Z:/Monitors/spi/Data/All SPI Data/SPIMaster.xlsx",range=paste("Annual change!h2:h",133+adddateSPI,sep=""),col_names = FALSE,col_types="numeric")*100


dates <- seq(as.Date("2006-12-01"), length=nrow(SPI_All), by="months")
dates <- LastDayInMonth(dates)
spi_all <- xts(x=SPI_All, order.by=dates)
colnames(spi_all) <- "SPI All Items"

dates <- seq(as.Date("2006-12-01"), length=nrow(SPI_Food), by="months")
dates <- LastDayInMonth(dates)
spi_food <- xts(x=SPI_Food, order.by=dates)
colnames(spi_food) <- "SPI Food"

dates <- seq(as.Date("2006-12-01"), length=nrow(SPI_NF), by="months")
dates <- LastDayInMonth(dates)
spi_nonfood <- xts(x=SPI_NF, order.by=dates)
colnames(spi_nonfood) <- "SPI Non-Food"

dates <- seq(as.Date("2006-12-01"), length=nrow(SPI_Clothes), by="months")
dates <- LastDayInMonth(dates)
spi_clothes <- xts(x=SPI_Clothes, order.by=dates)
colnames(spi_clothes) <- "SPI Clothing"

dates <- seq(as.Date("2006-12-01"), length=nrow(SPI_Furniture), by="months")
dates <- LastDayInMonth(dates)
spi_furniture <- xts(x=SPI_Furniture, order.by=dates)
colnames(spi_furniture) <- "SPI Furniture"

dates <- seq(as.Date("2006-12-01"), length=nrow(SPI_Elect), by="months")
dates <- LastDayInMonth(dates)
spi_electricals <- xts(x=SPI_Elect, order.by=dates)
colnames(spi_electricals) <- "SPI Electricals"

dates <- seq(as.Date("2006-12-01"), length=nrow(SPI_DIY), by="months")
dates <- LastDayInMonth(dates)
spi_diy <- xts(x=SPI_DIY, order.by=dates)
colnames(spi_diy) <- "SPI DIY"

dates <- seq(as.Date("2006-12-01"), length=nrow(SPI_Books), by="months")
dates <- LastDayInMonth(dates)
spi_books <- xts(x=SPI_Books, order.by=dates)
colnames(spi_books) <- "SPI Books"

dates <- seq(as.Date("2006-12-01"), length=nrow(SPI_HB), by="months")
dates <- LastDayInMonth(dates)
spi_health <- xts(x=SPI_HB, order.by=dates)
colnames(spi_health) <- "SPI Health & Beauty"

dates <- seq(as.Date("2006-12-01"), length=nrow(SPI_ONF), by="months")
dates <- LastDayInMonth(dates)
spi_othnonfood <- xts(x=SPI_ONF, order.by=dates)
colnames(spi_othnonfood) <- "SPI Other Non-Food"

dates <- seq(as.Date("2006-12-01"), length=nrow(SPI_Fresh), by="months")
dates <- LastDayInMonth(dates)
spi_fresh <- xts(x=SPI_Fresh, order.by=dates)
colnames(spi_fresh) <- "SPI Fresh Food"

dates <- seq(as.Date("2006-12-01"), length=nrow(SPI_Ambient), by="months")
dates <- LastDayInMonth(dates)
spi_ambient <- xts(x=SPI_Ambient, order.by=dates)
colnames(spi_ambient) <- "SPI Ambient Food"
