library(dplyr)
library(pdfetch)
library(xts)

#### Bank of England Time Series Creation ####

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


#### Graph Creation ####

library(dygraphs)

# Merge credit xts objects
All_Credit <- merge(boe_secured, boe_conscredit, join = "outer")

# Create BRC Colour Palette
BRCcol <- c("#92278F", "#00BBCE", "#262262", "#E6E7E8")

# Create credit dygraph
dygraph(All_Credit)%>%
  dyOptions(labelsUTC = TRUE, fillGraph=TRUE, stackedGraph = TRUE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", label = "£ millions", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)

# create exchange rate dygraph
dygraph(boe_gbp)%>%
  dyOptions(labelsUTC = TRUE, fillGraph=TRUE, stackedGraph = TRUE, fillAlpha=0.1, drawGrid = FALSE, colors=BRCcol) %>%
  dyAxis("y", drawGrid = TRUE, gridLineColor = "lightgrey") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyRoller(rollPeriod = 1)