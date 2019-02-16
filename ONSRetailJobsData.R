#### JOBS03 & JOBS04 Data ####

#Employee Jobs
url <- "https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/employeejobsbyindustryjobs03/current/jobs03sep2018.xls"
loc.download <- "empjobs.xls"
download.file(url,loc.download,mode = "wb")
empjobs <- "empjobs.xls"
empjobs_all <- read_excel(empjobs, sheet = 2, range = cell_limits(c(6, 86), c(NA, 86)))
empjobs_all <- head(empjobs_all, -2)
empjobs_all[[1]] <- as.numeric(empjobs_all[[1]])

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
selfjobs_all[[1]] <- as.numeric(selfjobs_all[[1]])

dates <- seq(as.Date("1996-03-20"), length = nrow(selfjobs_all), by = "quarters")
dates <- LastDayInMonth(dates)
selfjobsquarterly_all <- xts(x = selfjobs_all, order.by=dates)
colnames(selfjobsquarterly_all) <- "Self-Employed Jobs - Whole Economy"

selfjobs_retail <- read_excel(selfjobs, sheet = 2, range = cell_limits(c(6, 41), c(NA, 41)))
selfjobsquarterly_retail <- xts(x = selfjobs_retail, order.by=dates)
colnames(selfjobsquarterly_retail) <- "Self-Employed Jobs - Retail"
