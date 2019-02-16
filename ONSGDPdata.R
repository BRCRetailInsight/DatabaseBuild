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
