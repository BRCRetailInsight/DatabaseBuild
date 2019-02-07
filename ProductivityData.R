
#### Productivity Data ####

#Output per hour Whole Economy
url <- "https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/labourproductivity/datasets/annualbreakdownofcontributionswholeeconomyandsectors/current/prodconts.xls"
loc.download <- "output_all.xls"
download.file(url,loc.download,mode = "wb")
outputperhour <- "output_all.xls"
output_all <- read_excel(outputperhour, sheet = 6, range = "B7:B93")

dates <- seq(as.Date("1997-03-20"), length = nrow(output_all), by = "quarters")
dates <- LastDayInMonth(dates)
output_all <- xts(x = output_all, order.by=dates)
colnames(output_all) <- "Output per Hour - Whole Economy"

#Output per hour Retail
url <- "https://www.ons.gov.uk/file?uri=/economy/economicoutputandproductivity/productivitymeasures/datasets/labourproductivitybyindustrydivision/apriltojune2018/division.xls"
loc.download <- "output_retail.xls"
download.file(url,loc.download,mode = "wb")
outputperhour_retail <- "output_retail.xls"
output_retail <- read_excel(outputperhour_retail, sheet = 3, range = "Y7:Y93")

dates <- seq(as.Date("1997-03-20"), length = nrow(output_retail), by = "quarters")
dates <- LastDayInMonth(dates)
output_retail <- xts(x = output_retail, order.by=dates)
colnames(output_retail) <- "Output per Hour - Retail"

