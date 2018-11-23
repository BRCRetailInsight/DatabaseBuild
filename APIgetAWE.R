library(dplyr)
library(pdfetch)
library(xts)
library(bsts)
library(nomisr)

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

#Time Series - Definitions
# "MGSX" = Unemployment Rate (SA)

unemp <- pdfetch_ONS(c("MGSX"), "LMS")

#### Get NOMIS Data ####

# Generate list of all NOMIS datasets
nomis_data_info <- nomis_data_info()

#Get parameter codes for API
nomis_geo_codes <- nomis_codelist("NM_130_1", "geography")
nomis_ind_codes <- nomis_codelist("NM_130_1", "industry")

#Workforce Jobs
#nomiswfjobs <- nomis_get_data("NM_130_1", date = "latest", geography = "2092957697", select = "37748736")

#Number of Shops
#nomisunits <- nomis_get_data("NM_141_1", date = "latest")

#Number of Businesses
#nomisenterprises <- nomis_get_data("NM_142_1", date = "latest")

#### Get ASHE Data ####


