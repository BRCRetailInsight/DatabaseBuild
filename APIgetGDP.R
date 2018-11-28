library(readxl)
library(bsts)
library(xts)
library(dplyr)
library(pdfetch)

#### Monthly GVA Data ####

# Time Series Definitions

# "ECYX" = Monthly GVA Month on Month (CVM SA %)
# "ED2R" = Monthly GVA Year on Year (CVM SA %)

# ONS Monthly GDP - (mgdp)
GVAmonthly <- pdfetch_ONS(c("ECYX", "ED2R"), "mgdp")

GVAmonthly_yoy <- GVAmonthly$ED2R

GVAmonthly_mom <- GVAmonthly$ECYX


#### ONS Quarterly GDP Data - qna ####

# Time Series Definitions

# "ABMI" = Quarterly GDP (CVM SA £m)

#GDP at Basic Prices and GDP per head at Basic Prices- qna
gdpquarterly <- pdfetch_ONS(c("ABMI","IHXW"), "qna")
colnames(gdpquarterly) <- c("GDP Whole Economy","GDP per Head Whole Economy")

#GDP and GDP per head at Basic Prices - BB
gdpannual <- pdfetch_ONS(c("ABMI","IHXW"), "BB")
colnames(gdpannual) <- c("GDP Whole Economy","GDP per Head Whole Economy")



#### ONS Quartlery GVA, from: "GDP output approach - Low Level Aggregates" ####

#GVA Whole Economy (CP £m)
url <- "https://www.ons.gov.uk/file?uri=/economy/grossdomesticproductgdp/datasets/ukgdpolowlevelaggregates/current/gdplla.xls"
loc.download <- "gva_all.xls"
download.file(url,loc.download,mode = "wb")
gva_all <- "gva_all.xls"
gva_all <- read_excel(gva_all, sheet = 3, range = "D46:D132")

dates <- seq(as.Date("1997-03-20"), length = nrow(gva_all), by = "quarters")
dates <- LastDayInMonth(dates)
gva_all <- xts(x = gva_all, order.by=dates)
colnames(gva_all) <- "GVA Whole Economy"

#GVA Retail (CP £m)
gva_retail <- "gva_all.xls"
gva_retail <- read_excel(gva_retail, sheet = 3, range = "CY46:CY132")
gva_retail <- xts(x = gva_retail, order.by=dates)
colnames(gva_retail) <- "GVA Retail"


