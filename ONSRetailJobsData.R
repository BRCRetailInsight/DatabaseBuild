
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
