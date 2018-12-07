library(dplyr)
library(pdfetch)
library(xts)
library(bsts)
library(nomisr)
library(jsonlite)
library(httr)
library(readxl)
library(unzip)

# ONS Average Weekly Earnings - lms

#### Time Series Definitions ####

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

#### Get AWE Data ####

awe <- pdfetch_ONS(c("KAB9", "KAC2", "KAC3", "KAI7", "KAI8", "KAI9", "A3WX", "A3WV", "A3WW", "A2FC", "A2F9", "A2FA"), "lms")

#### Get JOBS03 & JOBS04 Data ####

#Employee Jobs
url <- "https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/employeejobsbyindustryjobs03/current/jobs03sep2018.xls"
loc.download <- "empjobs.xls"
download.file(url,loc.download,mode = "wb")
empjobs <- "empjobs.xls"
empjobs_all <- read_excel(empjobs, sheet = 2, range = "CH6:CH167")

dates <- seq(as.Date("1978-06-20"), length = nrow(empjobs_all), by = "quarters")
dates <- LastDayInMonth(dates)
empjobs_all <- xts(x = empjobs_all, order.by=dates)
colnames(empjobs_all) <- "Employee Jobs All"

empjobs_retail <- read_excel(empjobs, sheet = 2, range = "AO6:AO167")
empjobs_retail <- xts(x = empjobs_retail, order.by=dates)
colnames(empjobs_retail) <- "Employee Jobs Retail"

#Self-Employed Jobs
url <- "https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/selfemploymentjobsbyindustryjobs04/current/jobs04sep2018.xls"
loc.download <- "selfjobs.xls"
download.file(url,loc.download,mode = "wb")
selfjobs <- "selfjobs.xls"
selfjobs_all <- read_excel(selfjobs, sheet = 2, range = "CH6:CH96")

dates <- seq(as.Date("1996-03-20"), length = nrow(selfjobs_all), by = "quarters")
dates <- LastDayInMonth(dates)
selfjobs_all <- xts(x = selfjobs_all, order.by=dates)
colnames(selfjobs_all) <- "Self-Employed Jobs All"

selfjobs_retail <- read_excel(selfjobs, sheet = 2, range = "AO6:AO96")
selfjobs_retail <- xts(x = selfjobs_retail, order.by=dates)
colnames(selfjobs_retail) <- "Self-Employed Jobs Retail"

#### Get unemployment Data ####

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

#### Get NOMIS Data ####

#Workforce Jobs
nomiswfjobs <- fromJSON("https://www.nomisweb.co.uk/api/v01/dataset/NM_189_1.data.json?geography=2092957699,2092957698,2092957701,2092957700&industry=146800687&employment_status=1&measure=1,2&measures=20100")
nomiswfjobs <- as.data.frame(nomiswfjobs$obs)

#Number of Shops
nomisunits <- fromJSON("https://www.nomisweb.co.uk/api/v01/dataset/NM_141_1.data.json?geography=2092957699,2092957702,2092957701,2092957697,2092957700&industry=138416743,138416751,138416753...138416758,138416761,138416762,138416773...138416775,138416783...138416786,138416791,138416793...138416797,138416803...138416811,138416813,138416814,138416821&employment_sizeband=0&legal_status=0&measures=20100")
nomisunits <- as.data.frame(nomisunits$obs)

#Number of Businesses
nomisenterprises <- fromJSON("https://www.nomisweb.co.uk/api/v01/dataset/NM_142_1.data.json?geography=2092957699,2092957702,2092957701,2092957697,2092957700&industry=138416743,138416751,138416753...138416758,138416761,138416762,138416773...138416775,138416783...138416786,138416791,138416793...138416797,138416803...138416811,138416813,138416814,138416821&employment_sizeband=0&legal_status=0&measures=20100")
nomisenterprises <- as.data.frame(nomisenterprises$obs)

#### Get ASHE Data ####

# ASHE Table 4.6a: Hourly pay - Excluding overtime (£)

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

#rbind

# ASHE Table 5.6a: Hourly pay - Excluding overtime (£)

url <- "https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/regionbyindustry2digitsicashetable5/2018provisional/table52018provisional.zip"
loc.download <- "ashe5.zip"
download.file(url,loc.download,mode = "wb")
ashe4 <- "ashe5.zip"
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

