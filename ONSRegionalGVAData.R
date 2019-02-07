
#### Regional Output Data ####

#GVA per head (CP)
url <- "https://www.ons.gov.uk/file?uri=/economy/grossvalueaddedgva/datasets/nominalregionalgrossvalueaddedbalancedperheadandincomecomponents/current/nominalregionalgvabperheadandincomecomponents.xlsx"
loc.download <- "gva_per_head_all.xlsx"
download.file(url,loc.download,mode = "wb")
gva_per_head_all <- "gva_per_head_all.xlsx"
dates <- seq(as.Date("1998-12-31"), length = 20, by = "years")
dates <- LastDayInMonth(dates)

#UK
GVAperheaduk <- read_excel(gva_per_head_all, sheet = 5, range = "D3:W3", col_names = FALSE)
GVAperheaduk <- t(GVAperheaduk)
GVAperheaduk <- xts(x = GVAperheaduk, order.by=dates)
colnames(GVAperheaduk) <- "GVA per Head - UK"

#England
GVAperheadengland <- read_excel(gva_per_head_all, sheet = 5, range = "D4:W4", col_names = FALSE)
GVAperheadengland <- t(GVAperheadengland)
GVAperheadengland <- xts(x = GVAperheadengland, order.by=dates)
colnames(GVAperheadengland) <- "GVA per Head - England"

#North East
GVAperheadNE <- read_excel(gva_per_head_all, sheet = 5, range = "D5:W5", col_names = FALSE)
GVAperheadNE <- t(GVAperheadNE)
GVAperheadNE <- xts(x = GVAperheadNE, order.by=dates)
colnames(GVAperheadNE) <- "GVA per Head - North East"

#North West
GVAperheadNW <- read_excel(gva_per_head_all, sheet = 5, range = "D15:W15", col_names = FALSE)
GVAperheadNW <- t(GVAperheadNW)
GVAperheadNW <- xts(x = GVAperheadNW, order.by=dates)
colnames(GVAperheadNW) <- "GVA per Head - North West"

#North Yorkshire & the Humber
GVAperheadyork <- read_excel(gva_per_head_all, sheet = 5, range = "D41:W41", col_names = FALSE)
GVAperheadyork <- t(GVAperheadyork)
GVAperheadyork <- xts(x = GVAperheadyork, order.by=dates)
colnames(GVAperheadyork) <- "GVA per Head - Yorkshire & The Humber"

#East Midlands
GVAperheadEM <- read_excel(gva_per_head_all, sheet = 5, range = "D57:W57", col_names = FALSE)
GVAperheadEM <- t(GVAperheadEM)
GVAperheadEM <- xts(x = GVAperheadEM, order.by=dates)
colnames(GVAperheadEM) <- "GVA per Head - East Midlands"

#West Midlands
GVAperheadWM <- read_excel(gva_per_head_all, sheet = 5, range = "D72:W72", col_names = FALSE)
GVAperheadWM <- t(GVAperheadWM)
GVAperheadWM <- xts(x = GVAperheadWM, order.by=dates)
colnames(GVAperheadWM) <- "GVA per Head - West Midlands"

#East
GVAperheadE <- read_excel(gva_per_head_all, sheet = 5, range = "D90:W90", col_names = FALSE)
GVAperheadE <- t(GVAperheadE)
GVAperheadE <- xts(x = GVAperheadE, order.by=dates)
colnames(GVAperheadE) <- "GVA per Head - East"

#London
GVAperheadLondon <- read_excel(gva_per_head_all, sheet = 5, range = "D110:W110", col_names = FALSE)
GVAperheadLondon <- t(GVAperheadLondon)
GVAperheadLondon <- xts(x = GVAperheadLondon, order.by=dates)
colnames(GVAperheadLondon) <- "GVA per Head - London"

#South East
GVAperheadSE <- read_excel(gva_per_head_all, sheet = 5, range = "D137:W137", col_names = FALSE)
GVAperheadSE <- t(GVAperheadSE)
GVAperheadSE <- xts(x = GVAperheadSE, order.by=dates)
colnames(GVAperheadSE) <- "GVA per Head - South East"

#South West
GVAperheadSW <- read_excel(gva_per_head_all, sheet = 5, range = "D163:W163", col_names = FALSE)
GVAperheadSW <- t(GVAperheadSW)
GVAperheadSW <- xts(x = GVAperheadSW, order.by=dates)
colnames(GVAperheadSW) <- "GVA per Head - South West"

#Wales
GVAperheadwales <- read_excel(gva_per_head_all, sheet = 5, range = "D180:W180", col_names = FALSE)
GVAperheadwales <- t(GVAperheadwales)
GVAperheadwales <- xts(x = GVAperheadwales, order.by=dates)
colnames(GVAperheadwales) <- "GVA per Head - Wales"

#Scotland
GVAperheadscot <- read_excel(gva_per_head_all, sheet = 5, range = "D195:W195", col_names = FALSE)
GVAperheadscot <- t(GVAperheadscot)
GVAperheadscot <- xts(x = GVAperheadscot, order.by=dates)
colnames(GVAperheadscot) <- "GVA per Head - Scotland"

#Northern Ireland
GVAperheadNI <- read_excel(gva_per_head_all, sheet = 5, range = "D224:W224", col_names = FALSE)
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
GVAuk <- read_excel(gva_region, sheet = 3, range = "E58:X58", col_names = FALSE)
GVAuk <- t(GVAuk)
GVAuk <- xts(x = GVAuk, order.by=dates)
colnames(GVAuk) <- "GVA - UK"

#England
GVAengland <- read_excel(gva_region, sheet = 3, range = "E174:X174", col_names = FALSE)
GVAengland <- t(GVAengland)
GVAengland <- xts(x = GVAengland, order.by=dates)
colnames(GVAengland) <- "GVA - England"

#North East
GVANE <- read_excel(gva_region, sheet = 3, range = "E290:X290", col_names = FALSE)
GVANE <- t(GVANE)
GVANE <- xts(x = GVANE, order.by=dates)
colnames(GVANE) <- "GVA - North East"

#North West
GVANW <- read_excel(gva_region, sheet = 3, range = "E406:X406", col_names = FALSE)
GVANW <- t(GVANW)
GVANW <- xts(x = GVANW, order.by=dates)
colnames(GVANW) <- "GVA - North West"

#North Yorkshire & the Humber
GVAyork <- read_excel(gva_region, sheet = 3, range = "E522:X522", col_names = FALSE)
GVAyork <- t(GVAyork)
GVAyork <- xts(x = GVAyork, order.by=dates)
colnames(GVAyork) <- "GVA - Yorkshire & The Humber"

#East Midlands
GVAEM <- read_excel(gva_region, sheet = 3, range = "E638:X638", col_names = FALSE)
GVAEM <- t(GVAEM)
GVAEM <- xts(x = GVAEM, order.by=dates)
colnames(GVAEM) <- "GVA - East Midlands"

#West Midlands
GVAWM <- read_excel(gva_region, sheet = 3, range = "E754:X754", col_names = FALSE)
GVAWM <- t(GVAWM)
GVAWM <- xts(x = GVAWM, order.by=dates)
colnames(GVAWM) <- "GVA - West Midlands"

#East
GVAE <- read_excel(gva_region, sheet = 3, range = "E870:X870", col_names = FALSE)
GVAE <- t(GVAE)
GVAE <- xts(x = GVAE, order.by=dates)
colnames(GVAE) <- "GVA - East"

#London
GVALondon <- read_excel(gva_region, sheet = 3, range = "E986:X986", col_names = FALSE)
GVALondon <- t(GVALondon)
GVALondon <- xts(x = GVALondon, order.by=dates)
colnames(GVALondon) <- "GVA - London"

#South East
GVASE <- read_excel(gva_region, sheet = 3, range = "E1102:X1102", col_names = FALSE)
GVASE <- t(GVASE)
GVASE <- xts(x = GVASE, order.by=dates)
colnames(GVASE) <- "GVA - South East"

#South West
GVASW <- read_excel(gva_region, sheet = 3, range = "E1218:X1218", col_names = FALSE)
GVASW <- t(GVASW)
GVASW <- xts(x = GVASW, order.by=dates)
colnames(GVASW) <- "GVA - South West"

#Wales
GVAwales <- read_excel(gva_region, sheet = 3, range = "E1334:X1334", col_names = FALSE)
GVAwales <- t(GVAwales)
GVAwales <- xts(x = GVAwales, order.by=dates)
colnames(GVAwales) <- "GVA - Wales"

#Scotland
GVAscot <- read_excel(gva_region, sheet = 3, range = "E1450:X1450", col_names = FALSE)
GVAscot <- t(GVAscot)
GVAscot <- xts(x = GVAscot, order.by=dates)
colnames(GVAscot) <- "GVA - Scotland"

#Northern Ireland
GVANI <- read_excel(gva_region, sheet = 3, range = "E1566:X1566", col_names = FALSE)
GVANI <- t(GVANI)
GVANI <- xts(x = GVANI, order.by=dates)
colnames(GVANI) <- "GVA - Northern Ireland"
