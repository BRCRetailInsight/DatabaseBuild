library(dplyr)
library(pdfetch)
library(xts)
library(readxl)
library(bsts)
library(nomisr)
library(jsonlite)
library(httr)
library(SPARQL)
library(utils)

setwd("C:/Users/James.Hardiman/Documents/DatabaseBuild")

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
colnames(gdpquarterly) <- "GDP Quarterly - Whole Economy (?m)"

#### Quartlery GVA, from: "GDP output approach - Low Level Aggregates" ####

#GVA Whole Economy (CP £m)
url <- "https://www.ons.gov.uk/file?uri=/economy/grossdomesticproductgdp/datasets/ukgdpolowlevelaggregates/current/gdplla.xls"
loc.download <- "gva_all.xls"
download.file(url,loc.download,mode = "wb")
gva_all <- "gva_all.xls"
gva_all <- read_excel(gva_all, sheet = 3, range = "D46:D132")

dates <- seq(as.Date("1997-03-20"), length = nrow(gva_all), by = "quarters")
dates <- LastDayInMonth(dates)
GVAquarterly_all <- xts(x = gva_all, order.by=dates)
colnames(GVAquarterly_all) <- "GVA Quarterly - Whole Economy (?m)"

#GVA Retail (CP £m)
gva_retail <- "gva_all.xls"
gva_retail <- read_excel(gva_retail, sheet = 3, range = "CY46:CY132")
GVAquarterly_retail <- xts(x = gva_retail, order.by=dates)
colnames(GVAquarterly_retail) <- "GVA Quarterly - Retail (?m)"

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
empjobs_all <- read_excel(empjobs, sheet = 2, range = "CH6:CH167")

dates <- seq(as.Date("1978-06-20"), length = nrow(empjobs_all), by = "quarters")
dates <- LastDayInMonth(dates)
empjobsquarterly_all <- xts(x = empjobs_all, order.by=dates)
colnames(empjobsquarterly_all) <- "Employee Jobs - Whole Economy"

empjobs_retail <- read_excel(empjobs, sheet = 2, range = "AO6:AO167")
empjobsquarterly_retail <- xts(x = empjobs_retail, order.by=dates)
colnames(empjobsquarterly_retail) <- "Employee Jobs - Retail"

#Self-Employed Jobs
url <- "https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/selfemploymentjobsbyindustryjobs04/current/jobs04sep2018.xls"
loc.download <- "selfjobs.xls"
download.file(url,loc.download,mode = "wb")
selfjobs <- "selfjobs.xls"
selfjobs_all <- read_excel(selfjobs, sheet = 2, range = "CH6:CH96")

dates <- seq(as.Date("1996-03-20"), length = nrow(selfjobs_all), by = "quarters")
dates <- LastDayInMonth(dates)
selfjobsquarterly_all <- xts(x = selfjobs_all, order.by=dates)
colnames(selfjobsquarterly_all) <- "Self-Employed Jobs - Whole Economy"

selfjobs_retail <- read_excel(selfjobs, sheet = 2, range = "AO6:AO96")
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
nomiswfjobs <- fromJSON("https://www.nomisweb.co.uk/api/v01/dataset/NM_189_1.data.json?geography=2092957699,2092957698,2092957701,2092957700&industry=146800687&employment_status=1&measure=1,2&measures=20100")
nomiswfjobs <- as.data.frame(nomiswfjobs$obs)

#Number of Shops
nomisunits <- fromJSON("https://www.nomisweb.co.uk/api/v01/dataset/NM_141_1.data.json?geography=2092957699,2092957702,2092957701,2092957697,2092957700&industry=138416743,138416751,138416753...138416758,138416761,138416762,138416773...138416775,138416783...138416786,138416791,138416793...138416797,138416803...138416811,138416813,138416814,138416821&employment_sizeband=0&legal_status=0&measures=20100")
nomisunits <- as.data.frame(nomisunits$obs)

#Number of Businesses
nomisenterprises <- fromJSON("https://www.nomisweb.co.uk/api/v01/dataset/NM_142_1.data.json?geography=2092957699,2092957702,2092957701,2092957697,2092957700&industry=138416743,138416751,138416753...138416758,138416761,138416762,138416773...138416775,138416783...138416786,138416791,138416793...138416797,138416803...138416811,138416813,138416814,138416821&employment_sizeband=0&legal_status=0&measures=20100")
nomisenterprises <- as.data.frame(nomisenterprises$obs)

#### ASHE Data ####

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
HPlondon <- xts(x=HPlondon, order.by=HPlondon$ukhpi_refMonth)


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
HPscotland <- xts(x=HPscotland, order.by=HPscotland$ukhpi_refMonth)


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
HPwales <- xts(x=HPwales, order.by=HPwales$ukhpi_refMonth)


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
HPnorthern_ireland <- xts(x=HPnorthern_ireland, order.by=HPnorthern_ireland$ukhpi_refMonth)


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
HPengland <- xts(x=HPengland, order.by=HPengland$ukhpi_refMonth)


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
HPnortheast <- xts(x=HPnortheast, order.by=HPnortheast$ukhpi_refMonth)


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
HPnorthwest <- xts(x=HPnorthwest, order.by=HPnorthwest$ukhpi_refMonth)


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
HPyork <- xts(x=HPyork, order.by=HPyork$ukhpi_refMonth)


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
HPeastmid <- xts(x=HPeastmid, order.by=HPeastmid$ukhpi_refMonth)


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
HPwestmid <- xts(x=HPwestmid, order.by=HPwestmid$ukhpi_refMonth)


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
HPeast <- xts(x=HPeast, order.by=HPeast$ukhpi_refMonth)


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
HPsoutheast <- xts(x=HPsoutheast, order.by=HPsoutheast$ukhpi_refMonth)


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
HPsouthwest <- xts(x=HPsouthwest, order.by=HPsouthwest$ukhpi_refMonth)

#### Consumer Price Inflation ####

# ONS Consumer Price Inflation Annual Data (MM23) - Definitions

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

# Fetch data from ONS and convert to month only (so no days)


rsi_vol <- pdfetch_ONS(c("J5EB","J45U", "IDOB","IDOC","IDOA","IDOG","IDOH","IDOH","IDOD","JO4C","J5DK"), "DRSI")
#rsi_vol <- to.monthly(rsi_vol, OHLC=FALSE)

colnames(rsi_vol) <- c("RSI Volumes - All retailing including automotive fuel", "RSI Volumes - All retailing excluding automotive fuel", "RSI Volumes - Predominantly food stores", "RSI Volumes - Predominantly non-food stores", "RSI Volumes - Non-Specialised stores", "RSI Volumes - Textile, clothing and footwear stores", "RSI Volumes - Households goods stores", "RSI Volumes - Other Non-Food Stores", "RSI Volumes - Non-Store retailing", "RSI Volumes - Fuel")

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

colnames(rsi_val) <- c("RSI Values - All retailing including automotive fuel",
                       "RSI Values - All retailing excluding automotive fuel",
                       "RSI Values - All retailing excluding automotive fuel: Large Businesses",
                       "RSI Values - All retailing excluding automotive fuel: Small Businesses",
                       "RSI Values - Predominantly food stores",
                       "RSI Values - Total predominantly non-food stores",
                       "RSI Values - Non-Specialised stores",
                       "RSI Values - Textile, clothing and footwear stores",
                       "RSI Values - Households goods stores",
                       "RSI Values - Other Non - Food Stores",
                       "RSI Values - Non-Store retailing",
                       "RSI Values - Fuel",
                       "RSI Values - Food Stores: Large Businesses",
                       "RSI Values - Food Stores: Small Businesses",
                       "RSI Values - Total Predominantly Non-Food Stores: Large Businesses",
                       "RSI Values - Total Predominantly Non-Food Stores: Small Businesses",
                       "RSI Values - Non-Store retailing: Large Businesses",
                       "RSI Values - Non-Store retailing: Small Businesses",
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


setwd("Z:/Projects/RDataAggregation/")

# Read-in DRI

DRI_Master=read.csv("DRI Master.csv")
DRI_Master=DRI_Master[,c("Mobile_Total.Retail_Share","Total.Retail_Total.Retail_Total.Visits")]

DRI_Master=change(DRI_Master,Var="Total.Retail_Total.Retail_Total.Visits" ,TimeVar="date",NewVar = paste("Visit_growth", sep="_"),slideBy=-12, type="percent")

DRI_Master=DRI_Master[,c("Mobile_Total.Retail_Share","Visit_growth")]
DRI_Master$date<-(seq(ISOdate(2014,08,1), by = "month", length.out = nrow(DRI_Master)))
names(DRI_Master)[1:2]=c("BRC-Hitwise Mobile Share of retail website visits (%)","BRC-Hitwise Growth in retailer website visits (yoy %)")

DRI_Master[,c("BRC-Hitwise Mobile Share of retail website visits (%)")]=DRI_Master[,c("BRC-Hitwise Mobile Share of retail website visits (%)")]*100

#### REM Data ####

REM_emp = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",range="'Headlines & Charts'!e22:dt22",col_names = FALSE,col_types="numeric")*100))
REM_FTemp3mth = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",range="'Headlines & Charts'!e24:dt24",col_names = FALSE,col_types="numeric")*100))
REM_PTemp3mth = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",range="'Headlines & Charts'!e25:dt25",col_names = FALSE,col_types="numeric")*100))
REM_hrs = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",range="'Headlines & Charts'!e28:dt28",col_names = FALSE,col_types="numeric")*100))
REM_FThrs = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",range="'Headlines & Charts'!e29:dt29",col_names = FALSE,col_types="numeric")*100))
REM_PThrs = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",range="'Headlines & Charts'!e30:dt30",col_names = FALSE,col_types="numeric")*100))
REM_stores = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",range="'Headlines & Charts'!e20:dt20",col_names = FALSE,col_types="numeric")*100))
REM_stores3mth = as.data.frame(t(read_excel("Z:/Monitors/rem/Data/REMMaster.xlsm",range="'Headlines & Charts'!e21:dt21",col_names = FALSE,col_types="numeric")*100))

#### Footfall Data ####

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

#### RSM Data ####

RSM=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ci8:ci",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ue8:ue",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_12mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!zf8:zf",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_Online=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!dp8:dp",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_Online_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!em8:em",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_Online_12mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!fj8:fj",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ay8:ay",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_Stores=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!adq8:adq",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL_Stores=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!adt8:adt",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ss8:ss",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL_Food_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!sq8:sq",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_LFL_NF_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!sr8:sr",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100

RSM_Food_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!uc8:uc",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
RSM_NF_3mth=read_excel("Z:/Monitors/rsm/Data/RSM Data 2.0.xlsx", range=paste("UK RSM data!ud8:ud",282+adddateRSM,sep=""),col_names = FALSE,col_types="numeric")*100
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

setwd("C:/Users/James.Hardiman/Documents/DatabaseBuild")


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

#### Database Merge ####

# merge xts objects into one big dataset
database <- merge(cpi_all, cpi_ambient, cpi_books, cpi_clothing, cpi_diy, cpi_electricals, cpi_food, cpi_fresh, cpi_furniture, cpi_health, cpi_nonfood, cpi_othnonfood, spi_all, spi_ambient, spi_books, spi_clothes, spi_diy, spi_electricals, spi_food, spi_fresh, spi_furniture, spi_health, spi_nonfood, spi_othnonfood, awe, boe_ccards, boe_conscredit, boe_gbp, boe_house, boe_secured, employ$`Employment Rate UK`, unemp$`Unemployment Rate UK`, GVAmonthly_mom, GVAmonthly_yoy, rsi_val, rsi_vol, all = TRUE, fill = NA)
databasedf <- data.frame(date=index(database), coredata(database))
