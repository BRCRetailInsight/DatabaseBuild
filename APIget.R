#This code downloads and formats data available via ONS/Eurostat APIs
#This code needs to have a dictionary which tells us what the ONS codes are

# Packages needed

library(dplyr)
library(pdfetch)
library(xts)
library(readxl)


# ONS retail sales (DRSI)
# Volume data: RETAIL SALES INDEX: VOLUME SEASONALLY ADJUSTED PERCENTAGE CHANGE ON SAME MONTH A YEAR EARLIER
# "J5EB" = "All retailing including automotive fuel"
# "J45U" = "All retailing excluding automotive fuel"
# "IDOB"= "Predominantly food stores"
# "IDOC" = "Total predominantly non-food stores"
# "IDOA" = "Non-Specialised stores"
# "IDOG" = "Textile, clothing and footwear stores"
# "IDOH" = "Households goods stores"
# "IDOD" = "Other Non - Food Stores" 
# "J5DK" = "Non-Store retailing"
# "JO4C" = "Fuel"

# Fetch data from ONS and convert to month only (so no days)


rsi_vol <- pdfetch_ONS(c("J5EB","J45U", "IDOB","IDOC","IDOA","IDOG","IDOH","IDOH","IDOD","JO4C","J5DK"), "DRSI")
rsi_vol <- to.monthly(rsi, OHLC=FALSE)


# Retail sales weights (2017)

# W_IDOB: Predominantly food stores = 39.0
# W_IDOC: Total predominantly non-food stores = 41.58
# W_IDOA: Non-Specialised stores = 8.57
# W_IDOG: Textile, clothing and footwear stores = 11.97
# W_IDOH: Households goods stores = 8.2
# W_IDOD: Other Non-Food Stores = 12.84
# W_J5DK: Non-Store retailing = 9.65
# W_JO4C: Fuel = 9.77
# W_J45U: Total ex-fuel = 90.23


  W_IDOB = 39.0
  W_IDOC = 41.58
  W_IDOA = 8.57
  W_IDOG = 11.97
  W_IDOH = 8.2
  W_IDOD = 12.84
  W_J5DK = 9.65
  W_JO4C = 9.77
  W_J45U = 90.23


# EAFS = RSI:Predominantly food stores (val nsa):All Business Index
# j596 = RSI:Value Not seasonally Adjusted:Non-store Retailing:All Business Index
# J45U = RSI:All retail ex fuel:All Business:VOL SA:% change on same month a year ago
# J43S = RSI:Value Not seasonally Adjusted:All Retailers ex fuel:All Business Index
# ONS consumer prices


#CPI
cpi <- fromJSON("https://api.ons.gov.uk/dataset/MM23/timeseries/D7G7/data")

cpimonths <- cpi$months

cpiquarters <- cpi$quarters

cpiyears <- cpi$years

#food inflation
cpifood <- fromJSON("https://api.ons.gov.uk/dataset/MM23/timeseries/D7G8/data")

cpifoodmonths <- cpifood$months

cpifoodquarters <- cpifood$quarters

cpifoodyears <- cpifood$years

#retail sales values nsa %
rsivalnsa <- fromJSON("https://api.ons.gov.uk/dataset/DRSI/timeseries/J43S/data")

rsivalnsamonths <- rsivalnsa$months

rsivalnsaquarters <- rsivalnsa$quarters

rsivalnsayears <- rsivalnsa$years

#rsi value predominantly food stores nsa %
rsivalnsafood <- fromJSON("https://api.ons.gov.uk/dataset/DRSI/timeseries/EAFS/data")

#rsi value department stores nsa %
rsivalnsafood <- fromJSON("https://api.ons.gov.uk/dataset/DRSI/timeseries/EAGE/data")

#rsi value textiles, clothing & footwear nsa %
rsivalnsafood <- fromJSON("https://api.ons.gov.uk/dataset/DRSI/timeseries/EAFU/data")

#rsi value household goods nsa %
rsivalnsafood <- fromJSON("https://api.ons.gov.uk/dataset/DRSI/timeseries/EAFV/data")

#rsi value other non food nsa %
rsivalnsafood <- fromJSON("https://api.ons.gov.uk/dataset/DRSI/timeseries/EAFW/data")

#rsi value non store nsa %
rsivalnsafood <- fromJSON("https://api.ons.gov.uk/dataset/DRSI/timeseries/J596/data")

#rsi volume SA
rsivolsa <- fromJSON("https://api.ons.gov.uk/dataset/DRSI/timeseries/J45U/data")

rsivolsamonths <- rsivolsa$months

rsivolsaquarters <- rsivolsa$quarters

rsivolsayears <- rsivolsa$years

#wages
awe <- fromJSON("https://api.ons.gov.uk/dataset/EMP/timeseries/KAI8/data")

awemonths <- awe$months

#gdp
gdp <- fromJSON("https://api.ons.gov.uk/dataset/PGDP/timeseries/IHYQ/data")

gdpquarters <- gdp$quarters

#unemployment
unemp <- fromJSON("https://api.ons.gov.uk/dataset/LMS/timeseries/MGSX/data")

unempmonths <- unemp$months

unempquarters <- unemp$quarters

unempyears <- unemp$years

#Nomis database lookup
nomisdata <- fromJSON("http://www.nomisweb.co.uk/api/v01/dataset/def.sdmx.json")

#shops

#business size

#bres

#gross fixed capital formation

#check EBR

#productivity

### Tests ###

#Bank of England Secured lending (test)
LPMVTVJ <- pdfetch_BOE("LPMVTVJ", from = "01-01-2018", to = Sys.Date())

#Scottish RSI... doesn't work yet
scotrsi <- fromJSON("http://statistics.gov.scot/data/RSIS")


ukretailhours <- pdfetch_EUROSTAT("sts_trlb_q", FREQ="Q", S_ADJ="SCA", UNIT="I10",
                                  INDIC_NA="B1GM", GEO=c("UK"))
###MONTHLY FILE CREATION###
#fetch data from ONS and convert to month only (so no days)
rsi <- pdfetch_ONS(c("EAFS", "EAGE", "EAFU", "EAFV", "EAFW", "J596", "J45U", "J43S"), "DRSI")
rsi <- to.monthly(rsi, OHLC=FALSE)

cpi <- pdfetch_ONS(c("D7G7", "D7G8"), "MM23")
cpi <- to.monthly(cpi, OHLC=FALSE)

unemp <- pdfetch_ONS(c("MGSX"), "LMS")
unemp <- to.monthly(unemp, OHLC=FALSE)

awe <- pdfetch_ONS(c("KAI8"), "EMP")
awe <- to.monthly(awe, OHLC=FALSE)

#create xts from RSM data
endateRSM=ISOdate(2018,09,1)
adddateRSM=length(seq(from=ISOdate(2017,11,1), to=endateRSM, by="months"))-1 
RSM=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!cf8:cf",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
dates <- seq(as.Date("1995-01-01"), length=285, by="months")
RSM_xts <- xts(x=RSM, order.by=dates)
RSM_xts <- to.monthly(RSM_xts, OHLC=FALSE)

#merge xts's... "outer" keeps all entries for all variables, even if not updated as quickly
databasemonthly <- merge(rsi, cpi, join = "outer")
databasemonthly <- merge(databasemonthly, unemp, join = "outer")
databasemonthly <- merge(databasemonthly, awe, join = "outer")
databasemonthly <- merge(databasemonthly, RSM_xts, join = "outer")

#remove unnecessary objects
rm(rsi, cpi, unemp, gdp, awe, RSM, RSM_xts)

###QUARTERLY FILE CREATION###

gdp <- pdfetch_ONS(c("IHYQ"), "PGDP")
gdp <- to.quarterly(gdp, OHLC=FALSE)
