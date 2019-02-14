library(pdfetch)
library(xts)
library(readxl)
library(bsts)
library(nomisr)
library(jsonlite)
library(httr)
library(SPARQL)
library(utils)
library(tframePlus)
library(rgdal)
library(maptools)
library(rmapshaper)
library(leaflet)
library(reshape)
library(dplyr)

<<<<<<< HEAD
#setwd("C:/Users/James.Hardiman/Documents/DatabaseBuild")
=======
>>>>>>> 2a8ea151ded810230940eadd2405b8e7a0d24a11

setwd("Z:/Projects/RIADatabaseBuild")

#### Bank of England Time Series ####

# Secured lending
boe_secured <- pdfetch_BOE("LPMVTVJ", from = "1993-01-01", to = Sys.Date())
colnames(boe_secured) <- "Secured Lending"

# Consumer Credit
boe_conscredit <- pdfetch_BOE("LPMB3PS", from = "1993-01-01", to = Sys.Date())
colnames(boe_conscredit) <- "Consumer Credit"

# Credit Cards
boe_ccards <- pdfetch_BOE("LPMVZQX", from = "1993-01-01", to = Sys.Date())
colnames(boe_ccards) <- "Credit Cards"

# Mortgage Approvals
boe_house <- pdfetch_BOE("LPMVTVX", from = "1993-01-01", to = Sys.Date())
colnames(boe_house) <- "Mortgage Approvals"

# Sterling Effective Exchange Rate
boe_gbp <- pdfetch_BOE("XUMABK67", from = "1980-01-01", to = Sys.Date())
colnames(boe_gbp) <- "Sterling Effective Exchange Rate"

#### Monthly GDP Data ####

# Time Series Definitions

# "ECYX" = Monthly GVA Month on Month (CVM SA %)
# "ED2R" = Monthly GVA Year on Year (CVM SA %)

# ONS Monthly GDP - (mgdp)
GVAmonthly <- pdfetch_ONS(c("ECYX", "ED2R"), "mgdp")

GVAmonthly_yoy <- GVAmonthly$ED2R

GVAmonthly_mom <- GVAmonthly$ECYX

colnames(GVAmonthly_yoy) <- "GVA Monthly (% YoY)"
colnames(GVAmonthly_mom) <- "GVA Monthly (% MoM)"

#### Quarterly GDP Data ####

# Time Series Definitions

# "ABMI" = Quarterly GDP (CVM SA £m)

#GDP at Basic Prices - qna
gdpquarterly <- pdfetch_ONS(c("ABMI"), "qna")
colnames(gdpquarterly) <- "GDP Quarterly - Whole Economy (£m)"

#### Quartlery GVA, from: "GDP output approach - Low Level Aggregates" ####

#GVA Whole Economy (CP £m)
url <- "https://www.ons.gov.uk/file?uri=/economy/grossdomesticproductgdp/datasets/ukgdpolowlevelaggregates/current/gdplla.xls"
loc.download <- "gva_all.xls"
download.file(url,loc.download,mode = "wb")
gva_all <- "gva_all.xls"
gva_all <- read_excel(gva_all, sheet = 3, range = cell_limits(c(46, 4), c(NA, 4)))

dates <- seq(as.Date("1997-03-20"), length = nrow(gva_all), by = "quarters")
dates <- LastDayInMonth(dates)
GVAquarterly_all <- xts(x = gva_all, order.by=dates)
colnames(GVAquarterly_all) <- "GVA Quarterly - Whole Economy (£m)"

#GVA Retail (CP £m)
gva_retail <- "gva_all.xls"
gva_retail <- read_excel(gva_retail, sheet = 3, range = cell_limits(c(46, 103), c(NA, 103)))
GVAquarterly_retail <- xts(x = gva_retail, order.by=dates)
colnames(GVAquarterly_retail) <- "GVA Quarterly - Retail (£m)"

#### Average Weekly Earnings ####

# Time Series Definitions

# "KAB9" = Total Pay
# "KAC2" = Total Pay YoY Growth
# "KAC3" = Total Pay 3-month average YoY Growth
# "KAI7" = Regular Pay
# "KAI8" = Regular Pay YoY Growth
# "KAI9" = Regular Pay 3-month average YoY Growth
# "A3WX" = Real Total Pay
# "A3WV" = Real Total Pay YoY Growth
# "A3WW" = Real Total Pay 3-month average YoY Growth
# "A2FC" = Real Regular Pay
# "A2F9" = Real Regular Pay YoY Growth
# "A2FA" = Real Regular Pay 3-month average YoY Growth

# Get AWE Data

awe <- pdfetch_ONS(c("KAB9", "KAC2", "KAC3", "KAI7", "KAI8", "KAI9", "A3WX", "A3WV", "A3WW", "A2FC", "A2F9", "A2FA"), "lms")

colnames(awe) <- c("Total Pay", "Total Pay YoY Growth", "Total Pay 3-month average YoY Growth",
                   "Regular Pay", "Regular Pay YoY Growth", "Regular Pay 3-month average YoY Growth",
                   "Real Total Pay", "Real Total Pay YoY Growth", "Real Total Pay 3-month average YoY Growth",
                   "Real Regular Pay", "Real Regular Pay YoY Growth", "Real Regular Pay 3-month average YoY Growth")

#### JOBS03 & JOBS04 Data ####

#Employee Jobs
url <- "https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/employeejobsbyindustryjobs03/current/jobs03sep2018.xls"
loc.download <- "empjobs.xls"
download.file(url,loc.download,mode = "wb")
empjobs <- "empjobs.xls"
empjobs_all <- read_excel(empjobs, sheet = 2, range = cell_limits(c(6, 86), c(NA, 86)))
empjobs_all <- head(empjobs_all, -2)
empjobs_all$X__1 <- as.numeric(empjobs_all$X__1)

dates <- seq(as.Date("1978-06-20"), length = nrow(empjobs_all), by = "quarters")
dates <- LastDayInMonth(dates)
empjobsquarterly_all <- xts(x = empjobs_all, order.by=dates)
colnames(empjobsquarterly_all) <- "Employee Jobs - Whole Economy"

empjobs_retail <- read_excel(empjobs, sheet = 2, range = cell_limits(c(6, 41), c(NA, 41)))
empjobsquarterly_retail <- xts(x = empjobs_retail, order.by=dates)
colnames(empjobsquarterly_retail) <- "Employee Jobs - Retail"

#Self-Employed Jobs
url <- "https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/selfemploymentjobsbyindustryjobs04/current/jobs04sep2018.xls"
loc.download <- "selfjobs.xls"
download.file(url,loc.download,mode = "wb")
selfjobs <- "selfjobs.xls"
selfjobs_all <- read_excel(selfjobs, sheet = 2, range = cell_limits(c(6, 86), c(NA, 86)))
selfjobs_all <- head(selfjobs_all, -2)
selfjobs_all$X__1 <- as.numeric(selfjobs_all$X__1)

dates <- seq(as.Date("1996-03-20"), length = nrow(selfjobs_all), by = "quarters")
dates <- LastDayInMonth(dates)
selfjobsquarterly_all <- xts(x = selfjobs_all, order.by=dates)
colnames(selfjobsquarterly_all) <- "Self-Employed Jobs - Whole Economy"

selfjobs_retail <- read_excel(selfjobs, sheet = 2, range = cell_limits(c(6, 41), c(NA, 41)))
selfjobsquarterly_retail <- xts(x = selfjobs_retail, order.by=dates)
colnames(selfjobsquarterly_retail) <- "Self-Employed Jobs - Retail"

#### Unemployment & Employment Data ####

#Time Series - Unemployment Definitions
# "MGSX" = Unemployment Rate UK (SA)
# "ZSFB" = Unemployment Rate Northern Ireland (SA)
# "YCNM" = Unemployment Rate Wales (SA)
# "YCNL" = Unemployment Rate England (SA)
# "YCNN" = Unemployment Rate Scotland (SA)
# "YCNE" = Unemployment Rate Yorkshire & the Humber (SA)
# "YCND" = Unemployment Rate North West (SA)
# "YCNC" = Unemployment Rate North East (SA)
# "YCNG" = Unemployment Rate West Midlands (SA)
# "YCNF" = Unemployment Rate East Midlands (SA)
# "YCNI" = Unemployment Rate London (SA)
# "YCNH" = Unemployment Rate East (SA)
# "YCNK" = Unemployment Rate South West (SA)
# "YCNJ" = Unemployment Rate South East (SA)

unemp <- pdfetch_ONS(c("MGSX", "YCNC", "ZSFB", "YCNM", "YCNL", "YCNN", "YCNE", "YCND", "YCNG", "YCNF", "YCNI", "YCNH", "YCNK", "YCNJ"), "lms")

colnames(unemp) <- c("Unemployment Rate UK", "Unemployment Rate Northern Ireland", "Unemployment Rate Wales",
                     "Unemployment Rate England", "Unemployment Rate Scotland", "Unemployment Rate Yorkshire & the Humber",
                     "Unemployment Rate North West", "Unemployment Rate North East", "Unemployment Rate West Midlands",
                     "Unemployment Rate East Midlands", "Unemployment Rate London", "Unemployment Rate East",
                     "Unemployment Rate South West", "Unemployment Rate South East")

#Time Series - Employment Definitions
# "YCBE" = Employment Total UK (SA)
# "YCJP" = Employment Total North East (SA)
# "YCJQ" = Employment Total North West (SA)
# "YCJR" = Employment Total Yorkshire & the Humber (SA)
# "YCJS" = Employment Total East Midlands (SA)
# "YCJT" = Employment Total West Midlands (SA)
# "YCJU" = Employment Total East (SA)
# "YCJV" = Employment Total London (SA)
# "YCJW" = Employment Total South East (SA)
# "YCJX" = Employment Total South West (SA)
# "YCJY" = Employment Total England (SA)
# "YCJZ" = Employment Total Wales (SA)
# "YCKA" = Employment Total Scotland (SA)
# "ZSFG" = Employment Total Northern Ireland (SA)

employ <- pdfetch_ONS(c("YCBE", "YCJP", "YCJQ", "YCJR", "YCJS", "YCJT", "YCJU", "YCJV", "YCJW", "YCJX", "YCJY", "YCJZ", "YCKA", "ZSFG"), "lms")

colnames(employ) <- c("Employment Total UK", "Employment Total North East", "Employment Total North West",
                     "Employment Total Yorkshire & the Humber", "Employment Total East Midlands", "Employment Total West Midlands",
                     "Employment Total East", "Employment Total London", "Employment Total South East",
                     "Employment Total South West", "Employment Total England", "Employment Total Wales",
                     "Employment Total Scotland", "Employment Total Northern Ireland")


#### NOMIS Data ####

#Workforce Jobs
nomiswfjobs <- fromJSON("https://www.nomisweb.co.uk/api/v01/dataset/NM_189_1.data.json?geography=2092957699,2092957698,2092957701,2092957700&industry=146800687&employment_status=1&measure=1,2&measures=20100", flatten = TRUE)
nomiswfjobs <- as.data.frame(nomiswfjobs$obs)
nomiswfjobs <- nomiswfjobs[c(-1:-5, -7:-12, -14:-19, -21, -23:-29)]

nomisyears <- seq(as.Date("2015-12-31"), length = 3, by = "years")

nomiswfjobsengland <- subset(nomiswfjobs, geography.description == "England")
nomiswfjobsenglandcount <- subset(nomiswfjobsengland, measure.description == "Count")
nomiswfjobsenglandpercent <- subset(nomiswfjobsengland, measure.description == "Industry percentage")
nomiswfjobsenglandcount <- nomiswfjobsenglandcount[c(-1:-3)]
nomiswfjobsenglandpercent <- nomiswfjobsenglandpercent[c(-1:-3)]
nomiswfjobsenglandcountxts <- xts(x = nomiswfjobsenglandcount, order.by = nomisyears)
nomiswfjobsenglandpercentxts <- xts(x = nomiswfjobsenglandpercent, order.by = nomisyears)
colnames(nomiswfjobsenglandcountxts) <- "WF Jobs count - England"
colnames(nomiswfjobsenglandpercentxts) <- "WF Jobs % - England"

nomiswfjobsgb <- subset(nomiswfjobs, geography.description == "Great Britain")
nomiswfjobsgbcount <- subset(nomiswfjobsgb, measure.description == "Count")
nomiswfjobsgbcount <- nomiswfjobsgbcount[c(-1:-3)]
nomiswfjobsgbpercent <- subset(nomiswfjobsgb, measure.description == "Industry percentage")
nomiswfjobsgbpercent <- nomiswfjobsgbpercent[c(-1:-3)]
nomiswfjobsgbcountxts <- xts(x = nomiswfjobsgbcount, order.by = nomisyears)
nomiswfjobsgbpercentxts <- xts(x = nomiswfjobsgbpercent, order.by = nomisyears)
colnames(nomiswfjobsgbcountxts) <- "WF Jobs count - Great Britain"
colnames(nomiswfjobsgbpercentxts) <- "WF Jobs % - Great Britain"

nomiswfjobswales <- subset(nomiswfjobs, geography.description == "Wales")
nomiswfjobswalescount <- subset(nomiswfjobswales, measure.description == "Count")
nomiswfjobswalespercent <- subset(nomiswfjobswales, measure.description == "Industry percentage")
nomiswfjobswalescount <- nomiswfjobswalescount[c(-1:-3)]
nomiswfjobswalespercent <- nomiswfjobswalespercent[c(-1:-3)]
nomiswfjobswalescountxts <- xts(x = nomiswfjobswalescount, order.by = nomisyears)
nomiswfjobswalespercentxts <- xts(x = nomiswfjobswalespercent, order.by = nomisyears)
colnames(nomiswfjobswalescountxts) <- "WF Jobs count - Wales"
colnames(nomiswfjobswalespercentxts) <- "WF Jobs % - Wales"

nomiswfjobsscotland <- subset(nomiswfjobs, geography.description == "Scotland")
nomiswfjobsscotlandcount <- subset(nomiswfjobsscotland, measure.description == "Count")
nomiswfjobsscotlandpercent <- subset(nomiswfjobsscotland, measure.description == "Industry percentage")
nomiswfjobsscotlandcount <- nomiswfjobsscotlandcount[c(-1:-3)]
nomiswfjobsscotlandpercent <- nomiswfjobsscotlandpercent[c(-1:-3)]
nomiswfjobsscotlandcountxts <- xts(x = nomiswfjobsscotlandcount, order.by = nomisyears)
nomiswfjobsscotlandpercentxts <- xts(x = nomiswfjobsscotlandpercent, order.by = nomisyears)
colnames(nomiswfjobsscotlandcountxts) <- "WF Jobs count - Scotland"
colnames(nomiswfjobsscotlandpercentxts) <- "WF Jobs % - Scotland"

#Number of Shops
nomisunits <- fromJSON("https://www.nomisweb.co.uk/api/v01/dataset/NM_141_1.data.json?geography=2092957699,2092957702,2092957701,2092957697,2092957700&industry=138416743,138416751,138416753...138416758,138416761,138416762,138416773...138416775,138416783...138416786,138416791,138416793...138416797,138416803...138416811,138416813,138416814,138416821&employment_sizeband=0&legal_status=0&measures=20100", flatten = TRUE)
nomisunits <- as.data.frame(nomisunits$obs)
nomisunits <- nomisunits[c(-1:-5, -7:-8, -10:-20, -23:-29)]

nomisunitsyears <- seq(as.Date("2010-12-31"), length = 9, by = "years")

nomisunitsengland <- subset(nomisunits, geography.description == "England")
nomisunitsenglandtotal <- nomisunitsengland %>%
  group_by(time.description) %>%
  summarise(Total = sum(obs_value.value))
nomisunitsenglandtotal <- nomisunitsenglandtotal[c(-1)]
nomisunitsenglandtotalxts <- xts(x = nomisunitsenglandtotal, order.by = nomisunitsyears)
colnames(nomisunitsenglandtotalxts) <- "Local Units - England"

nomisunitsuk <- subset(nomisunits, geography.description == "United Kingdom")
nomisunitsuktotal <- nomisunitsuk %>%
  group_by(time.description) %>%
  summarise(Total = sum(obs_value.value))
nomisunitsuktotal <- nomisunitsuktotal[c(-1)]
nomisunitsuktotalxts <- xts(x = nomisunitsuktotal, order.by = nomisunitsyears)
colnames(nomisunitsuktotalxts) <- "Local Units - UK"

nomisunitswales <- subset(nomisunits, geography.description == "Wales")
nomisunitswalestotal <- nomisunitswales %>%
  group_by(time.description) %>%
  summarise(Total = sum(obs_value.value))
nomisunitswalestotal <- nomisunitswalestotal[c(-1)]
nomisunitswalestotalxts <- xts(x = nomisunitswalestotal, order.by = nomisunitsyears)
colnames(nomisunitswalestotalxts) <- "Local Units - Wales"

nomisunitsni <- subset(nomisunits, geography.description == "Northern Ireland")
nomisunitsnitotal <- nomisunitsni %>%
  group_by(time.description) %>%
  summarise(Total = sum(obs_value.value))
nomisunitsnitotal <- nomisunitsnitotal[c(-1)]
nomisunitsnitotalxts <- xts(x = nomisunitsnitotal, order.by = nomisunitsyears)
colnames(nomisunitsnitotalxts) <- "Local Units - Northern Ireland"

nomisunitsscotland <- subset(nomisunits, geography.description == "Scotland")
nomisunitsscotlandtotal <- nomisunitsscotland %>%
  group_by(time.description) %>%
  summarise(Total = sum(obs_value.value))
nomisunitsscotlandtotal <- nomisunitsscotlandtotal[c(-1)]
nomisunitsscotlandtotalxts <- xts(x = nomisunitsscotlandtotal, order.by = nomisunitsyears)
colnames(nomisunitsscotlandtotalxts) <- "Local Units - Scotland"


#Number of Businesses
nomisenterprises <- fromJSON("https://www.nomisweb.co.uk/api/v01/dataset/NM_142_1.data.json?geography=2092957699,2092957702,2092957701,2092957697,2092957700&industry=138416743,138416751,138416753...138416758,138416761,138416762,138416773...138416775,138416783...138416786,138416791,138416793...138416797,138416803...138416811,138416813,138416814,138416821&employment_sizeband=0&legal_status=0&measures=20100", flatten = TRUE)
nomisenterprises <- as.data.frame(nomisenterprises$obs)
nomisenterprises <- nomisenterprises[c(-1:-5, -7:-8, -10:-20, -23:-29)]

nomisenterprisesengland <- subset(nomisenterprises, geography.description == "England")
nomisenterprisesenglandtotal <- nomisenterprisesengland %>%
  group_by(time.description) %>%
  summarise(Total = sum(obs_value.value))
nomisenterprisesenglandtotal <- nomisenterprisesenglandtotal[c(-1)]
nomisenterprisesenglandtotalxts <- xts(x = nomisenterprisesenglandtotal, order.by = nomisunitsyears)
colnames(nomisenterprisesenglandtotalxts) <- "Businesses - England"

nomisenterprisesuk <- subset(nomisenterprises, geography.description == "United Kingdom")
nomisenterprisesuktotal <- nomisenterprisesuk %>%
  group_by(time.description) %>%
  summarise(Total = sum(obs_value.value))
nomisenterprisesuktotal <- nomisenterprisesuktotal[c(-1)]
nomisenterprisesuktotalxts <- xts(x = nomisenterprisesuktotal, order.by = nomisunitsyears)
colnames(nomisenterprisesuktotalxts) <- "Businesses - UK"

nomisenterpriseswales <- subset(nomisenterprises, geography.description == "Wales")
nomisenterpriseswalestotal <- nomisenterpriseswales %>%
  group_by(time.description) %>%
  summarise(Total = sum(obs_value.value))
nomisenterpriseswalestotal <- nomisenterpriseswalestotal[c(-1)]
nomisenterpriseswalestotalxts <- xts(x = nomisenterpriseswalestotal, order.by = nomisunitsyears)
colnames(nomisenterpriseswalestotalxts) <- "Businesses - Wales"

nomisenterprisesni <- subset(nomisenterprises, geography.description == "Northern Ireland")
nomisenterprisesnitotal <- nomisenterprisesni %>%
  group_by(time.description) %>%
  summarise(Total = sum(obs_value.value))
nomisenterprisesnitotal <- nomisenterprisesnitotal[c(-1)]
nomisenterprisesnitotalxts <- xts(x = nomisenterprisesnitotal, order.by = nomisunitsyears)
colnames(nomisenterprisesnitotalxts) <- "Businesses - Northern Ireland"

nomisenterprisesscotland <- subset(nomisenterprises, geography.description == "Scotland")
nomisenterprisesscotlandtotal <- nomisenterprisesscotland %>%
  group_by(time.description) %>%
  summarise(Total = sum(obs_value.value))
nomisenterprisesscotlandtotal <- nomisenterprisesscotlandtotal[c(-1)]
nomisenterprisesscotlandtotalxts <- xts(x = nomisenterprisesscotlandtotal, order.by = nomisunitsyears)
colnames(nomisenterprisesscotlandtotalxts) <- "Businesses - Scotland"


#### ASHE Data ####

# Whole Economy Time-Series

url <- "https://www.nomisweb.co.uk/api/v01/dataset/NM_99_1.data.csv?geography=2092957699,2092957697,2013265921...2013265932&sex=1...9&item=1...3&pay=6&measures=20100,20701"
loc.download <- "ashe.csv"
download.file(url,loc.download,mode = "wb")
ashe <- "ashe.csv"
ashe_all <- read.csv(ashe, header = TRUE, sep = ",")
ashe_all <- ashe_all %>%
  filter(MEASURES_NAME == "Value")
ashe_all2 <- select(ashe_all, c(2, 8, 14, 26, 33))
ashe_all2$Title <- paste(ashe_all2$GEOGRAPHY_NAME, ashe_all2$SEX_NAME, ashe_all2$ITEM_NAME, sep = " ")
ashe_all2 <- select(ashe_all2, c(DATE_NAME, Title, OBS_VALUE))
ashe_all3 <- melt(ashe_all2, id = c("DATE_NAME", "Title"))
ashe_region <- cast(ashe_all3, DATE_NAME~Title+variable)
asheyears <- seq(as.Date("1997-12-31"), length = 22, by = "years")
ashe_regionxts <- xts(x = ashe_region, order.by = asheyears)

# ASHE Table 4.6a: Hourly pay - Excluding overtime (£) - Including Industry Breakdown (but no time-series)

url <- "https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/industry2digitsicashetable4/2018provisional/table42018provisional.zip"
loc.download <- "ashe4.zip"
download.file(url,loc.download,mode = "wb")
ashe4 <- "ashe4.zip"
unzip("ashe4.zip")

AsheAll <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A6:E6", col_names = FALSE)
AsheRetail <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A60:E60", col_names = FALSE)
AsheMaleAll <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A6:E6", col_names = FALSE)
AsheMaleRetail <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A60:E60", col_names = FALSE)
AsheFemaleAll <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A6:E6", col_names = FALSE)
AsheFemaleRetail <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A60:E60", col_names = FALSE)
AsheFullAll <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A6:E6", col_names = FALSE)
AsheFullRetail <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A60:E60", col_names = FALSE)
AshePartAll <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A6:E6", col_names = FALSE)
AshePartRetail <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A60:E60", col_names = FALSE)
AsheMaleFullAll <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A6:E6", col_names = FALSE)
AsheMaleFullRetail <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A60:E60", col_names = FALSE)
AsheMalePartAll <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A6:E6", col_names = FALSE)
AsheMalePartRetail <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A60:E60", col_names = FALSE)
AsheFemaleFullAll <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A6:E6", col_names = FALSE)
AsheFemaleFullRetail <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A60:E60", col_names = FALSE)
AsheFemalePartAll <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A6:E6", col_names = FALSE)
AsheFemalePartRetail <- read_excel("PROV - SIC07 Industry (2) SIC2007 Table 4.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A60:E60", col_names = FALSE)

# ASHE Table 5.6a: Hourly pay - Excluding overtime (£)

url <- "https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/regionbyindustry2digitsicashetable5/2018provisional/table52018provisional.zip"
loc.download <- "ashe5.zip"
download.file(url,loc.download,mode = "wb")
ashe5 <- "ashe5.zip"
unzip("ashe5.zip")

#All

AsheEnglandAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A9:E9", col_names = FALSE)
AsheNorthEastAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A10:E10", col_names = FALSE)
AsheNorthWestAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A11:E11", col_names = FALSE)
AsheYorkhumbAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A12:E12", col_names = FALSE)
AsheEastMidAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A13:E13", col_names = FALSE)
AsheWestMidAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A14:E14", col_names = FALSE)
AsheEastAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A15:E15", col_names = FALSE)
AsheLondonAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A16:E16", col_names = FALSE)
AsheSouthEastAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A17:E17", col_names = FALSE)
AsheSouthWestAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A18:E18", col_names = FALSE)
AsheWalesAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A19:E19", col_names = FALSE)
AsheScotlandAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A20:E20", col_names = FALSE)
AsheNorthIreAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A21:E21", col_names = FALSE)

AsheNorthEastRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A188:E188", col_names = FALSE)
AsheNorthWestRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A301:E301", col_names = FALSE)
AsheYorkhumbRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A414:E414", col_names = FALSE)
AsheEastMidRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A527:E527", col_names = FALSE)
AsheWestMidRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A640:E640", col_names = FALSE)
AsheEastRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A753:E753", col_names = FALSE)
AsheLondonRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A866:E866", col_names = FALSE)
AsheSouthEastRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A979:E979", col_names = FALSE)
AsheSouthWestRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A1092:E1092", col_names = FALSE)
AsheWalesRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A1205:E1205", col_names = FALSE)
AsheScotlandRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 2, range = "A1318:E1318", col_names = FALSE)

#Male

AsheEnglandMaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A9:E9", col_names = FALSE)
AsheNorthEastMaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A10:E10", col_names = FALSE)
AsheNorthWestMaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A11:E11", col_names = FALSE)
AsheYorkhumbMaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A12:E12", col_names = FALSE)
AsheEastMidMaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A13:E13", col_names = FALSE)
AsheWestMidMaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A14:E14", col_names = FALSE)
AsheEastMaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A15:E15", col_names = FALSE)
AsheLondonMaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A16:E16", col_names = FALSE)
AsheSouthEastMaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A17:E17", col_names = FALSE)
AsheSouthWestMaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A18:E18", col_names = FALSE)
AsheWalesMaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A19:E19", col_names = FALSE)
AsheScotlandMaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A20:E20", col_names = FALSE)
AsheNorthIreMaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A21:E21", col_names = FALSE)

AsheNorthEastMaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A188:E188", col_names = FALSE)
AsheNorthWestMaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A301:E301", col_names = FALSE)
AsheYorkhumbMaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A414:E414", col_names = FALSE)
AsheEastMidMaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A527:E527", col_names = FALSE)
AsheWestMidMaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A640:E640", col_names = FALSE)
AsheEastMaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A753:E753", col_names = FALSE)
AsheLondonMaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A866:E866", col_names = FALSE)
AsheSouthEastMaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A979:E979", col_names = FALSE)
AsheSouthWestMaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A1092:E1092", col_names = FALSE)
AsheWalesMaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A1205:E1205", col_names = FALSE)
AsheScotlandMaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 3, range = "A1318:E1318", col_names = FALSE)

#Female

AsheEnglandFemaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A9:E9", col_names = FALSE)
AsheNorthEastFemaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A10:E10", col_names = FALSE)
AsheNorthWestFemaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A11:E11", col_names = FALSE)
AsheYorkhumbFemaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A12:E12", col_names = FALSE)
AsheEastMidFemaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A13:E13", col_names = FALSE)
AsheWestMidFemaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A14:E14", col_names = FALSE)
AsheEastFemaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A15:E15", col_names = FALSE)
AsheLondonFemaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A16:E16", col_names = FALSE)
AsheSouthEastFemaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A17:E17", col_names = FALSE)
AsheSouthWestFemaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A18:E18", col_names = FALSE)
AsheWalesFemaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A19:E19", col_names = FALSE)
AsheScotlandFemaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A20:E20", col_names = FALSE)
AsheNorthIreFemaleAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A21:E21", col_names = FALSE)

AsheNorthEastFemaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A188:E188", col_names = FALSE)
AsheNorthWestFemaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A301:E301", col_names = FALSE)
AsheYorkhumbFemaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A414:E414", col_names = FALSE)
AsheEastMidFemaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A527:E527", col_names = FALSE)
AsheWestMidFemaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A640:E640", col_names = FALSE)
AsheEastFemaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A753:E753", col_names = FALSE)
AsheLondonFemaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A866:E866", col_names = FALSE)
AsheSouthEastFemaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A979:E979", col_names = FALSE)
AsheSouthWestFemaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A1092:E1092", col_names = FALSE)
AsheWalesFemaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A1205:E1205", col_names = FALSE)
AsheScotlandFemaleRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 4, range = "A1318:E1318", col_names = FALSE)

# Full-Time

AsheEnglandFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A9:E9", col_names = FALSE)
AsheNorthEastFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A10:E10", col_names = FALSE)
AsheNorthWestFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A11:E11", col_names = FALSE)
AsheYorkhumbFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A12:E12", col_names = FALSE)
AsheEastMidFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A13:E13", col_names = FALSE)
AsheWestMidFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A14:E14", col_names = FALSE)
AsheEastFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A15:E15", col_names = FALSE)
AsheLondonFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A16:E16", col_names = FALSE)
AsheSouthEastFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A17:E17", col_names = FALSE)
AsheSouthWestFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A18:E18", col_names = FALSE)
AsheWalesFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A19:E19", col_names = FALSE)
AsheScotlandFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A20:E20", col_names = FALSE)
AsheNorthIreFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A21:E21", col_names = FALSE)

AsheNorthEastFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A188:E188", col_names = FALSE)
AsheNorthWestFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A301:E301", col_names = FALSE)
AsheYorkhumbFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A414:E414", col_names = FALSE)
AsheEastMidFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A527:E527", col_names = FALSE)
AsheWestMidFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A640:E640", col_names = FALSE)
AsheEastFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A753:E753", col_names = FALSE)
AsheLondonFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A866:E866", col_names = FALSE)
AsheSouthEastFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A979:E979", col_names = FALSE)
AsheSouthWestFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A1092:E1092", col_names = FALSE)
AsheWalesFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A1205:E1205", col_names = FALSE)
AsheScotlandFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 5, range = "A1318:E1318", col_names = FALSE)

# Part-Time

AsheEnglandPartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A9:E9", col_names = FALSE)
AsheNorthEastPartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A10:E10", col_names = FALSE)
AsheNorthWestPartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A11:E11", col_names = FALSE)
AsheYorkhumbPartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A12:E12", col_names = FALSE)
AsheEastMidPartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A13:E13", col_names = FALSE)
AsheWestMidPartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A14:E14", col_names = FALSE)
AsheEastPartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A15:E15", col_names = FALSE)
AsheLondonPartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A16:E16", col_names = FALSE)
AsheSouthEastPartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A17:E17", col_names = FALSE)
AsheSouthWestPartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A18:E18", col_names = FALSE)
AsheWalesPartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A19:E19", col_names = FALSE)
AsheScotlandPartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A20:E20", col_names = FALSE)
AsheNorthIrePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A21:E21", col_names = FALSE)

AsheNorthEastPartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A188:E188", col_names = FALSE)
AsheNorthWestPartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A301:E301", col_names = FALSE)
AsheYorkhumbPartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A414:E414", col_names = FALSE)
AsheEastMidPartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A527:E527", col_names = FALSE)
AsheWestMidPartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A640:E640", col_names = FALSE)
AsheEastPartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A753:E753", col_names = FALSE)
AsheLondonPartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A866:E866", col_names = FALSE)
AsheSouthEastPartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A979:E979", col_names = FALSE)
AsheSouthWestPartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A1092:E1092", col_names = FALSE)
AsheWalesPartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A1205:E1205", col_names = FALSE)
AsheScotlandPartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 6, range = "A1318:E1318", col_names = FALSE)

# Male Full-Time

AsheEnglandMaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A9:E9", col_names = FALSE)
AsheNorthEastMaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A10:E10", col_names = FALSE)
AsheNorthWestMaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A11:E11", col_names = FALSE)
AsheYorkhumbMaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A12:E12", col_names = FALSE)
AsheEastMidMaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A13:E13", col_names = FALSE)
AsheWestMidMaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A14:E14", col_names = FALSE)
AsheEastMaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A15:E15", col_names = FALSE)
AsheLondonMaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A16:E16", col_names = FALSE)
AsheSouthEastMaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A17:E17", col_names = FALSE)
AsheSouthWestMaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A18:E18", col_names = FALSE)
AsheWalesMaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A19:E19", col_names = FALSE)
AsheScotlandMaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A20:E20", col_names = FALSE)
AsheNorthIreMaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A21:E21", col_names = FALSE)

AsheNorthEastMaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A188:E188", col_names = FALSE)
AsheNorthWestMaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A301:E301", col_names = FALSE)
AsheYorkhumbMaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A414:E414", col_names = FALSE)
AsheEastMidMaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A527:E527", col_names = FALSE)
AsheWestMidMaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A640:E640", col_names = FALSE)
AsheEastMaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A753:E753", col_names = FALSE)
AsheLondonMaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A866:E866", col_names = FALSE)
AsheSouthEastMaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A979:E979", col_names = FALSE)
AsheSouthWestMaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A1092:E1092", col_names = FALSE)
AsheWalesMaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A1205:E1205", col_names = FALSE)
AsheScotlandMaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 7, range = "A1318:E1318", col_names = FALSE)

# Male Part-Time

AsheEnglandMalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A9:E9", col_names = FALSE)
AsheNorthEastMalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A10:E10", col_names = FALSE)
AsheNorthWestMalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A11:E11", col_names = FALSE)
AsheYorkhumbMalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A12:E12", col_names = FALSE)
AsheEastMidMalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A13:E13", col_names = FALSE)
AsheWestMidMalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A14:E14", col_names = FALSE)
AsheEastMalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A15:E15", col_names = FALSE)
AsheLondonMalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A16:E16", col_names = FALSE)
AsheSouthEastMalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A17:E17", col_names = FALSE)
AsheSouthWestMalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A18:E18", col_names = FALSE)
AsheWalesMalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A19:E19", col_names = FALSE)
AsheScotlandMalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A20:E20", col_names = FALSE)
AsheNorthIreMalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A21:E21", col_names = FALSE)

AsheNorthEastMalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A188:E188", col_names = FALSE)
AsheNorthWestMalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A301:E301", col_names = FALSE)
AsheYorkhumbMalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A414:E414", col_names = FALSE)
AsheEastMidMalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A527:E527", col_names = FALSE)
AsheWestMidMalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A640:E640", col_names = FALSE)
AsheEastMalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A753:E753", col_names = FALSE)
AsheLondonMalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A866:E866", col_names = FALSE)
AsheSouthEastMalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A979:E979", col_names = FALSE)
AsheSouthWestMalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A1092:E1092", col_names = FALSE)
AsheWalesMalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A1205:E1205", col_names = FALSE)
AsheScotlandMalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 8, range = "A1318:E1318", col_names = FALSE)

# Female Full-Time

AsheEnglandFemaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A9:E9", col_names = FALSE)
AsheNorthEastFemaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A10:E10", col_names = FALSE)
AsheNorthWestFemaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A11:E11", col_names = FALSE)
AsheYorkhumbFemaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A12:E12", col_names = FALSE)
AsheEastMidFemaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A13:E13", col_names = FALSE)
AsheWestMidFemaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A14:E14", col_names = FALSE)
AsheEastFemaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A15:E15", col_names = FALSE)
AsheLondonFemaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A16:E16", col_names = FALSE)
AsheSouthEastFemaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A17:E17", col_names = FALSE)
AsheSouthWestFemaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A18:E18", col_names = FALSE)
AsheWalesFemaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A19:E19", col_names = FALSE)
AsheScotlandFemaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A20:E20", col_names = FALSE)
AsheNorthIreFemaleFullAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A21:E21", col_names = FALSE)

AsheNorthEastFemaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A188:E188", col_names = FALSE)
AsheNorthWestFemaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A301:E301", col_names = FALSE)
AsheYorkhumbFemaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A414:E414", col_names = FALSE)
AsheEastMidFemaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A527:E527", col_names = FALSE)
AsheWestMidFemaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A640:E640", col_names = FALSE)
AsheEastFemaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A753:E753", col_names = FALSE)
AsheLondonFemaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A866:E866", col_names = FALSE)
AsheSouthEastFemaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A979:E979", col_names = FALSE)
AsheSouthWestFemaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A1092:E1092", col_names = FALSE)
AsheWalesMaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A1205:E1205", col_names = FALSE)
AsheScotlandFemaleFullRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 9, range = "A1318:E1318", col_names = FALSE)

# Female Part-Time

AsheEnglandFemalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A9:E9", col_names = FALSE)
AsheNorthEastFemalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A10:E10", col_names = FALSE)
AsheNorthWestFemalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A11:E11", col_names = FALSE)
AsheYorkhumbFemalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A12:E12", col_names = FALSE)
AsheEastMidFemalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A13:E13", col_names = FALSE)
AsheWestMidFemalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A14:E14", col_names = FALSE)
AsheEastFemalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A15:E15", col_names = FALSE)
AsheLondonFemalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A16:E16", col_names = FALSE)
AsheSouthEastFemalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A17:E17", col_names = FALSE)
AsheSouthWestFemalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A18:E18", col_names = FALSE)
AsheWalesFemalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A19:E19", col_names = FALSE)
AsheScotlandFemalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A20:E20", col_names = FALSE)
AsheNorthIreFemalePartAll <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A21:E21", col_names = FALSE)

AsheNorthEastFemalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A188:E188", col_names = FALSE)
AsheNorthWestFemalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A301:E301", col_names = FALSE)
AsheYorkhumbFemalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A414:E414", col_names = FALSE)
AsheEastMidFemalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A527:E527", col_names = FALSE)
AsheWestMidFemalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A640:E640", col_names = FALSE)
AsheEastFemalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A753:E753", col_names = FALSE)
AsheLondonFemalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A866:E866", col_names = FALSE)
AsheSouthEastFemalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A979:E979", col_names = FALSE)
AsheSouthWestFemalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A1092:E1092", col_names = FALSE)
AsheWalesFemalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A1205:E1205", col_names = FALSE)
AsheScotlandFemalePartRetail <- read_excel("PROV - SIC07 Work Region Industry (2) SIC2007 Table 5.6a   Hourly pay - Excluding overtime 2018.xls", sheet = 10, range = "A1318:E1318", col_names = FALSE)


#### House Prices ####

# London

#Where to look
endpoint <- "http://landregistry.data.gov.uk/landregistry/query"

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/london> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/london> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPlondon <- SPARQL(endpoint,query)$results

#Create date variable
HPlondon$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPlondon), by="1 month") - 1

#Convert to xts
HPlondon <- xts(x=HPlondon[3:6], order.by=HPlondon$ukhpi_refMonth)
colnames(HPlondon) <- c("House Price Average - London", "House Price Index - London", "House Price YoY - London", "House Price MoM - London")


# Scotland

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/scotland> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/scotland> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPscotland <- SPARQL(endpoint,query)$results

#Create date variable
HPscotland$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPscotland), by="1 month") - 1

#Convert to xts
HPscotland <- xts(x=HPscotland[3:6], order.by=HPscotland$ukhpi_refMonth)
colnames(HPscotland) <- c("House Price Average - Scotland", "House Price Index - Scotland", "House Price YoY - Scotland", "House Price MoM - Scotland")


# House Prices - Wales

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/wales> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/wales> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPwales <- SPARQL(endpoint,query)$results

#Create date variable
HPwales$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPwales), by="1 month") - 1

#Convert to xts
HPwales <- xts(x=HPwales[3:6], order.by=HPwales$ukhpi_refMonth)
colnames(HPwales) <- c("House Price Average - Wales", "House Price Index - Wales", "House Price YoY - Wales", "House Price MoM - Wales")


# House Prices - Northern Ireland

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/northern-ireland> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/northern-ireland> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPnorthern_ireland <- SPARQL(endpoint,query)$results

#Create date variable
HPnorthern_ireland$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPnorthern_ireland), by="1 month") - 1

#Convert to xts
HPnorthern_ireland <- xts(x=HPnorthern_ireland[3:6], order.by=HPnorthern_ireland$ukhpi_refMonth)
colnames(HPnorthern_ireland) <- c("House Price Average - Northern Ireland", "House Price Index - Northern Ireland", "House Price YoY - Northern Ireland", "House Price MoM - Northern Ireland")


# House Prices - England

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/england> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/england> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPengland <- SPARQL(endpoint,query)$results

#Create date variable
HPengland$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPengland), by="1 month") - 1

#Convert to xts
HPengland <- xts(x=HPengland[3:6], order.by=HPengland$ukhpi_refMonth)
colnames(HPengland) <- c("House Price Average - England", "House Price Index - England", "House Price YoY - England", "House Price MoM - England")


# House Prices - North East

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/north-east> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/north-east> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPnortheast <- SPARQL(endpoint,query)$results

#Create date variable
HPnortheast$ukhpi_refMonth <- seq(as.Date("1992-05-01"), length.out = nrow(HPnortheast), by="1 month") - 1

#Convert to xts
HPnortheast <- xts(x=HPnortheast[3:6], order.by=HPnortheast$ukhpi_refMonth)
colnames(HPnortheast) <- c("House Price Average - North East", "House Price Index - North East", "House Price YoY - North East", "House Price MoM - North East")


# House Prices - North West

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/north-west> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/north-west> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPnorthwest <- SPARQL(endpoint,query)$results

#Create date variable
HPnorthwest$ukhpi_refMonth <- seq(as.Date("1995-02-01"), length.out = nrow(HPnorthwest), by="1 month") - 1

#Convert to xts
HPnorthwest <- xts(x=HPnorthwest[3:6], order.by=HPnorthwest$ukhpi_refMonth)
colnames(HPnorthwest) <- c("House Price Average - North West", "House Price Index - North West", "House Price YoY - North West", "House Price MoM - North West")


# House Prices - Yorkshire & the Humber

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/yorkshire-and-the-humber> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/yorkshire-and-the-humber> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPyork <- SPARQL(endpoint,query)$results

#Create date variable
HPyork$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPyork), by="1 month") - 1

#Convert to xts
HPyork <- xts(x=HPyork[3:6], order.by=HPyork$ukhpi_refMonth)
colnames(HPyork) <- c("House Price Average - Yorkshire & the Humber", "House Price Index - Yorkshire & the Humber", "House Price YoY - Yorkshire & the Humber", "House Price MoM - Yorkshire & the Humber")


# House Prices - East Midlands

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/east-midlands> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/east-midlands> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPeastmid <- SPARQL(endpoint,query)$results

#Create date variable
HPeastmid$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPeastmid), by="1 month") - 1

#Convert to xts
HPeastmid <- xts(x=HPeastmid[3:6], order.by=HPeastmid$ukhpi_refMonth)
colnames(HPeastmid) <- c("House Price Average - East Midlands", "House Price Index - East Midlands", "House Price YoY - East Midlands", "House Price MoM - East Midlands")


# House Prices - West Midlands

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/west-midlands> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/west-midlands> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPwestmid <- SPARQL(endpoint,query)$results

#Create date variable
HPwestmid$ukhpi_refMonth <- seq(as.Date("1995-02-01"), length.out = nrow(HPwestmid), by="1 month") - 1

#Convert to xts
HPwestmid <- xts(x=HPwestmid[3:6], order.by=HPwestmid$ukhpi_refMonth)
colnames(HPwestmid) <- c("House Price Average - West Midlands", "House Price Index - West Midlands", "House Price YoY - West Midlands", "House Price MoM - West Midlands")


# House Prices - East

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/east-of-england> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/east-of-england> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPeast <- SPARQL(endpoint,query)$results

#Create date variable
HPeast$ukhpi_refMonth <- seq(as.Date("1992-05-01"), length.out = nrow(HPeast), by="1 month") - 1

#Convert to xts
HPeast <- xts(x=HPeast[3:6], order.by=HPeast$ukhpi_refMonth)
colnames(HPeast) <- c("House Price Average - East", "House Price Index - East", "House Price YoY - East", "House Price MoM - East")


# House Prices - South East

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/south-east> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/south-east> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPsoutheast <- SPARQL(endpoint,query)$results

#Create date variable
HPsoutheast$ukhpi_refMonth <- seq(as.Date("1992-05-01"), length.out = nrow(HPsoutheast), by="1 month") - 1

#Convert to xts
HPsoutheast <- xts(x=HPsoutheast[3:6], order.by=HPsoutheast$ukhpi_refMonth)
colnames(HPsoutheast) <- c("House Price Average - South East", "House Price Index - South East", "House Price YoY - South East", "House Price MoM - South East")


# House Prices - South West

#What to look for
query <- "PREFIX  xsd:  <http://www.w3.org/2001/XMLSchema#>
PREFIX  ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>

SELECT  ?ukhpi_refMonth ?ukhpi_refRegion ?ukhpi_averagePrice ?ukhpi_housePriceIndex ?ukhpi_percentageAnnualChange ?ukhpi_percentageChange
WHERE
{ { SELECT  ?ukhpi_refMonth ?item
WHERE
{ ?item  ukhpi:refRegion  <http://landregistry.data.gov.uk/id/region/south-west> ;
ukhpi:refMonth   ?ukhpi_refMonth
FILTER ( ?ukhpi_refMonth >= '1990-01'^^xsd:gYearMonth )
}
ORDER BY ?ukhpi_refMonth
}
OPTIONAL
{ ?item  ukhpi:averagePrice  ?ukhpi_averagePrice }
OPTIONAL
{ ?item  ukhpi:housePriceIndex  ?ukhpi_housePriceIndex }
OPTIONAL
{ ?item  ukhpi:percentageAnnualChange  ?ukhpi_percentageAnnualChange }
OPTIONAL
{ ?item  ukhpi:percentageChange  ?ukhpi_percentageChange }

BIND(<http://landregistry.data.gov.uk/id/region/south-west> AS ?ukhpi_refRegion)
}"

#Parse Data 
HPsouthwest <- SPARQL(endpoint,query)$results

#Create date variable
HPsouthwest$ukhpi_refMonth <- seq(as.Date("1990-02-01"), length.out = nrow(HPsouthwest), by="1 month") - 1

#Convert to xts
<<<<<<< HEAD
HPsouthwest <- xts(x=HPsouthwest, order.by=HPsouthwest$ukhpi_refMonth)

#### DRI Data ####

source("DRIData.R")

#,"XLConnect","rJava", "ReporteRs"
#enter last date you wish to upload for
endate= ISOdate(2018,12,1)

#add bespoke endates for monitors particularly when data have been entered into workbooks but not published
#must be a date after 2017,11,01
endateRSM=ISOdate(2018,12,1)
endateFF=ISOdate(2018,12,1)
endateDRI=ISOdate(2018,12,1)

adddate=length(seq(from=ISOdate(2017,11,1), to=endate, by="months"))-1 
adddateRSM=length(seq(from=ISOdate(2017,11,1), to=endateRSM, by="months"))-1
adddateFF=length(seq(from=ISOdate(2017,11,1), to=endateFF, by="months"))-1 
adddateDRI=length(seq(from=ISOdate(2017,11,1), to=endateDRI, by="months"))-1 



##functions
#rollingweighted average

rollweightedav <- function(x,y,z,n){
  new=0
  for (i in n:nrow(x) ){
    a= crossprod(x[(i-(n-1)):i,y],x[(i-(n-1)):i,z])/sum(x[(i-(n-1)):i,z])
    new=cbind(new,a)
  }
  
  var=append(rep(NA,n-1),new[-1])
  var_new=as.numeric(var)     
  return(var_new)
}

# format numbers
scaleFUN <- function(x) sprintf("%.1f", x)

setwd("Z:/Projects/RDataAggregation/")

# Read-in DRI

DRI_Master=read.csv("DRI Master.csv")
DRI_Master=DRI_Master[,c("Mobile_Total.Retail_Share","Total.Retail_Total.Retail_Total.Visits")]

DRI_Master=change(DRI_Master,Var="Total.Retail_Total.Retail_Total.Visits" ,TimeVar="date",NewVar = paste("Visit_growth", sep="_"),slideBy=-12, type="percent")

DRI_Master=DRI_Master[,c("Mobile_Total.Retail_Share","Visit_growth")]
DRI_Master$date<-(seq(ISOdate(2014,08,1), by = "month", length.out = nrow(DRI_Master)))
names(DRI_Master)[1:2]=c("BRC-Hitwise Mobile Share of retail website visits (%)","BRC-Hitwise Growth in retailer website visits (yoy %)")

DRI_Master[,c("BRC-Hitwise Mobile Share of retail website visits (%)")]=DRI_Master[,c("BRC-Hitwise Mobile Share of retail website visits (%)")]*100

# REM

REM = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMasterRebuild201710 (Autosaved).xlsm",range="'Headlines & Charts'!e22:dn22",col_names = FALSE,col_types="numeric")*100))

# Footfall

FF=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!k6:k",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!q6:q",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_12mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!s6:s",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100

FF_Highst=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!h6:h",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_ShoppingCentre=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!j6:j",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_RetailPark=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!i6:i",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100

FF_Highst3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!m6:m",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_ShoppingCentre3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!o6:o",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100
FF_RetailPark3mth=read_excel("Z:/Monitors/ff/Data/FootfallMasterWeighted.xlsx",range=paste("Annual!n6:n",93+adddateFF,sep=""),col_names = FALSE,col_types="numeric")*100


FF=cbind(FF,FF_3mth,FF_12mth,FF_Highst,FF_ShoppingCentre,FF_RetailPark,FF_Highst3mth,FF_ShoppingCentre3mth,FF_RetailPark3mth)

# RSM

RSM=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!cf8:cf",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ub8:ub",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_12mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!zc8:zc",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_Online=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!dm8:dm",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_Online_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ej8:ej",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_Online_12mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!fg8:fg",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!av8:av",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_Stores=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!adf8:adf",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL_Stores=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!adi8:adi",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!sp8:sp",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL_Food_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!sn8:sn",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL_NF_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!so8:so",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100

RSM_Food_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!tz8:tz",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_NF_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ua8:ua",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_weeks=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!k8:k",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")

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

names(FF)[1]="Footfall UK (% yoy change):BRC-Springboard"
names(FF)[2]="Footfall UK 3 month average (% yoy change):BRC-Springboard"
names(FF)[3]="Footfall UK 12 month average (% yoy change):BRC-Springboard"
names(FF)[4]="Footfall High Street (% yoy change):BRC-Springboard"
names(FF)[5]="Footfall Shopping Centre (% yoy change):BRC-Springboard"
names(FF)[6]="Footfall Retail Park (% yoy change):BRC-Springboard"
names(FF)[7]="Footfall High Street 3 month average (% yoy change):BRC-Springboard"
names(FF)[8]="Footfall Shopping Centre 3 month average (% yoy change):BRC-Springboard"
names(FF)[9]="Footfall Retail Park 3 month average (% yoy change):BRC-Springboard"
=======
HPsouthwest <- xts(x=HPsouthwest[3:6], order.by=HPsouthwest$ukhpi_refMonth)
colnames(HPsouthwest) <- c("House Price Average - South West", "House Price Index - South West", "House Price YoY - South West", "House Price MoM - South West")
>>>>>>> 2a8ea151ded810230940eadd2405b8e7a0d24a11


#### Consumer Price Inflation ####

<<<<<<< HEAD
#setwd("C:/Users/James.Hardiman/Documents/DatabaseBuild")
=======
# ONS Consumer Price Inflation Annual Data (MM23) - Definitions
>>>>>>> 2a8ea151ded810230940eadd2405b8e7a0d24a11

# "D7G7" = All Items

###ALL FOOD
# "D7G8" = Food and Non-Alcoholic Beverages
# "D7GM" = Alcoholic Beverages

###AMBIENT FOOD
# "D7GM" = Alcoholoic Beverages
# "L7JM" = Rice
# "L7JN" = Flours and other cereals
# "L7JP" = Other bakery products
# "L7JT" = Pasta products and couscous
# "L7JU" = Breakfast cereals and other cereal products
# "D7GL" = Non-Alcoholic Beverages
# "D7HO" = Sugar, jam, honey, syrups, chocolates and confectionery
# "L7L6" = potato crisps and snacks

###FRESH Food
# "L7JO" = Bread
# "L7JQ" = Pizza and quiche
# "D7HJ" = Fish
# "D7HM" = Fruit
# "D7HI" = Meat
# "D7HK" = Milk, Cheese and Eggs
# "L7KS" = Butter
# "L7L5" = Potatoes
# "L7L2" = Fresh or chilled vegetables other than potatoes and other tubers


###CLOTHING & FOOTWEAR
# "D7GA" = Clothing and Footwear

###HEALTH & BEAUTY
# "D7JD" = Appliances and Products for Personal Care
# "D7NP" = Pharmaceutical products

###DIY, GARDENING & HARDWARE
# "D7GY" = Tools and Equipment for House and Garden

###FURNITURE & FLOORING
# "D7GU" = Furniture, Furnishings and Carpets
# "D7GV" = Household Textiles

###ELECTRICALS
# "D7IF" = Major Appliances and Small Electric Goods
# "D7IZ" = Reception and reproduction of sound and pictures
# "D7J2" = Photographic, cinematographic and optical equipment
# "D7J3" = Data processing equipment

###BOOKS, STATIONERY & HOME ENTERTAINMENT
# "D7O3" = Books, Newspapers and Stationery
# "D7J6" = Recording media

###OTHER NON-FOOD
# "D7NX" = Games, Toys and Hobbies
# "D7NY" = Equipment for sport and open-air recreation
# "L7SL" = Purchase of pets 
# "L7SM" = Products for Pets
# "D7O8" = Personal Effects
# "D7GN" = Tobacco

# CPI Data
cpi <- pdfetch_ONS(c("D7G7", 
                     "D7G8", "D7GM", 
                     "L7JM", "L7JN", "L7JP", "L7JT", "L7JU", "D7GL", "D7HO", "L7L6",
                     "L7JO", "L7JQ", "D7HJ", "D7HM", "D7HI", "D7HK", "L7KS", "L7L5", "L7L2",
                     "D7GA",
                     "D7JD", "D7NP",
                     "D7GY",
                     "D7GU", "D7GV",
                     "D7IF", "D7IZ", "D7J2", "D7J3",
                     "D7O3", "D7J6",
                     "D7NX", "D7NY", "L7SL", "L7SM", "D7O8", "D7GN"
), "MM23")


# ONS Consumer Price Inflation Weights (MM23) - Definitions

# "CHZQ" = All Items

###ALL FOOD
# "CHZR" = Food and Non-Alcoholic Beverages
# "CJUZ" = Alcoholic Beverages

###AMBIENT FOOD
# "CJUZ" = Alcoholoic Beverages
# "L83B" = Rice
# "L83C" = Flours and other cereals
# "L83S" = Other bakery products
# "L844" = Pasta products and couscous
# "L846" = Breakfast cereals and other cereal products
# "CJUY" = Non-Alcoholic Beverages
# "CJWI" = Sugar, jam, honey, syrups, chocolates and confectionery
# "L859" = potato crisps and snacks

###FRESH Food
# "L83H" = Bread
# "L83T" = Pizza and quiche
# "CJWD" = Fish
# "CJWG" = Fruit
# "CJWC" = Meat
# "CJWE" = Milk, Cheese and Eggs
# "L84P" = Butter
# "L858" = Potatoes
# "L853" = Fresh or chilled vegetables other than potatoes and other tubers


###CLOTHING & FOOTWEAR
# "CHZT" = Clothing and Footwear

###HEALTH & BEAUTY
# "CJYO" = Appliances and Products for Personal Care
# "CJYA" = Pharmaceutical products

###DIY, GARDENING & HARDWARE
# "CJVK" = Tools and Equipment for House and Garden

###FURNITURE & FLOORING
# "CJVG" = Furniture, Furnishings and Carpets
# "CJVH" = Household Textiles

###ELECTRICALS
# "CJXI" = Major Appliances and Small Electric Goods
# "CJYC" = Reception and reproduction of sound and pictures
# "CJYD" = Photographic, cinematographic and optical equipment
# "CJYE" = Data processing equipment

###BOOKS, STATIONERY & HOME ENTERTAINMENT
# "ICVT" = Books, Newspapers and Stationery
# "CJYF" = Recording media

###OTHER NON-FOOD
# "ICVP" = Games, Toys and Hobbies
# "ICVQ" = Equipment for sport and open-air recreation
# "L8CZ" = Purchase of pets 
# "L8D2" = Products for Pets
# "CJVX" = Personal Effects
# "CJWP" = Tobacco

# Get CPI Weights
w_cpi <- pdfetch_ONS(c("CHZQ", 
                       "CHZR", "CJUZ", 
                       "L83B", "L83C", "L83S", "L844", "L846", "CJUY", "CJWI", "L859", 
                       "L83H", "L83T", "CJWD", "CJWG", "CJWC", "CJWE", "L84P", "L858", "L853", 
                       "CHZT", 
                       "CJYO", "CJYA", 
                       "CJVK", 
                       "CJVG", "CJVH", 
                       "CJXI", "CJYC", "CJYD", "CJYE", 
                       "ICVT", "CJYF", 
                       "ICVP", "ICVQ", "L8CZ", "L8D2", "CJVX", "CJWP"
), "MM23")


#merge and fill in blank datapoints between weights changes (fills in points after last recorded point & before first recorded point)
cpi <- merge(cpi, w_cpi, join = "outer")
cpi <- na.locf(cpi)
cpi <- na.locf(cpi, fromLast = TRUE)

# Build CPI variables to match SPI

#All Items#
cpi_all <- cpi$D7G7
colnames(cpi_all) <- "CPI All Items"

#Food#
cpi_food <- (cpi$D7G8 * (cpi$CHZR / (cpi$CHZR + cpi$CJUZ)) + 
               cpi$D7GM * (cpi$CJUZ / (cpi$CHZR + cpi$CJUZ)))
colnames(cpi_food) <- "CPI Food"

#Ambient Food#
cpi_ambient <- (cpi$D7GM * (cpi$CJUZ / (cpi$CJUZ + cpi$L83B + cpi$L83C + cpi$L83S + cpi$L844 + cpi$L846 + cpi$CJUY + cpi$CJWI + cpi$L859)) +
                  cpi$L7JM * (cpi$L83B / (cpi$CJUZ + cpi$L83B + cpi$L83C + cpi$L83S + cpi$L844 + cpi$L846 + cpi$CJUY + cpi$CJWI + cpi$L859)) +
                  cpi$L7JN * (cpi$L83C / (cpi$CJUZ + cpi$L83B + cpi$L83C + cpi$L83S + cpi$L844 + cpi$L846 + cpi$CJUY + cpi$CJWI + cpi$L859)) +
                  cpi$L7JP * (cpi$L83S / (cpi$CJUZ + cpi$L83B + cpi$L83C + cpi$L83S + cpi$L844 + cpi$L846 + cpi$CJUY + cpi$CJWI + cpi$L859)) +
                  cpi$L7JT * (cpi$L844 / (cpi$CJUZ + cpi$L83B + cpi$L83C + cpi$L83S + cpi$L844 + cpi$L846 + cpi$CJUY + cpi$CJWI + cpi$L859)) +
                  cpi$L7JU * (cpi$L846 / (cpi$CJUZ + cpi$L83B + cpi$L83C + cpi$L83S + cpi$L844 + cpi$L846 + cpi$CJUY + cpi$CJWI + cpi$L859)) +
                  cpi$D7GL * (cpi$CJUY / (cpi$CJUZ + cpi$L83B + cpi$L83C + cpi$L83S + cpi$L844 + cpi$L846 + cpi$CJUY + cpi$CJWI + cpi$L859)) +
                  cpi$D7HO * (cpi$CJWI / (cpi$CJUZ + cpi$L83B + cpi$L83C + cpi$L83S + cpi$L844 + cpi$L846 + cpi$CJUY + cpi$CJWI + cpi$L859)) +
                  cpi$L7L6 * (cpi$L859 / (cpi$CJUZ + cpi$L83B + cpi$L83C + cpi$L83S + cpi$L844 + cpi$L846 + cpi$CJUY + cpi$CJWI + cpi$L859)))
colnames(cpi_ambient) <- "CPI Ambient Food"

#Fresh Food#
cpi_fresh <- (cpi$L7JO * (cpi$L83H / (cpi$L83H + cpi$L83T + cpi$CJWD + cpi$CJWG + cpi$CJWC + cpi$CJWE + cpi$L84P + cpi$L858 + cpi$L853)) +
                cpi$L7JQ * (cpi$L83T / (cpi$L83H + cpi$L83T + cpi$CJWD + cpi$CJWG + cpi$CJWC + cpi$CJWE + cpi$L84P + cpi$L858 + cpi$L853)) +
                cpi$D7HJ * (cpi$CJWD / (cpi$L83H + cpi$L83T + cpi$CJWD + cpi$CJWG + cpi$CJWC + cpi$CJWE + cpi$L84P + cpi$L858 + cpi$L853)) +
                cpi$D7HM * (cpi$CJWG / (cpi$L83H + cpi$L83T + cpi$CJWD + cpi$CJWG + cpi$CJWC + cpi$CJWE + cpi$L84P + cpi$L858 + cpi$L853)) +
                cpi$D7HI * (cpi$CJWC / (cpi$L83H + cpi$L83T + cpi$CJWD + cpi$CJWG + cpi$CJWC + cpi$CJWE + cpi$L84P + cpi$L858 + cpi$L853)) +
                cpi$D7HK * (cpi$CJWE / (cpi$L83H + cpi$L83T + cpi$CJWD + cpi$CJWG + cpi$CJWC + cpi$CJWE + cpi$L84P + cpi$L858 + cpi$L853)) +
                cpi$L7KS * (cpi$L84P / (cpi$L83H + cpi$L83T + cpi$CJWD + cpi$CJWG + cpi$CJWC + cpi$CJWE + cpi$L84P + cpi$L858 + cpi$L853)) +
                cpi$L7L5 * (cpi$L83H / (cpi$L83H + cpi$L83T + cpi$CJWD + cpi$CJWG + cpi$CJWC + cpi$CJWE + cpi$L84P + cpi$L858 + cpi$L853)) +
                cpi$L7L2 * (cpi$L853 / (cpi$L83H + cpi$L83T + cpi$CJWD + cpi$CJWG + cpi$CJWC + cpi$CJWE + cpi$L84P + cpi$L858 + cpi$L853)))
colnames(cpi_fresh) <- "CPI Fresh Food"

#Clothing & Footwear#
cpi_clothing <- cpi$D7GA
colnames(cpi_clothing) <- "CPI Clothing"

#Health & Beauty#
cpi_health <- (cpi$D7JD * (cpi$CJYO / (cpi$CJYO + cpi$CJYA)) +
                 cpi$D7NP * (cpi$CJYA / (cpi$CJYO + cpi$CJYA)))
colnames(cpi_health) <- "CPI Health & Beauty"

#DIY, Gardening & Hardware#
cpi_diy <- cpi$D7GY
colnames(cpi_diy) <- "CPI DIY"

#Furniture & Flooring#
cpi_furniture <- (cpi$D7GU * (cpi$CJVG / (cpi$CJVG + cpi$CJVH)) +
                    cpi$D7GV * (cpi$CJVH / (cpi$CJVG + cpi$CJVH)))
colnames(cpi_furniture) <- "CPI Furniture"

#Electricals#
cpi_electricals <- (cpi$D7IF * (cpi$CJXI / (cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE)) +
                      cpi$D7IZ * (cpi$CJYC / (cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE)) +
                      cpi$D7J2 * (cpi$CJYD / (cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE)) +
                      cpi$D7J3 * (cpi$CJYE / (cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE)))
colnames(cpi_electricals) <- "CPI Electricals"

#Books, Stationery & Home Entertainment#
cpi_books <- (cpi$D7O3 * (cpi$ICVT / (cpi$ICVT + cpi$CJYF)) +
                cpi$D7J6 * (cpi$CJYF / (cpi$ICVT + cpi$CJYF)))
colnames(cpi_books) <- "CPI Books"

#Other Non-Food#
cpi_othnonfood <- (cpi$D7NX * (cpi$ICVP / (cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                     cpi$D7NY * (cpi$ICVQ / (cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                     cpi$L7SL * (cpi$L8CZ / (cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                     cpi$L7SM * (cpi$L8D2 / (cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                     cpi$D7O8 * (cpi$CJVX / (cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                     cpi$D7GN * (cpi$CJWP / (cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)))
colnames(cpi_othnonfood) <- "CPI Other Non-Food"

#Non-Food#
cpi_nonfood <- (cpi$D7GA * (cpi$CHZT / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7JD * (cpi$CJYO / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7NP * (cpi$CJYA / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7GY * (cpi$CJVK / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7GU * (cpi$CJVG / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7GV * (cpi$CJVH / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7IF * (cpi$CJXI / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7IZ * (cpi$CJYC / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7J2 * (cpi$CJYD / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7J3 * (cpi$CJYE / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7O3 * (cpi$ICVT / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7J6 * (cpi$CJYF / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7NX * (cpi$ICVP / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7NY * (cpi$ICVQ / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$L7SL * (cpi$L8CZ / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$L7SM * (cpi$L8D2 / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7O8 * (cpi$CJVX / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)) +
                  cpi$D7GN * (cpi$CJWP / (cpi$CHZT + cpi$CJYO + cpi$CJYA + cpi$CJVK + cpi$CJVG + cpi$CJVH + cpi$CJXI + cpi$CJYC + cpi$CJYD + cpi$CJYE + cpi$ICVT + cpi$CJYF + cpi$ICVP + cpi$ICVQ + cpi$L8CZ + cpi$L8D2 + cpi$CJVX + cpi$CJWP)))
colnames(cpi_nonfood) <- "CPI Non-Food"


#### Productivity Data ####

#Output per hour Whole Economy
url <- "https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/labourproductivity/datasets/annualbreakdownofcontributionswholeeconomyandsectors/current/prodconts.xls"
loc.download <- "output_all.xls"
download.file(url,loc.download,mode = "wb")
outputperhour <- "output_all.xls"
output_all <- read_excel(outputperhour, sheet = 6, range = cell_limits(c(7, 2), c(NA, 2)))

dates <- seq(as.Date("1997-03-20"), length = nrow(output_all), by = "quarters")
dates <- LastDayInMonth(dates)
output_all <- xts(x = output_all, order.by=dates)
colnames(output_all) <- "Output per Hour - Whole Economy"

#Output per hour Retail
url <- "https://www.ons.gov.uk/file?uri=/economy/economicoutputandproductivity/productivitymeasures/datasets/labourproductivitybyindustrydivision/apriltojune2018/division.xls"
loc.download <- "output_retail.xls"
download.file(url,loc.download,mode = "wb")
outputperhour_retail <- "output_retail.xls"
output_retail <- read_excel(outputperhour_retail, sheet = 3, range = cell_limits(c(7, 25), c(NA, 25)))

dates <- seq(as.Date("1997-03-20"), length = nrow(output_retail), by = "quarters")
dates <- LastDayInMonth(dates)
output_retail <- xts(x = output_retail, order.by=dates)
colnames(output_retail) <- "Output per Hour - Retail"


#### Regional Output Data ####

#GVA per head (CP)
url <- "https://www.ons.gov.uk/file?uri=/economy/grossvalueaddedgva/datasets/nominalregionalgrossvalueaddedbalancedperheadandincomecomponents/current/nominalregionalgvabperheadandincomecomponents.xlsx"
loc.download <- "gva_per_head_all.xlsx"
download.file(url,loc.download,mode = "wb")
gva_per_head_all <- "gva_per_head_all.xlsx"
dates <- seq(as.Date("1998-12-31"), length = 20, by = "years")
dates <- LastDayInMonth(dates)

#UK
GVAperheaduk <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(3, 4), c(3, NA)), col_names = FALSE)
GVAperheaduk <- t(GVAperheaduk)
GVAperheaduk <- xts(x = GVAperheaduk, order.by=dates)
colnames(GVAperheaduk) <- "GVA per Head - UK"

#England
GVAperheadengland <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(4, 4), c(4, NA)), col_names = FALSE)
GVAperheadengland <- t(GVAperheadengland)
GVAperheadengland <- xts(x = GVAperheadengland, order.by=dates)
colnames(GVAperheadengland) <- "GVA per Head - England"

#North East
GVAperheadNE <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(5, 4), c(5, NA)), col_names = FALSE)
GVAperheadNE <- t(GVAperheadNE)
GVAperheadNE <- xts(x = GVAperheadNE, order.by=dates)
colnames(GVAperheadNE) <- "GVA per Head - North East"

#North West
GVAperheadNW <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(15, 4), c(15, NA)), col_names = FALSE)
GVAperheadNW <- t(GVAperheadNW)
GVAperheadNW <- xts(x = GVAperheadNW, order.by=dates)
colnames(GVAperheadNW) <- "GVA per Head - North West"

#North Yorkshire & the Humber
GVAperheadyork <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(41, 4), c(41, NA)), col_names = FALSE)
GVAperheadyork <- t(GVAperheadyork)
GVAperheadyork <- xts(x = GVAperheadyork, order.by=dates)
colnames(GVAperheadyork) <- "GVA per Head - Yorkshire & The Humber"

#East Midlands
GVAperheadEM <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(57, 4), c(57, NA)), col_names = FALSE)
GVAperheadEM <- t(GVAperheadEM)
GVAperheadEM <- xts(x = GVAperheadEM, order.by=dates)
colnames(GVAperheadEM) <- "GVA per Head - East Midlands"

#West Midlands
GVAperheadWM <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(72, 4), c(72, NA)), col_names = FALSE)
GVAperheadWM <- t(GVAperheadWM)
GVAperheadWM <- xts(x = GVAperheadWM, order.by=dates)
colnames(GVAperheadWM) <- "GVA per Head - West Midlands"

#East
GVAperheadE <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(90, 4), c(90, NA)), col_names = FALSE)
GVAperheadE <- t(GVAperheadE)
GVAperheadE <- xts(x = GVAperheadE, order.by=dates)
colnames(GVAperheadE) <- "GVA per Head - East"

#London
GVAperheadLondon <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(110, 4), c(110, NA)), col_names = FALSE)
GVAperheadLondon <- t(GVAperheadLondon)
GVAperheadLondon <- xts(x = GVAperheadLondon, order.by=dates)
colnames(GVAperheadLondon) <- "GVA per Head - London"

#South East
GVAperheadSE <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(137, 4), c(137, NA)), col_names = FALSE)
GVAperheadSE <- t(GVAperheadSE)
GVAperheadSE <- xts(x = GVAperheadSE, order.by=dates)
colnames(GVAperheadSE) <- "GVA per Head - South East"

#South West
GVAperheadSW <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(163, 4), c(163, NA)), col_names = FALSE)
GVAperheadSW <- t(GVAperheadSW)
GVAperheadSW <- xts(x = GVAperheadSW, order.by=dates)
colnames(GVAperheadSW) <- "GVA per Head - South West"

#Wales
GVAperheadwales <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(180, 4), c(180, NA)), col_names = FALSE)
GVAperheadwales <- t(GVAperheadwales)
GVAperheadwales <- xts(x = GVAperheadwales, order.by=dates)
colnames(GVAperheadwales) <- "GVA per Head - Wales"

#Scotland
GVAperheadscot <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(195, 4), c(195, NA)), col_names = FALSE)
GVAperheadscot <- t(GVAperheadscot)
GVAperheadscot <- xts(x = GVAperheadscot, order.by=dates)
colnames(GVAperheadscot) <- "GVA per Head - Scotland"

#Northern Ireland
GVAperheadNI <- read_excel(gva_per_head_all, sheet = 5, range = cell_limits(c(224, 4), c(224, NA)), col_names = FALSE)
GVAperheadNI <- t(GVAperheadNI)
GVAperheadNI <- xts(x = GVAperheadNI, order.by=dates)
colnames(GVAperheadNI) <- "GVA per Head - Northern Ireland"


#GVA (CVM)
url <- "https://www.ons.gov.uk/file?uri=/economy/grossvalueaddedgva/datasets/nominalandrealregionalgrossvalueaddedbalancedbyindustry/current/nominalandrealregionalgvabbyindustry.xlsx"
loc.download <- "gva_region.xlsx"
download.file(url,loc.download,mode = "wb")
gva_region <- "gva_region.xlsx"
dates <- seq(as.Date("1998-12-31"), length = 20, by = "years")
dates <- LastDayInMonth(dates)

#UK
GVAuk <- read_excel(gva_region, sheet = 3, range = cell_limits(c(58, 5), c(58, NA)), col_names = FALSE)
GVAuk <- t(GVAuk)
GVAuk <- xts(x = GVAuk, order.by=dates)
colnames(GVAuk) <- "GVA - UK"

#England
GVAengland <- read_excel(gva_region, sheet = 3, range = cell_limits(c(174, 5), c(174, NA)), col_names = FALSE)
GVAengland <- t(GVAengland)
GVAengland <- xts(x = GVAengland, order.by=dates)
colnames(GVAengland) <- "GVA - England"

#North East
GVANE <- read_excel(gva_region, sheet = 3, range = cell_limits(c(290, 5), c(290, NA)), col_names = FALSE)
GVANE <- t(GVANE)
GVANE <- xts(x = GVANE, order.by=dates)
colnames(GVANE) <- "GVA - North East"

#North West
GVANW <- read_excel(gva_region, sheet = 3, range = cell_limits(c(406, 5), c(406, NA)), col_names = FALSE)
GVANW <- t(GVANW)
GVANW <- xts(x = GVANW, order.by=dates)
colnames(GVANW) <- "GVA - North West"

#North Yorkshire & the Humber
GVAyork <- read_excel(gva_region, sheet = 3, range = cell_limits(c(522, 5), c(522, NA)), col_names = FALSE)
GVAyork <- t(GVAyork)
GVAyork <- xts(x = GVAyork, order.by=dates)
colnames(GVAyork) <- "GVA - Yorkshire & The Humber"

#East Midlands
GVAEM <- read_excel(gva_region, sheet = 3, range = cell_limits(c(638, 5), c(638, NA)), col_names = FALSE)
GVAEM <- t(GVAEM)
GVAEM <- xts(x = GVAEM, order.by=dates)
colnames(GVAEM) <- "GVA - East Midlands"

#West Midlands
GVAWM <- read_excel(gva_region, sheet = 3, range = cell_limits(c(754, 5), c(754, NA)), col_names = FALSE)
GVAWM <- t(GVAWM)
GVAWM <- xts(x = GVAWM, order.by=dates)
colnames(GVAWM) <- "GVA - West Midlands"

#East
GVAE <- read_excel(gva_region, sheet = 3, range = cell_limits(c(870, 5), c(870, NA)), col_names = FALSE)
GVAE <- t(GVAE)
GVAE <- xts(x = GVAE, order.by=dates)
colnames(GVAE) <- "GVA - East"

#London
GVALondon <- read_excel(gva_region, sheet = 3, range = cell_limits(c(986, 5), c(986, NA)), col_names = FALSE)
GVALondon <- t(GVALondon)
GVALondon <- xts(x = GVALondon, order.by=dates)
colnames(GVALondon) <- "GVA - London"

#South East
GVASE <- read_excel(gva_region, sheet = 3, range = cell_limits(c(1102, 5), c(1102, NA)), col_names = FALSE)
GVASE <- t(GVASE)
GVASE <- xts(x = GVASE, order.by=dates)
colnames(GVASE) <- "GVA - South East"

#South West
GVASW <- read_excel(gva_region, sheet = 3, range = cell_limits(c(1218, 5), c(1218, NA)), col_names = FALSE)
GVASW <- t(GVASW)
GVASW <- xts(x = GVASW, order.by=dates)
colnames(GVASW) <- "GVA - South West"

#Wales
GVAwales <- read_excel(gva_region, sheet = 3, range = cell_limits(c(1334, 5), c(1334, NA)), col_names = FALSE)
GVAwales <- t(GVAwales)
GVAwales <- xts(x = GVAwales, order.by=dates)
colnames(GVAwales) <- "GVA - Wales"

#Scotland
GVAscot <- read_excel(gva_region, sheet = 3, range = cell_limits(c(1450, 5), c(1450, NA)), col_names = FALSE)
GVAscot <- t(GVAscot)
GVAscot <- xts(x = GVAscot, order.by=dates)
colnames(GVAscot) <- "GVA - Scotland"

#Northern Ireland
GVANI <- read_excel(gva_region, sheet = 3, range = cell_limits(c(1566, 5), c(1566, NA)), col_names = FALSE)
GVANI <- t(GVANI)
GVANI <- xts(x = GVANI, order.by=dates)
colnames(GVANI) <- "GVA - Northern Ireland"


#### Retail Sales Index ####

# Volume data: RETAIL SALES INDEX: VOLUME SEASONALLY ADJUSTED PERCENTAGE CHANGE ON SAME MONTH A YEAR EARLIER
# "J5EB" = "RSI Volumes - All retailing including automotive fuel"
# "J45U" = "RSI Volumes - All retailing excluding automotive fuel"
# "IDOB" = "RSI Volumes - Predominantly food stores"
# "IDOC" = "RSI Volumes - Predominantly non-food stores"
# "IDOA" = "RSI Volumes - Non-Specialised stores"
# "IDOG" = "RSI Volumes - Textile, clothing and footwear stores"
# "IDOH" = "RSI Volumes - Households goods stores"
# "IDOD" = "RSI Volumes - Other Non-Food Stores" 
# "J5DK" = "RSI Volumes - Non-Store retailing"
# "JO4C" = "RSI Volumes - Fuel"


rsi_vol <- pdfetch_ONS(c("J5EB","J45U", "IDOB","IDOC","IDOA","IDOG","IDOH","IDOH","IDOD","JO4C","J5DK"), "DRSI")
#rsi_vol <- to.monthly(rsi_vol, OHLC=FALSE)

colnames(rsi_vol) <- c("RSI Volumes - All retail inc auto fuel", "RSI Volumes - All retail exc auto fuel", "RSI Volumes - Predom food stores", "RSI Volumes - Predom non-food stores", "RSI Volumes - Non-Specialised stores", "RSI Volumes - Textile, clothing and footwear stores", "RSI Volumes - Households goods stores", "RSI Volumes - Other Non-Food Stores", "RSI Volumes - Non-Store retail", "RSI Volumes - Fuel")

# Retail sales volume weights (2017)

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

# Value Data

# "J59v" = "RSI Values - All retailing including automotive fuel"
# "J3L2" = "RSI Values - All retailing excluding automotive fuel"
# "J3L3" = "RSI Values - All retailing excluding automotive fuel: Large Businesses"
# "J3L4" = "RSI Values - All retailing excluding automotive fuel: Small Businesses"

# "EAIA" = "RSI Values - Predominantly food stores"
# "EAIB" = "RSI Values - Total predominantly non-food stores"
# "EAIN" = "RSI Values - Non-Specialised stores"
# "EAIC" = "RSI Values - Textile, clothing and footwear stores"
# "EAID" = "RSI Values - Households goods stores"
# "EAIF" = "RSI Values - Other Non - Food Stores" 
# "J58L" = "RSI Values - Non-Store retailing"
# "IYP9" = "RSI Values - Fuel"

# "EAIT" = "RSI Values - Food Stores: Large Businesses"
# "EAIU" = "RSI Values - Food Stores: Small Businesses"
# "EAIV" = "RSI Values - Total Predominantly Non-Food Stores: Large Businesses"
# "EAIW" = "RSI Values - Total Predominantly Non-Food Stores: Small Businesses"
# "J58M" = "RSI Values - Non-Store retailing: Large Businesses"
# "j58N" = "RSI Values - Non-Store retailing: Small Businesses"
# "KP3T" = "RSI Values - Internet"

rsi_val <- pdfetch_ONS(c("J59v","J3L2","J3L3","J3L4","EAIA","EAIB","EAIN","EAIC","EAIC","EAID","EAIF","J58L","IYP9","EAIT","EAIU","EAIV","EAIW","J58M","j58N","KP3T"), "DRSI")
# rsi_val <- to.monthly(rsi_val, OHLC=FALSE)

colnames(rsi_val) <- c("RSI Values - All retail inc auto fuel",
                       "RSI Values - All retail exc auto fuel",
                       "RSI Values - All retail exc auto fuel: Large Businesses",
                       "RSI Values - All retail exc auto fuel: Small Businesses",
                       "RSI Values - Predom food stores",
                       "RSI Values - Predom non-food stores",
                       "RSI Values - Non-Specialised stores",
                       "RSI Values - Textile, clothing and footwear stores",
                       "RSI Values - Households goods stores",
                       "RSI Values - Other Non - Food Stores",
                       "RSI Values - Non-Store retail",
                       "RSI Values - Fuel",
                       "RSI Values - Food Stores: Large Businesses",
                       "RSI Values - Food Stores: Small Businesses",
                       "RSI Values - Predom Non-Food Stores: Large Businesses",
                       "RSI Values - Predom Non-Food Stores: Small Businesses",
                       "RSI Values - Non-Store retail: Large Businesses",
                       "RSI Values - Non-Store retail: Small Businesses",
                       "RSI Values - Internet")

# Value weights

# "W_J59v" = "All retailing including automotive fuel"=387969
# "W_J3L2" = "All retailing excluding automotive fuel"=350847
# "W_J3L3" = "All retailing excluding automotive fuel: Large Businesses" =275477
# "W_J3L4" = "All retailing excluding automotive fuel: Small Businesses" =75370

# "W_EAIA"= "Predominantly food stores" = 154446
# "W_EAIB" = "Total predominantly non-food stores"=163199
# "W_EAIN" = "Non-Food Non-Specialised stores"=34180
# "W_EAIC" = "Textile, clothing and footwear stores"=45728
# "W_EAID" = "Households goods stores"=32674
# "W_EAIF" = "Other Non - Food Stores" =50617
# "W_J58L" = "Non-Store retailing"=33202
# "W_IYP9" = "Fuel"= 36849

# "W_EAIT" = "Food Stores: Large Businesses"=132149
# "W_EAIU" = "Food Stores: Small Businesses"=22296
# "W_EAIV" = "Total Predominantly Non-Food Stores: Large Businesses"=121676
# "W_EAIW" = "Total Predominantly Non-Food Stores: Small Businesses"=41524
# "W_J58M" = "Non-Store retailing: Large Businesses"=21652
# "W_j58N" = "Non-Store retailing: Small Businesses"=11550


W_J59v=387969
W_J3L2=350847
W_J3L3 =275477
W_J3L4 =75370

W_EAIA=154446
W_EAIB=163199
W_EAIN=34180
W_EAIC=45728
W_EAID=32674
W_EAIF=50617
W_J58L=33202
W_IYP9= 36849

W_EAIT=132149
W_EAIU=22296
W_EAIV=121676
W_EAIW=41524
W_J58M=21652
W_J58N=11550


#### DRI Data ####

setwd("Z:/Projects/RDataAggregation/")
source("DRIData.R")

#,"XLConnect","rJava", "ReporteRs"
#enter last date you wish to upload for
endate= ISOdate(2018,06,1)

#add bespoke endates for monitors particularly when data have been entered into workbooks but not published
#must be a date after 2017,11,01
endateRSM=ISOdate(2018,06,1)
endateFF=ISOdate(2018,06,1)
endateDRI=ISOdate(2018,06,1)

adddate=length(seq(from=ISOdate(2017,11,1), to=endate, by="months"))-1 
adddateRSM=length(seq(from=ISOdate(2017,11,1), to=endateRSM, by="months"))-1
adddateFF=length(seq(from=ISOdate(2017,11,1), to=endateFF, by="months"))-1 
adddateDRI=length(seq(from=ISOdate(2017,11,1), to=endateDRI, by="months"))-1 




# Read-in DRI

DRI_Master=read.csv("DRI Master.csv")
DRI_Master=DRI_Master[,c("Mobile_Total.Retail_Share","Total.Retail_Total.Retail_Total.Visits")]

DRI_Master=change(DRI_Master,Var="Total.Retail_Total.Retail_Total.Visits" ,TimeVar="date",NewVar = paste("Visit_growth", sep="_"),slideBy=-12, type="percent")

DRI_Master=DRI_Master[,c("Mobile_Total.Retail_Share","Visit_growth")]
DRI_Master$date<-(seq(ISOdate(2014,08,1), by = "month", length.out = nrow(DRI_Master)))
names(DRI_Master)[1:2]=c("BRC-Hitwise Mobile Share of retail website visits (%)","BRC-Hitwise Growth in retailer website visits (yoy %)")

DRI_Master[,c("BRC-Hitwise Mobile Share of retail website visits (%)")]=DRI_Master[,c("BRC-Hitwise Mobile Share of retail website visits (%)")]*100

dri_embargo <- data.frame(
  id = as.numeric(52:65),
  embargo = as.Date(c("2018-12-06", "2019-01-11", "2019-02-07", "2019-03-07", "2019-04-11", "2019-05-09", "2019-06-06", "2019-07-11", "2019-08-08", "2019-09-05", "2019-10-10", "2019-11-07", "2019-12-05", "2020-01-10")
  ))

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

#### Footfall Data ####

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
  embargo = as.Date(c("2018-12-04", "2019-01-10", "2019-02-05", "2019-03-05", "2019-04-09", "2019-05-08", "2019-06-04", "2019-07-09", "2019-08-06", "2019-09-03", "2019-10-08", "2019-11-05", "2019-12-03", "2020-01-09")
  ))

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

setwd("Z:/Projects/RIADatabaseBuild")


#### Shop Price Inflation ####

#add bespoke endates for monitors particularly when data have been entered into workbooks but not published
endateSPI=ISOdate(2018,11,1)

adddateSPI=length(seq(from=ISOdate(2017,11,1), to=endateSPI, by="months"))-1 

setwd("Z:/Monitors/spi/Data/All SPI Data/ForDataCollation")

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


#### Database Merge ####

# merge xts objects into one big dataset and create dataframe for table - Monthly Data
databasemonthly <- merge(spi_all_embargo_xts[,3:14], RSM_embargo_xts[,3:16], FF_embargo_xts[,3:11], REM_embargo_xts[,3:10], DRI_embargo_xts[,3:5], cpi_all, cpi_ambient, cpi_books, cpi_clothing, cpi_diy, cpi_electricals, cpi_food, cpi_fresh, cpi_furniture, cpi_health, cpi_nonfood, cpi_othnonfood, awe, boe_ccards, boe_conscredit, boe_gbp, boe_house, boe_secured, HPengland, HPwales, HPscotland, HPnorthern_ireland, HPlondon, HPeast, HPeastmid, HPwestmid, HPnortheast, HPnorthwest, HPsoutheast, HPsouthwest, HPyork, employ, unemp, GVAmonthly_mom, GVAmonthly_yoy, rsi_val, rsi_vol, all = TRUE, fill = NA)
databasemonthlydf <- data.frame(date=index(databasemonthly), coredata(databasemonthly))

# merge xts objects into one big dataset and create dataframe for table - Quarterly Data
databasequarterly <- merge(GVAquarterly_all, GVAquarterly_retail, output_all, output_retail, empjobsquarterly_all, empjobsquarterly_retail, selfjobsquarterly_all, selfjobsquarterly_retail, gdpquarterly, all = TRUE, fill = NA)
databasequarterlydf <- data.frame(date=index(databasequarterly), coredata(databasequarterly))

# merge xts objects into one big dataset and create dataframe for table - Yearly Data
databaseyearly <- merge(nomiswfjobsenglandcountxts, nomiswfjobsenglandpercentxts, nomiswfjobsgbcountxts, nomiswfjobsgbpercentxts, nomiswfjobsscotlandcountxts, nomiswfjobsscotlandpercentxts, nomiswfjobswalescountxts, nomiswfjobswalespercentxts, nomisenterprisesenglandtotalxts, nomisenterprisesnitotalxts, nomisenterprisesscotlandtotalxts, nomisenterprisesuktotalxts, nomisenterpriseswalestotalxts, nomisunitsenglandtotalxts, nomisunitsnitotalxts, nomisunitsscotlandtotalxts, nomisunitsuktotalxts, nomisunitswalestotalxts, GVAE, GVAEM, GVAengland, GVALondon, GVANE, GVANI, GVANW, GVAscot, GVASE, GVASW, GVAuk, GVAwales, GVAWM, GVAyork, GVAperheadE, GVAperheadEM, GVAperheadengland, GVAperheadLondon, GVAperheadNE, GVAperheadNI, GVAperheadNW, GVAperheadscot, GVAperheadSE, GVAperheadSW, GVAperheaduk, GVAperheadwales, GVAperheadWM, GVAperheadyork, ashe_regionxts, all = TRUE, fill = NA)
databaseyearlydf <- data.frame(date=index(databaseyearly), coredata(databaseyearly))


#### Map Stats File Preparation ####

setwd("Z:/Projects/RIADatabaseBuild")

## UK Countries

#import shapefiles
gbcountries <- readOGR(dsn = file.path("Countries_December_2016_Full_Clipped_Boundaries_in_Great_Britain.shp"), stringsAsFactors = F)
nicountries <- readOGR(dsn = file.path("OSNI_Open_Data_Largescale_Boundaries__NI_Outline.shp"), stringsAsFactors = F)

#Prepare shapefile variables for merging
gbcountries <- subset(gbcountries, select = -c(objectid,ctry16cd,ctry16nmw,bng_e,bng_n,long,lat,st_areasha,st_lengths))
nicountries <- subset(nicountries, select = -c(ID,Area_SqKM,OBJECTID))
names(nicountries)[names(nicountries)=="NAME"] <- "ctry16nm"

#merge shapefiles
row.names(nicountries) <- paste("nicountries", row.names(nicountries), sep="_")
row.names(gbcountries) <- paste("gbcountries", row.names(gbcountries), sep="_")
gbcountries <- spTransform(gbcountries, CRS("+proj=longlat +datum=WGS84"))
nicountries <- spTransform(nicountries, CRS("+proj=longlat +datum=WGS84"))
ukcountries <- spRbind(gbcountries,nicountries)

#create country database
countrycalcs <- data.frame("ctry16nm" = c("England", "Scotland", "Wales", "Outline of Northern Ireland"),
                           "Unemployment" = c(tail(unemp$`Unemployment Rate England`, 1), tail(unemp$`Unemployment Rate Scotland`, 1), tail(unemp$`Unemployment Rate Wales`, 1), tail(unemp$`Unemployment Rate Northern Ireland`, 1)),
                           "Employment" = c(tail(employ$`Employment Total England`, 1), tail(employ$`Employment Total Scotland`, 1), tail(employ$`Employment Total Wales`, 1), tail(employ$`Employment Total Northern Ireland`, 1)),
                           "Workforce Jobs" = c(tail(nomiswfjobsenglandcount$obs_value.value, 1), tail(nomiswfjobsscotlandcount$obs_value.value, 1), tail(nomiswfjobswalescount$obs_value.value, 1), NA),
                           "Number of Retailers" = c(tail(nomisenterprisesenglandtotal$Total, 1), tail(nomisenterprisesscotlandtotal$Total, 1), tail(nomisenterpriseswalestotal$Total, 1), tail(nomisenterprisesnitotal$Total, 1)),
                           "Number of Shops" = c(tail(nomisunitsenglandtotal$Total, 1), tail(nomisunitsscotlandtotal$Total, 1), tail(nomisunitswalestotal$Total, 1), tail(nomisunitsnitotal$Total, 1)),
                           "Median Hourly Wage - Whole Economy" = c(AsheEnglandAll$X__4, AsheScotlandAll$X__4, AsheWalesAll$X__4, AsheNorthIreAll$X__4),
                           "Median Hourly Wage - Retail" = c(NA, AsheScotlandRetail$X__4, AsheWalesRetail$X__4, NA),
                           "Average House Price" = c(tail(HPengland$`House Price Average - England`, 1), tail(HPscotland$`House Price Average - Scotland`, 1), tail(HPwales$`House Price Average - Wales`, 1), tail(HPnorthern_ireland$`House Price Average - Northern Ireland`, 1)),
                           "GVA" = c(tail(GVAengland$`GVA - England`, 1), tail(GVAscot$`GVA - Scotland`, 1), tail(GVAwales$`GVA - Wales`, 1), tail(GVANI$`GVA - Northern Ireland`, 1)),
                           "GVA per Head" = c(tail(GVAperheadengland$`GVA per Head - England`, 1), tail(GVAperheadscot$`GVA per Head - Scotland`, 1), tail(GVAperheadscot$`GVA per Head - Scotland`, 1), tail(GVAperheadNI$`GVA per Head - Northern Ireland`, 1)), 
                           stringsAsFactors = TRUE)

#merge variables from excel imported data to spatial dataframe.
ukcountries <- merge(ukcountries, countrycalcs, by.x = "ctry16nm", by.y = "ctry16nm")

#change name of Northern Ireland
ukcountries@data$ctry16nm[4] <- "Northern Ireland"

#Simplify map to reduce memory use
gc()
ukcountries <- rmapshaper::ms_simplify(ukcountries)

#create colour palette for continuous colour variation (adjust number to how many intervals you want)
pal1 <- colorBin("Greens", countrycalcs$Unemployment.Rate.England, 9, pretty = TRUE)


## UK NUTS1 Regions

#import shapefiles
ukregions <- readOGR(dsn = file.path("NUTS_Level_1_January_2018_Full_Extent_Boundaries_in_the_United_Kingdom.shp"), stringsAsFactors = F)

#create regional database
regioncalcs <- data.frame("nuts118cd" = c("UKC", "UKD", "UKE", "UKF", "UKG", "UKH", "UKI", "UKJ", "UKK", "UKL", "UKM", "UKN"),
                          "Unemployment" = c(tail(unemp$`Unemployment Rate North East`, 1), tail(unemp$`Unemployment Rate North West`, 1), tail(unemp$`Unemployment Rate Yorkshire & the Humber`, 1), tail(unemp$`Unemployment Rate East Midlands`, 1), tail(unemp$`Unemployment Rate West Midlands`, 1), tail(unemp$`Unemployment Rate East`, 1), tail(unemp$`Unemployment Rate London`, 1), tail(unemp$`Unemployment Rate South East`, 1), tail(unemp$`Unemployment Rate South West`, 1), tail(unemp$`Unemployment Rate Wales`, 1), tail(unemp$`Unemployment Rate Scotland`, 1), tail(unemp$`Unemployment Rate Northern Ireland`, 1)),
                          "Employment" = c(tail(employ$`Employment Total North East`, 1), tail(employ$`Employment Total North West`, 1), tail(employ$`Employment Total Yorkshire & the Humber`, 1), tail(employ$`Employment Total East Midlands`, 1), tail(employ$`Employment Total West Midlands`, 1), tail(employ$`Employment Total East`, 1), tail(employ$`Employment Total London`, 1), tail(employ$`Employment Total South East`, 1), tail(employ$`Employment Total South West`, 1), tail(employ$`Employment Total Wales`, 1), tail(employ$`Employment Total Scotland`, 1), tail(employ$`Employment Total Northern Ireland`, 1)),
                          "Median Hourly Wage - Whole Economy" = c(AsheNorthEastAll$X__4, AsheNorthWestAll$X__4, AsheYorkhumbAll$X__4, AsheEastMidAll$X__4, AsheWestMidAll$X__4, AsheEastAll$X__4, AsheLondonAll$X__4, AsheSouthEastAll$X__4, AsheSouthWestAll$X__4, AsheWalesAll$X__4, AsheScotlandAll$X__4, AsheNorthIreAll$X__4),
                          "Median Hourly Wage - Retail" = c(AsheNorthEastRetail$X__4, AsheNorthWestRetail$X__4, AsheYorkhumbRetail$X__4, AsheEastMidRetail$X__4, AsheWestMidRetail$X__4, AsheEastRetail$X__4, AsheLondonRetail$X__4, AsheSouthEastRetail$X__4, AsheSouthWestRetail$X__4, AsheWalesRetail$X__4, AsheScotlandRetail$X__4, NA),
                          "Average House Price" = c(tail(HPnortheast$`House Price Average - North East`, 1), tail(HPnorthwest$`House Price Average - North West`, 1), tail(HPyork$`House Price Average - Yorkshire & the Humber`, 1), tail(HPeastmid$`House Price Average - East Midlands`, 1), tail(HPwestmid$`House Price Average - West Midlands`, 1), tail(HPeast$`House Price Average - East`, 1), tail(HPlondon$`House Price Average - London`, 1), tail(HPsoutheast$`House Price Average - South East`, 1), tail(HPsouthwest$`House Price Average - South West`, 1), tail(HPwales$`House Price Average - Wales`, 1), tail(HPscotland$`House Price Average - Scotland`, 1), tail(HPnorthern_ireland$`House Price Average - Northern Ireland`, 1)),
                          "GVA" = c(tail(GVANE$`GVA - North East`, 1), tail(GVANW$`GVA - North West`, 1), tail(GVAyork$`GVA - Yorkshire & The Humber`, 1), tail(GVAEM$`GVA - East Midlands`, 1), tail(GVAWM$`GVA - West Midlands`, 1), tail(GVAE$`GVA - East`, 1), tail(GVALondon$`GVA - London`, 1), tail(GVASE$`GVA - South East`, 1), tail(GVASW$`GVA - South West`, 1), tail(GVAwales$`GVA - Wales`, 1), tail(GVAscot$`GVA - Scotland`, 1), tail(GVANI$`GVA - Northern Ireland`, 1)),
                          "GVA per Head" = c(tail(GVAperheadNE$`GVA per Head - North East`, 1), tail(GVAperheadNW$`GVA per Head - North West`, 1), tail(GVAperheadyork$`GVA per Head - Yorkshire & The Humber`, 1), tail(GVAperheadEM$`GVA per Head - East Midlands`, 1), tail(GVAperheadWM$`GVA per Head - West Midlands`, 1), tail(GVAperheadE$`GVA per Head - East`, 1), tail(GVAperheadLondon$`GVA per Head - London`, 1), tail(GVAperheadSE$`GVA per Head - South East`, 1), tail(GVAperheadSW$`GVA per Head - South West`, 1), tail(GVAperheadwales$`GVA per Head - Wales`, 1), tail(GVAperheadscot$`GVA per Head - Scotland`, 1), tail(GVAperheadNI$`GVA per Head - Northern Ireland`, 1)),
                          stringsAsFactors = FALSE)

#merge variables from excel imported data to spatial dataframe. 
ukregions <- merge(ukregions, regioncalcs, by.x = "nuts118cd", by.y = "nuts118cd")

#Simplify map to reduce memory use
gc()
ukregions <- rmapshaper::ms_simplify(ukregions)

#create colour palette for continuous colour variation (adjust number to how many intervals you want)
pal2 <- colorBin("Greens", regioncalcs$Unemployment.Rate.North.East, 9, pretty = TRUE)

#Create nation data for download button (map tab)
englanddata <- merge(to.yearly(unemp$`Unemployment Rate England`, OHLC = FALSE), to.yearly(employ$`Employment Total England`, OHLC = FALSE), nomiswfjobsenglandcountxts$`WF Jobs count - England`, nomisenterprisesenglandtotalxts$`Businesses - England`, nomisunitsenglandtotalxts$`Local Units - England`, GVAengland$`GVA - England`, GVAperheadengland$`GVA per Head - England`, all = TRUE, fill = NA)
englanddata <- data.frame(date=index(englanddata), coredata(englanddata))
walesdata <- merge(to.yearly(unemp$`Unemployment Rate Wales`, OHLC = FALSE), to.yearly(employ$`Employment Total Wales`, OHLC = FALSE), nomiswfjobswalescountxts$`WF Jobs count - Wales`, nomisenterpriseswalestotalxts$`Businesses - Wales`, nomisunitswalestotalxts$`Local Units - Wales`, GVAwales$`GVA - Wales`, GVAperheadwales$`GVA per Head - Wales`, all = TRUE, fill = NA)
walesdata <- data.frame(date=index(walesdata), coredata(walesdata))
scotlanddata <- merge(to.yearly(unemp$`Unemployment Rate Scotland`, OHLC = FALSE), to.yearly(employ$`Employment Total Scotland`, OHLC = FALSE), nomiswfjobsscotlandcountxts$`WF Jobs count - Scotland`, nomisenterprisesscotlandtotalxts$`Businesses - Scotland`, nomisunitsscotlandtotalxts$`Local Units - Scotland`, GVAscot$`GVA - Scotland`, GVAperheadscot$`GVA per Head - Scotland`, all = TRUE, fill = NA)
scotlanddata <- data.frame(date=index(scotlanddata), coredata(scotlanddata))
nidata <- merge(to.yearly(unemp$`Unemployment Rate Northern Ireland`, OHLC = FALSE), to.yearly(employ$`Employment Total Northern Ireland`, OHLC = FALSE), nomisenterprisesnitotalxts$`Businesses - Northern Ireland`, nomisunitsnitotalxts$`Local Units - Northern Ireland`, GVANI$`GVA - Northern Ireland`, GVAperheadNI$`GVA per Head - Northern Ireland`, all = TRUE, fill = NA)
nidata <- data.frame(date=index(nidata), coredata(nidata))
  
# Create region data for download button (map tab)
nedata <- merge(to.yearly(unemp$`Unemployment Rate North East`, OHLC = FALSE), to.yearly(employ$`Employment Total North East`, OHLC = FALSE), GVANE$`GVA - North East`, GVAperheadNE$`GVA per Head - North East`, ashe_regionxts$`North East Total Median_OBS_VALUE`, ashe_regionxts$`North East Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
nedata <- data.frame(date=index(nedata), coredata(nedata))
nwdata <- merge(to.yearly(unemp$`Unemployment Rate North West`, OHLC = FALSE), to.yearly(employ$`Employment Total North West`, OHLC = FALSE), GVANW$`GVA - North West`, GVAperheadNW$`GVA per Head - North West`, ashe_regionxts$`North West Total Median_OBS_VALUE`, ashe_regionxts$`North West Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
nwdata <- data.frame(date=index(nwdata), coredata(nwdata))
yorkdata <- merge(to.yearly(unemp$`Unemployment Rate Yorkshire & the Humber`, OHLC = FALSE), to.yearly(employ$`Employment Total Yorkshire & the Humber`, OHLC = FALSE), GVAyork$`GVA - Yorkshire & The Humber`, GVAperheadyork$`GVA per Head - Yorkshire & The Humber`, ashe_regionxts$`Yorkshire and The Humber Total Median_OBS_VALUE`, ashe_regionxts$`Yorkshire and The Humber Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
yorkdata <- data.frame(date=index(yorkdata), coredata(yorkdata))
emdata <- merge(to.yearly(unemp$`Unemployment Rate East Midlands`, OHLC = FALSE), to.yearly(employ$`Employment Total East Midlands`, OHLC = FALSE), GVAEM$`GVA - East Midlands`, GVAperheadEM$`GVA per Head - East Midlands`, ashe_regionxts$`East Midlands Total Median_OBS_VALUE`, ashe_regionxts$`East Midlands Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
emdata <- data.frame(date=index(emdata), coredata(emdata))
wmdata <- merge(to.yearly(unemp$`Unemployment Rate West Midlands`, OHLC = FALSE), to.yearly(employ$`Employment Total West Midlands`, OHLC = FALSE), GVAWM$`GVA - West Midlands`, GVAperheadWM$`GVA per Head - West Midlands`, ashe_regionxts$`West Midlands Total Median_OBS_VALUE`, ashe_regionxts$`West Midlands Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
wmdata <- data.frame(date=index(wmdata), coredata(wmdata))
edata <- merge(to.yearly(unemp$`Unemployment Rate East`, OHLC = FALSE), to.yearly(employ$`Employment Total East`, OHLC = FALSE), GVAE$`GVA - East`, GVAperheadE$`GVA per Head - East`, ashe_regionxts$`East Total Median_OBS_VALUE`, ashe_regionxts$`East Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
edata <- data.frame(date=index(edata), coredata(edata))
londondata <- merge(to.yearly(unemp$`Unemployment Rate London`, OHLC = FALSE), to.yearly(employ$`Employment Total London`, OHLC = FALSE), GVALondon$`GVA - London`, GVAperheadLondon$`GVA per Head - London`, ashe_regionxts$`London Total Median_OBS_VALUE`, ashe_regionxts$`London Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
londondata <- data.frame(date=index(londondata), coredata(londondata))
sedata <- merge(to.yearly(unemp$`Unemployment Rate South East`, OHLC = FALSE), to.yearly(employ$`Employment Total South East`, OHLC = FALSE), GVASE$`GVA - South East`, GVAperheadSE$`GVA per Head - South East`, ashe_regionxts$`South East Total Median_OBS_VALUE`, ashe_regionxts$`South East Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
sedata <- data.frame(date=index(sedata), coredata(sedata))
swdata <- merge(to.yearly(unemp$`Unemployment Rate South West`, OHLC = FALSE), to.yearly(employ$`Employment Total South West`, OHLC = FALSE), GVASW$`GVA - South West`, GVAperheadSW$`GVA per Head - South West`, ashe_regionxts$`South West Total Median_OBS_VALUE`, ashe_regionxts$`South West Total Annual percentage change - median_OBS_VALUE`, all = TRUE, fill = NA)
swdata <- data.frame(date=index(swdata), coredata(swdata))

#### RI&A monitor release calendar ####

timevisData <- data.frame(
  id = 1:79,
  content = c("SPI - January", "RSM - January", "DRI - January", "FF&V - January", "SRSM - January", "EBR - January",
              "SPI - February", "RSM - February", "DRI - February", "FF&V - February", "SRSM - February", "EBR - February",
              "SPI - March", "RSM - March", "DRI - March", "FF&V - March", "SRSM - March", "QTA - Q1 2019", "REM - Q1 2019", "EBR - March",
              "SPI - April", "RSM - April", "DRI - April", "FF&V - April", "SRSM - April", "EBR - April",
              "SPI - May", "RSM - May", "DRI - May", "FF&V - May", "SRSM - May", "EBR - May",
              "SPI - June", "RSM - June", "DRI - June", "FF&V - June", "SRSM - June", "QTA - Q2 2019", "REM - Q2 2019", "EBR - June",
              "SPI - July", "RSM - July", "DRI - July", "FF&V - July", "SRSM - July", "EBR - July",
              "SPI - August", "RSM - August", "DRI - August", "FF&V - August", "SRSM - August", "EBR - August",
              "SPI - September", "RSM - September", "DRI - September", "FF&V - September", "SRSM - September", "QTA - Q3 2019", "REM - Q3 2019", "EBR - September",
              "SPI - October", "RSM - October", "DRI - October", "FF&V - October", "SRSM - October", "EBR - October",
              "SPI - November", "RSM - November", "DRI - November", "FF&V - November", "SRSM - November", "EBR - November",
              "SPI - December", "RSM - December", "DRI - December", "FF&V - December", "SRSM - December", "QTA - Q4 2019", "REM - Q4 2019"
  ),
  start = c("2019-01-30", "2019-02-05", "2019-02-07", "2019-02-11", "2019-02-13", "2019-01-31",
            "2019-02-27", "2019-03-05", "2019-03-07", "2019-03-11", "2019-03-13", "2019-02-28",
            "2019-04-03", "2019-04-09", "2019-04-11", "2019-04-15", "2019-04-17", "2019-04-18", "2019-04-25", "2019-03-29",
            "2019-05-01", "2019-05-08", "2019-05-09", "2019-05-13", "2019-05-15", "2019-04-30",
            "2019-05-29", "2019-06-04", "2019-06-06", "2019-06-10", "2019-06-12", "2019-05-31",
            "2019-07-03", "2019-07-09", "2019-07-11", "2019-07-15", "2019-07-17", "2019-07-18", "2019-07-25", "2019-06-28",
            "2019-07-31", "2019-08-06", "2019-08-08", "2019-08-12", "2019-08-14", "2019-07-31",
            "2019-08-28", "2019-09-03", "2019-09-05", "2019-09-09", "2019-09-11", "2019-08-30",
            "2019-10-02", "2019-10-08", "2019-10-10", "2019-10-14", "2019-10-16", "2019-10-17", "2019-10-24", "2019-09-30",
            "2019-10-30", "2019-11-05", "2019-11-07", "2019-11-11", "2019-11-13", "2019-10-31",
            "2019-11-27", "2019-12-03", "2019-12-05", "2019-12-09", "2019-12-11", "2019-11-29",
            "2020-01-03", "2020-01-09", "2020-01-10", "2020-01-13", "2020-01-15", "2020-01-16", "2020-01-23"),
  
  group = c(1,2,3,4,5,8,
            1,2,3,4,5,8,
            1,2,3,4,5,6,7,8,
            1,2,3,4,5,8,
            1,2,3,4,5,8,
            1,2,3,4,5,6,7,8,
            1,2,3,4,5,8,
            1,2,3,4,5,8,
            1,2,3,4,5,6,7,8,
            1,2,3,4,5,8,
            1,2,3,4,5,8,
            1,2,3,4,5,6,7)
  )

timevisDataGroups <- data.frame(
  id = 1:8,
  content = c("BRC-Nielsen Shop Price Index", "BRC-KPMG Retail Sales Monitor", "BRC-Hitwise Digital Retail Insight", "BRC-Springboard Footfall & Vacancies", "SRC-KPMG Scottish Retail Sales Monitor", "BRC Quarterly Trends Analysis", "BRC Retail Employment Monitor", "BRC Economic Briefing Report")
  )
