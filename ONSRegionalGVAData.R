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

