library(readxl)
library(bsts)
library(xts)
library(dplyr)

#### Download Output Excel File and Create XTS ####

#Output Whole Economy
url <- "https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/labourproductivity/datasets/annualbreakdownofcontributionswholeeconomyandsectors/current/prodconts.xls"
loc.download <- "output_all.xls"
download.file(url,loc.download,mode = "wb")
outputperhour <- "output_all.xls"
output_all <- read_excel(outputperhour, sheet = 6, range = "B7:B93")

dates <- seq(as.Date("1997-03-20"), length = nrow(output_all), by = "quarters")
dates <- LastDayInMonth(dates)
output_all <- xts(x = output_all, order.by=dates)
colnames(output_all) <- "Whole Economy"

#Output Retail
url <- "https://www.ons.gov.uk/file?uri=/economy/economicoutputandproductivity/productivitymeasures/datasets/labourproductivitybyindustrydivision/apriltojune2018/division.xls"
loc.download <- "output_retail.xls"
download.file(url,loc.download,mode = "wb")
outputperhour_retail <- "output_retail.xls"
output_retail <- read_excel(outputperhour_retail, sheet = 3, range = "Y7:Y93")

dates <- seq(as.Date("1997-03-20"), length = nrow(output_retail), by = "quarters")
dates <- LastDayInMonth(dates)
output_retail <- xts(x = output_retail, order.by=dates)
colnames(output_retail) <- "Retail"


#GVA Whole Economy
url <- "https://www.ons.gov.uk/file?uri=/economy/grossdomesticproductgdp/datasets/ukgdpolowlevelaggregates/current/gdplla.xls"
loc.download <- "gva_all.xls"
download.file(url,loc.download,mode = "wb")
gva_all <- "gva_all.xls"
gva_all <- read_excel(gva_all, sheet = 3, range = "D46:D132")

dates <- seq(as.Date("1997-03-20"), length = nrow(gva_all), by = "quarters")
dates <- LastDayInMonth(dates)
gva_all <- xts(x = gva_all, order.by=dates)
colnames(gva_all) <- "Whole Economy"

#GVA Retail
gva_retail <- "gva_all.xls"
gva_retail <- read_excel(gva_retail, sheet = 3, range = "CY46:CY132")
gva_retail <- xts(x = gva_retail, order.by=dates)
colnames(gva_retail) <- "Retail"
